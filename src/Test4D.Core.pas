unit Test4D.Core;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Winapi.Windows;

type
  {$SCOPEDENUMS ON}
  TTestMethodStatus = (None, Active, Only, Skipped, Failed, CodeError);
  TConsoleColor = (White, Gray, Green, Red, Maroon);
  {$SCOPEDENUMS OFF}

  TTestMethod = record
    Status : TTestMethodStatus;
    StatusMessage : string;
    Name : string;
    Method : TProc;
    BeforeTest : TProc;
    AfterTest : TProc;
  end;

  TTest4DCore = class
  private
    class var FTests : TList<TTestMethod>;
    class var FTotalTests : integer;
    class var FTotalTestsPassed : integer;
    class var FTotalTestsSkipped : integer;
    class var FTotalTestsFailed : integer;
    class var FTotalTestsWithCodeErrors : integer;
    class var FTotalValidations : integer;
    class var FDefaultInstance : TTest4DCore;
    class procedure AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc; aBeforeTest : Tproc = nil; aAfterTest : TProc = nil);
    class procedure SetFailedTest(aIndex : integer; aStatusMessage : string);
    class procedure SetCodeErrorTest(aIndex : integer; aStatusMessage : string);
    class procedure SetColorConsole(AColor:TConsoleColor);
    class function GetDefaultInstance : TTest4DCore;
    class procedure PrintConsoleHeader;
    class procedure PrintConsoleTotals;
    class procedure PrintConsoleFailedTests;
    class function HasTestOnly : boolean;
    class procedure PrepareTestsForUniqueTest;
  public
    constructor Create;
    class destructor Destroy;
    class procedure IncValidation;
    class function Test(aName : string; aMethod : TProc) : TTest4DCore; overload;
    class function Test(aName : string; aMethod : TProc; aBeforeTest : TProc; aAfterTest : TProc) : TTest4DCore; overload;
    class function TestOnly(aName : string; aMethod : TProc) : TTest4DCore; overload;
    class function TestOnly(aName : string; aMethod : TProc; aBeforeTest : TProc; aAfterTest : TProc) : TTest4DCore; overload;
    class function Skip(aName : string; aMethod : TProc) : TTest4DCore; overload;
    class function Skip(aName : string; aMethod : TProc; aBeforeTest : TProc; aAfterTest : TProc) : TTest4DCore; overload;
    class procedure Run;
    class function Version : string;
  end;

const
  TEST4D_VERSION = '1.3.1';
  UTF8_CHECKMARK = #$E2#$9C#$93;

implementation

uses
  Test4D.Types;

{ TTest4DCore }

class procedure TTest4DCore.SetColorConsole(AColor:TConsoleColor);
begin
  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
  case AColor of
    TConsoleColor.White:  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), 15);
    TConsoleColor.Gray:   SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_INTENSITY);
    TConsoleColor.Red:    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED or FOREGROUND_INTENSITY);
    TConsoleColor.Green:  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_GREEN or FOREGROUND_INTENSITY);
    TConsoleColor.Maroon: SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_GREEN or FOREGROUND_RED or FOREGROUND_INTENSITY);
//    clBlue:   SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_BLUE or FOREGROUND_INTENSITY);
//    clPurple: SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED or FOREGROUND_BLUE or FOREGROUND_INTENSITY);
//    clAqua: SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN or FOREGROUND_BLUE or FOREGROUND_INTENSITY);
  end;
end;

class procedure TTest4DCore.AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc; aBeforeTest : Tproc = nil; aAfterTest : TProc = nil);
begin
  var lTestMethod : TTestMethod;
  lTestMethod.Status := aStatus;
  lTestMethod.Name   := aName;
  lTestMethod.Method := aMethod;
  lTestMethod.BeforeTest := aBeforeTest;
  lTestMethod.AfterTest := aAfterTest;
  FTests.Add(lTestMethod);
end;

constructor TTest4DCore.Create;
begin
  FTests := TList<TTestMethod>.Create;
  FDefaultInstance := Self;
end;

class destructor TTest4DCore.Destroy;
begin
  FTests.DisposeOf;
  if Assigned(FDefaultInstance) then
    FDefaultInstance.DisposeOf;

  inherited;
end;

class function TTest4DCore.GetDefaultInstance : TTest4DCore;
begin
  if not Assigned(FDefaultInstance) then
    FDefaultInstance := TTest4DCore.Create;

  Result := FDefaultInstance;
end;

class function TTest4DCore.HasTestOnly: boolean;
begin
  Result := False;
  for var lTestMethod in FTests do
  begin
    if lTestMethod.Status = TTestMethodStatus.Only then
    begin
      Result := True;
      Break;
    end;
  end;
end;

class procedure TTest4DCore.IncValidation;
begin
  Inc(FTotalValidations);
end;

class procedure TTest4DCore.PrintConsoleHeader;
begin
  Writeln('8888888888888888888888888888888888888888888888888888888888888888');
  Writeln('8             TEST4D (C) 2022 - Apache License 2.0             8');
  WriteLn('8                                                              8');
  WriteLn('8  Version: ' + Version + '                                              8');
  Writeln('8  Created by Ricardo Pontes | github.com/ricardo-pontes       8');
  Writeln('8888888888888888888888888888888888888888888888888888888888888888');
  WriteLn('');
end;

class procedure TTest4DCore.PrepareTestsForUniqueTest;

begin
  for var I := 0 to Pred(FTests.Count) do
  begin
    if not (FTests.Items[I].Status = TTestMethodStatus.Only) then
    begin
      var lTestMethod := FTests.Extract(FTests.Items[I]);
      lTestMethod.Status := TTestMethodStatus.Skipped;
      FTests.Insert(I, lTestMethod);
      Continue;
    end;
    var lTestMethod := FTests.Extract(FTests.Items[I]);
    lTestMethod.Status := TTestMethodStatus.Active;
    FTests.Insert(I, lTestMethod);
  end;
end;

class procedure TTest4DCore.PrintConsoleFailedTests;
begin
  WriteLn('');
  for var I := 0 to Pred(FTests.Count) do
  begin
    if FTests.Items[I].Status = TTestMethodStatus.Failed then
    begin
      SetColorConsole(TConsoleColor.Red);
      WriteLn('');
      Writeln('Method ' + FTests.Items[I].Name + ':');
      WriteLn('  * ' + FTests.Items[I].StatusMessage);
    end
    else if FTests.Items[I].Status = TTestMethodStatus.CodeError then
    begin
      SetColorConsole(TConsoleColor.Maroon);
      WriteLn('');
      Writeln('Method ' + FTests.Items[I].Name + ':');
      WriteLn('  * ' + FTests.Items[I].StatusMessage);
    end;
  end;
end;

class procedure TTest4DCore.PrintConsoleTotals;
begin
  SetColorConsole(TConsoleColor.White);
  WriteLn('');
  Writeln('Total Tests: ' + FTotalTests.ToString);
  WriteLn('Total Skipped: ' + FTotalTestsSkipped.ToString);
  SetColorConsole(TConsoleColor.Green);
  WriteLn('Total Passed: ' + FTotalTestsPassed.ToString);
  SetColorConsole(TConsoleColor.Red);
  WriteLn('Total Failed: ' + FTotalTestsFailed.ToString);
  SetColorConsole(TConsoleColor.Maroon);
  WriteLn('Total with errors in the code: ' + FTotalTestsWithCodeErrors.ToString);
end;

class procedure TTest4DCore.SetFailedTest(aIndex : integer; aStatusMessage : string);
begin
  Inc(FTotalTestsFailed);
  var lTestMethod := FTests.ExtractAt(aIndex);
  lTestMethod.Status := TTestMethodStatus.Failed;
  lTestMethod.StatusMessage := aStatusMessage;
  FTests.Insert(aIndex, lTestMethod);
end;

class function TTest4DCore.Skip(aName: string; aMethod, aBeforeTest, aAfterTest: TProc): TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Skipped, aName, aMethod, aBeforeTest, aAfterTest);
end;

class procedure TTest4DCore.Run;
var
  lHasTestOnly : boolean;
begin
  PrintConsoleHeader;

  Writeln('Test List');

  FTotalTestsPassed         := 0;
  FTotalTestsSkipped        := 0;
  FTotalTestsFailed         := 0;
  FTotalTestsWithCodeErrors := 0;
  FTotalValidations         := 0;

  FTotalTests               := FTests.Count;

  lHasTestOnly := HasTestOnly;
  if lHasTestOnly then
    PrepareTestsForUniqueTest;

  for var I := 0 to Pred(FTests.Count) do
  begin
    SetColorConsole(TConsoleColor.Gray);
    Writeln(FTests.Items[I].Name);
    SetColorConsole(TConsoleColor.White);
    if FTests.Items[I].Status = TTestMethodStatus.Skipped then
    begin
      Inc(FTotalTestsSkipped);
      Continue;
    end;

    try
      if Assigned(FTests.Items[I].BeforeTest) then
        FTests.Items[I].BeforeTest();

      FTests.Items[I].Method();
      Inc(FTotalTestsPassed);

      if Assigned(FTests.Items[I].AfterTest) then
        FTests.Items[I].AfterTest();
    except on E: Exception do
      begin
        if E is Test4DExceptionAssert then
          SetFailedTest(I, E.Message)
        else if E is Test4DExceptionNotThrowedWillRaise then
          SetFailedTest(I, E.Message)
        else if E is Test4DExceptionThrowedWillRaise then
          Inc(FTotalTestsPassed)
        else if E is Test4DExceptionNotThrowedWillNotRaise then
          Inc(FTotalTestsPassed)
        else if E is Test4DExceptionThrowedWillNotRaise then
          SetFailedTest(I, E.Message)
        else
          SetCodeErrorTest(I, E.Message);

        Continue;
      end;
    end;
  end;

  WriteLn('');
  PrintConsoleFailedTests;
  PrintConsoleTotals;
  Readln;
end;

class procedure TTest4DCore.SetCodeErrorTest(aIndex : integer; aStatusMessage : string);
begin
  Inc(FTotalTestsWithCodeErrors);
  var lTestMethod := FTests.ExtractAt(aIndex);
  lTestMethod.Status := TTestMethodStatus.Failed;
  lTestMethod.StatusMessage := aStatusMessage;
  FTests.Insert(aIndex, lTestMethod);
end;

class function TTest4DCore.Skip(aName : string; aMethod : TProc) : TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Skipped, aName, aMethod);
end;

class function TTest4DCore.Test(aName : string; aMethod : TProc; aBeforeTest : TProc; aAfterTest : TProc) : TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Active, aName, aMethod, aBeforeTest, aAfterTest);
end;

class function TTest4DCore.TestOnly(aName: string; aMethod, aBeforeTest, aAfterTest: TProc): TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Only, aName, aMethod, aBeforeTest, aAfterTest);
end;

class function TTest4DCore.Test(aName: string; aMethod: TProc): TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Active, aName, aMethod);
end;

class function TTest4DCore.TestOnly(aName : string; aMethod : TProc) : TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Only, aName, aMethod);
end;

class function TTest4DCore.Version: string;
begin
  Result := TEST4D_VERSION;
end;

end.
