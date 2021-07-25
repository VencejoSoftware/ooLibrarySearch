{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit LibrarySeach_test;

interface

uses
  SysUtils, DateUtils,
  LibrarySeach,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TPathListTest = class sealed(TTestCase)
  strict private
    _List: IPathList;
  public
    procedure SetUp; override;
  published
    procedure CountReturn3Items;
    procedure ExpandedItemsReturnLongText;
  end;

implementation

procedure TPathListTest.CountReturn3Items;
begin
  CheckEquals(3, _List.Count);
end;

procedure TPathListTest.ExpandedItemsReturnLongText;
begin
  CheckTrue(_List.First <> '.\');
end;

procedure TPathListTest.SetUp;
begin
  inherited;
  _List := TPathList.New;
  _List.Add('.\');
  _List.Add('..\');
  _List.Add('\');
end;

initialization

RegisterTest(TPathListTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
