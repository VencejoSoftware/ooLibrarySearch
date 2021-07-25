{$REGION 'documentation'}
{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Windows OS DLL handler object
  @created(10/12/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit LibraryCore;

interface

uses
  SysUtils, Windows, ActiveX,
  Version;

type
{$REGION 'documentation'}
{
  @abstract(Interface for path list)
  @member(
    Version Return library version
    @return(@link(IVersion Version object))
  )
  @member(
    GetMethodAddress Return the method address by name
    @param(MethodName Method name)
    @return(Pointer with the method addres or nil)
  )
}
{$ENDREGION}
  ILibraryCore = interface
    ['{EB3CB7E8-8663-447A-9362-103129F76599}']
    function Version: IVersion;
    function GetMethodAddress(const MethodName: String): Pointer;
  end;


{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILibraryCore))
  @member(Version @seealso(ILibraryCore.Version))
  @member(GetMethodAddress @seealso(ILibraryCore.GetMethodAddress))
  @member(
    ResolveLibraryPath Try to resolve the library file name based in path, or architecture
    @param(LibraryPath Base path to fin library 32 or 64 bits)
    @param(Name Library name)
    @return(Sanitized path)
  )
  @member(
    Create Object constructor, and assign a THandle to the library
  )
  @member(Destroy Object destructor, and free library handle)
  @member(New Create a new @classname as interface)
}
{$ENDREGION}
  TLibraryCore = class sealed(TInterfacedObject, ILibraryCore)
  strict private
  type
    TVersion = function: IVersion; stdcall;
  strict private
    _LibHandle: THandle;
    _Version: TVersion;
  private
    function ResolveLibraryPath(const LibraryPath, Name: String): String;
  public
    function Version: IVersion;
    function GetMethodAddress(const MethodName: String): Pointer;
    constructor Create(const LibraryPath, Name: String);
    destructor Destroy; override;
    class function New(const LibraryPath, Name: String): ILibraryCore;
  end;

implementation

function TLibraryCore.Version: IVersion;
begin
  if Assigned(@_Version) then
    Result := _Version
  else
    Result := nil;
end;

function TLibraryCore.ResolveLibraryPath(const LibraryPath, Name: String): String;
begin
  if Length(ExtractFileName(LibraryPath)) < 1 then
{$IFDEF CPUX64}
    Result := LibraryPath + Name + '64.dll'
{$ELSE}
    Result := LibraryPath + Name + '32.dll'
{$ENDIF}
  else
    Result := LibraryPath;
  Result := ExpandFileName(Result);
end;

function TLibraryCore.GetMethodAddress(const MethodName: String): Pointer;
begin
  Result := GetProcAddress(_LibHandle, PChar(MethodName));
end;

constructor TLibraryCore.Create(const LibraryPath, Name: String);
var
  LibraryFilePath: String;
begin
  CoInitialize(nil);
  LibraryFilePath := ResolveLibraryPath(LibraryPath, Name);
  if not FileExists(LibraryFilePath) then
    raise Exception.Create(Format('%s library path "%s" not found', [Name, LibraryFilePath]));
  _LibHandle := LoadLibrary(PChar(LibraryFilePath));
  if _LibHandle = 0 then
    RaiseLastOSError;
  @_Version := GetProcAddress(_LibHandle, PChar('Version'));
end;

destructor TLibraryCore.Destroy;
begin
  if _LibHandle <> 0 then
    FreeLibrary(_LibHandle);
  CoUninitialize;
  inherited;
end;

class function TLibraryCore.New(const LibraryPath, Name: String): ILibraryCore;
begin
  Result := TLibraryCore.Create(LibraryPath, Name);
end;

end.
