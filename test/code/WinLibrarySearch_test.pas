{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit WinLibrarySearch_test;

interface

uses
  SysUtils, DateUtils,
  LibrarySeach, WinLibrarySearch,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TWinLibrarySeachTest = class sealed(TTestCase)
  published
    procedure ShdocvwDllReturnSystemPath;
    procedure PepitoDllReturnError;
    procedure PathListCountReturnIsGreaterThan3;
  end;

implementation

{ TWinLibrarySeachTest }

procedure TWinLibrarySeachTest.PathListCountReturnIsGreaterThan3;
var
  LibrarySeach: ILibrarySeach;
begin
  LibrarySeach := TWinLibrarySeach.New(['.\', '..\', '\']);
  CheckTrue(LibrarySeach.BasePathList.Count > 3);
end;

procedure TWinLibrarySeachTest.PepitoDllReturnError;
var
  LibrarySeach: ILibrarySeach;
  Failed: Boolean;
begin
  LibrarySeach := TWinLibrarySeach.New([]);
  Failed := False;
  try
    CheckEquals('pepito.dll', LibrarySeach.Find('pepito.dll'));
  except
    on E: ELibrarySeach do
    begin
      Failed := True;
      CheckEquals('Library file "pepito.dll" not found', E.Message);
    end;
  end;
  CheckTrue(Failed);
end;

procedure TWinLibrarySeachTest.ShdocvwDllReturnSystemPath;
var
  LibrarySeach: ILibrarySeach;
begin
  LibrarySeach := TWinLibrarySeach.New([]);
  CheckEquals('C:\WINDOWS\system32\shdocvw.dll', LibrarySeach.Find('shdocvw.dll'));
end;

initialization

RegisterTest(TWinLibrarySeachTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
