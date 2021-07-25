{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  RunTest,
  LibrarySeach in '..\..\code\LibrarySeach.pas',
  LibrarySeach_test in '..\code\LibrarySeach_test.pas',
  WinLibrarySearch_test in '..\code\WinLibrarySearch_test.pas',
  WinLibrarySearch in '..\..\code\WinLibrarySearch.pas',
  LibraryCore in '..\..\code\LibraryCore.pas';

{R *.RES}

begin
  Run;

end.
