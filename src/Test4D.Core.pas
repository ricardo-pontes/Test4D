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
    class procedure AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc);
    class procedure SetFailedTest(aIndex : integer; aStatusMessage : string);
    class procedure SetCodeErrorTest(aTest : TTestMethod; aStatusMessage : string);
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
    class function Test(aName : string; aMethod : TProc) : TTest4DCore;
    class function TestOnly(aName : string; aMethod : TProc) : TTest4DCore;
    class function Skip(aName : string; aMethod : TProc) : TTest4DCore;
    class procedure Run;
    class function Version : string;
  end;

const
  TEST4D_VERSION = '1.2.1';

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

class procedure TTest4DCore.AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc);
begin
  var lTestMethod : TTestMethod;
  lTestMethod.Status := aStatus;
  lTestMethod.Name   := aName;
  lTestMethod.Method := aMethod;
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

//    FTests.TryGetValue(lKey, lTestMethod);
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
  WriteLn('8                                                              8');
  Writeln('8  88888888  88888888  88888888  88888888  88    88  888888    8');
  Writeln('8     88     88        88           88     88    88  88   88   8');
  Writeln('8     88     88888888  88888888     88     88888888  88    88  8');
  Writeln('8     88     88              88     88           88  88   88   8');
  Writeln('8     88     88888888  88888888     88           88  888888    8');
  WriteLn('8                                                              8');
  WriteLn('8  Version: ' + Version + '                                              8');
  Writeln('8  Created by Ricardo Pontes | github.com/ricardo-pontes       8');
  Writeln('8888888888888888888888888888888888888888888888888888888888888888');
  WriteLn('');
end;

class procedure TTest4DCore.PrepareTestsForUniqueTest;
var
  lKey : string;
  lTestMethod : TTestMethod;
begin
  for var I := 0 to Pred(FTests.Count) do
  begin
//    FTests.TryGetValue(lKey, lTestMethod);
    if not (FTests.Items[I].Status = TTestMethodStatus.Only) then
    begin
      lTestMethod := FTests.ExtractAt(I);
      lTestMethod.Status := TTestMethodStatus.Skipped;
      FTests.Add(lTestMethod);
      Continue;
    end;
    lTestMethod := FTests.ExtractAt(I);
    lTestMethod.Status := TTestMethodStatus.Active;
    FTests.Add(lTestMethod);
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
//  aTest.Status        := TTestMethodStatus.Failed;
//  aTest.StatusMessage := aStatusMessage;
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
      FTests.Items[I].Method();
      Inc(FTotalTestsPassed);
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
          SetCodeErrorTest(FTests.Items[I], E.Message);

//        FTests.AddOrSetValue(lKey, lTestMethod);
        Continue;
      end;
    end;
  end;

  WriteLn('');
  PrintConsoleFailedTests;
  PrintConsoleTotals;
  Readln;
end;

class procedure TTest4DCore.SetCodeErrorTest(aTest : TTestMethod; aStatusMessage : string);
begin
  Inc(FTotalTestsWithCodeErrors);
  aTest.Status        := TTestMethodStatus.CodeError;
  aTest.StatusMessage := aStatusMessage;
end;

class function TTest4DCore.Skip(aName : string; aMethod : TProc) : TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Skipped, aName, aMethod);
end;

class function TTest4DCore.Test(aName : string; aMethod : TProc) : TTest4DCore;
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
