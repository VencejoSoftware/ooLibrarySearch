{$REGION 'documentation'}
{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Library path finder object
  @created(10/12/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit LibrarySeach;

interface

uses
  SysUtils,
  List, IterableList;

type
{$REGION 'documentation'}
{
  @abstract(Path finder error)
}
{$ENDREGION}
  ELibrarySeach = class sealed(Exception)

  end;
{$REGION 'documentation'}
{
  @abstract(Path type)
}
{$ENDREGION}

  TPath = WideString;

{$REGION 'documentation'}
{
  @abstract(Interface for path list)
  @member(
    Add Add a new path only if exists
    @param(Path Directory path)
    @return(Item index if added, 0 if not directory exists)
  )
}
{$ENDREGION}

  IPathList = interface(IIterableList<TPath>)
    ['{CACD9B32-4068-4429-890D-7C52373F0412}']
    function Add(const Path: TPath): TIntegerIndex;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IPathList))
  @member(Add @seealso(IPathList.Add))
  @member(
    SanitizePath Take a path, trim, expand and sanitize
    @param(Path Raw path to sanitize)
    @return(Sanitized path)
  )
  @member(Create Object constructor)
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TPathList = class sealed(TIterableList<TPath>, IPathList)
  private
    function SanitizePath(const Path: TPath): TPath;
  public
    function Add(const Path: TPath): TIntegerIndex; override;
    class function New: IPathList;
  end;

{$REGION 'documentation'}
{
  @abstract(Interface for library path finder)
  Search for a library path using a list of paths
  @member(
    BasePathList List of path to include in directory search
    @return(@link(IPathList Path list))
  )
  @member(
    Find Execute directory Find
    @param(LibFileName Library file name)
    @return(Path if exists or empty value if not)
  )
}
{$ENDREGION}

  ILibrarySeach = interface
    ['{169F6B1C-9C8B-425D-B723-1A1DE5CE947C}']
    function BasePathList: IPathList;
    function Find(const LibFileName: TPath): TPath;
  end;

implementation

function TPathList.SanitizePath(const Path: TPath): TPath;
begin
  Result := IncludeTrailingPathDelimiter(ExpandFileName(Trim(Path)));
end;

function TPathList.Add(const Path: TPath): TIntegerIndex;
begin
  if DirectoryExists(Path) then
    Result := inherited Add(SanitizePath(Path))
  else
    Result := 0;
end;

class function TPathList.New: IPathList;
begin
  Result := TPathList.Create;
end;

end.
