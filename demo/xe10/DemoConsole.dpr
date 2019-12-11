program DemoConsole;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  SysUtils,
  LibrarySeach in '..\..\code\LibrarySeach.pas',
  WinLibrarySearch in '..\..\code\WinLibrarySearch.pas';

begin
  try
    WriteLn(Format('Path: %s', [TWinLibrarySeach.New(['C:\']).Find('twain_32.dll')]));
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
