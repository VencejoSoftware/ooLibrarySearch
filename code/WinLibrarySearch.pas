{$REGION 'documentation'}
{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Windows OS DLL path finder object
  @created(10/12/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit WinLibrarySearch;

interface

uses
  SysUtils, Windows, ShlObj, StrUtils, Types,
  LibrarySeach;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILibrarySeach))
  Windows OS dll path finder
  @member(BasePathList @seealso(ILibrarySeach.BasePathList))
  @member(Find @seealso(ILibrarySeach.Find))
  @member(
    GetSpecialFolderPath Use OS API to get special folder path
    @param(CSIDLFolder Windows special folder identifier)
    @return(Windows special folder path)
  )
  @member(
    LoadBasePathArray Take constructor param to add in internal list
    @param(BasePathArray Open array parameter with paths to include in Find)
  )
  @member(
    LoadWindowsPath Add several special folder paths to list calling GetSpecialFolderPath
  )
  @member(
    LoadEnvironmentPaths Load environment variables paths, splitting text in values and expand paths %TAG%
  )
  @member(
    Create Object constructor
    @param(BasePathArray Open array parameter with paths to include in Find)
  )
  @member(
    New Create a new @classname as interface
    @param(BasePathArray Open array parameter with paths to include in Find)
  )
}
{$ENDREGION}
  TWinLibrarySeach = class sealed(TInterfacedObject, ILibrarySeach)
  strict private
    _BasePathList: IPathList;
  private
    function GetSpecialFolderPath(const CSIDLFolder: Integer): TPath;
    procedure LoadBasePathArray(const BasePathArray: array of TPath);
    procedure LoadWindowsPath;
    procedure LoadEnvironmentPaths;
  public
    function BasePathList: IPathList;
    function Find(const LibFileName: WideString): TPath;
    constructor Create(const BasePathArray: array of TPath);
    class function New(const BasePathArray: array of TPath): ILibrarySeach;
  end;

implementation

function TWinLibrarySeach.BasePathList: IPathList;
begin
  Result := _BasePathList;
end;

function TWinLibrarySeach.Find(const LibFileName: WideString): TPath;
var
  Path: TPath;
begin
  Result := EmptyWideStr;
  for Path in _BasePathList do
    if FileExists(Path + LibFileName) then
      Exit(Path + LibFileName);
  raise ELibrarySeach.Create(Format('Library file "%s" not found', [LibFileName]));
end;

function TWinLibrarySeach.GetSpecialFolderPath(const CSIDLFolder: Integer): TPath;
var
  FilePath: array [0 .. MAX_PATH] of WideChar;
begin
  SHGetSpecialFolderPathW(0, FilePath, CSIDLFolder, False);
  Result := FilePath;
end;

procedure TWinLibrarySeach.LoadWindowsPath;
const
  SPECIAL_FOLDERS: array [0 .. 3] of Integer = (CSIDL_COMMON_APPDATA, CSIDL_WINDOWS, CSIDL_SYSTEM, CSIDL_SYSTEMX86);
var
  CSIDLFolder: Integer;
begin
  for CSIDLFolder in SPECIAL_FOLDERS do
    _BasePathList.Add(GetSpecialFolderPath(CSIDLFolder));
end;

procedure TWinLibrarySeach.LoadEnvironmentPaths;
var
  Paths: String;
  ArrayString: TStringDynArray;
  Path: TPath;
  ExpandedPath: array [0 .. MAX_PATH] of WideChar;
begin
  Paths := GetEnvironmentVariable('PATH');
  ArrayString := SplitString(Paths, ';');
  for Path in ArrayString do
  begin
    ExpandEnvironmentStringsW(PWideChar(Path), ExpandedPath, Length(Path));
    _BasePathList.Add(ExpandedPath);
  end;
end;

procedure TWinLibrarySeach.LoadBasePathArray(const BasePathArray: array of TPath);
var
  Path: TPath;
begin
  for Path in BasePathArray do
    _BasePathList.Add(Path);
end;

constructor TWinLibrarySeach.Create(const BasePathArray: array of TPath);
begin
  _BasePathList := TPathList.New;
  LoadBasePathArray(BasePathArray);
  _BasePathList.Add(ExtractFileDir(ParamStr(0)));
  LoadWindowsPath;
  LoadEnvironmentPaths;
end;

class function TWinLibrarySeach.New(const BasePathArray: array of TPath): ILibrarySeach;
begin
  Result := TWinLibrarySeach.Create(BasePathArray);
end;

end.
