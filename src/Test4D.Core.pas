unit Test4D.Core;

interface

uses
  System.SysUtils,
  System.Generics.Collections, Test4D.Types, Winapi.Windows;

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
    class var FTests : TDictionary<string, TTestMethod>;
    class var FTotalTests : integer;
    class var FTotalTestsPassed : integer;
    class var FTotalTestsSkipped : integer;
    class var FTotalTestsFailed : integer;
    class var FTotalTestsWithCodeErrors : integer;
    class var FDefaultInstance : TTest4DCore;
    class procedure AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc);
    class procedure SetFailedTest(var aTest : TTestMethod; aStatusMessage : string);
    class procedure SetCodeErrorTest(var aTest : TTestMethod; aStatusMessage : string);
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

    class function Test(aName : string; aMethod : TProc) : TTest4DCore;
    class function TestOnly(aName : string; aMethod : TProc) : TTest4DCore;
    class function Skip(aName : string; aMethod : TProc) : TTest4DCore;
    class procedure Run;
    class function Version : string;
  end;

const
  TEST4D_VERSION = '1.0.2';

implementation

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
  FTests.Add(aName, lTestMethod);
end;

constructor TTest4DCore.Create;
begin
  FTests := TDictionary<string, TTestMethod>.Create;
  FDefaultInstance := Self;
end;

class destructor TTest4DCore.Destroy;
begin
  FTests.DisposeOf;
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
  for var lKey in FTests.Keys do
  begin
    var lTestMethod : TTestMethod;
    FTests.TryGetValue(lKey, lTestMethod);
    if lTestMethod.Status = TTestMethodStatus.Only then
    begin
      Result := True;
      Break;
    end;
  end;
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
  WriteLn('8  Version: ' + Version + '                                    8');
  Writeln('8  Created by Ricardo Pontes | github.com/ricardo-pontes       8');
  Writeln('8888888888888888888888888888888888888888888888888888888888888888');
  WriteLn('');
end;

class procedure TTest4DCore.PrepareTestsForUniqueTest;
var
  lKey : string;
  lTestMethod : TTestMethod;
begin
  for lKey in FTests.Keys do
  begin
    FTests.TryGetValue(lKey, lTestMethod);
    if not (lTestMethod.Status = TTestMethodStatus.Only) then
    begin
      lTestMethod.Status := TTestMethodStatus.Skipped;
      FTests.AddOrSetValue(lKey, lTestMethod);
      Continue;
    end;
    lTestMethod.Status := TTestMethodStatus.Active;
    FTests.AddOrSetValue(lKey, lTestMethod);      
  end; 
end;

class procedure TTest4DCore.PrintConsoleFailedTests;
begin
  WriteLn('');
  for var lKey in FTests.Keys do
  begin
    var lTestMethod := FTests.Items[lKey];
    if lTestMethod.Status = TTestMethodStatus.Failed then
    begin
      SetColorConsole(TConsoleColor.Red);
      WriteLn('');
      Writeln('Method ' + lTestMethod.Name + ':');
      WriteLn('  * ' + lTestMethod.StatusMessage);
    end
    else if lTestMethod.Status = TTestMethodStatus.CodeError then
    begin
      SetColorConsole(TConsoleColor.Maroon);
      WriteLn('');
      Writeln('Method ' + lTestMethod.Name + ':');
      WriteLn('  * ' + lTestMethod.StatusMessage);
    end;
  end;
end;

class procedure TTest4DCore.PrintConsoleTotals;
begin
  Writeln('Total Tests: ' + FTotalTests.ToString);
  WriteLn('Total Skipped: ' + FTotalTestsSkipped.ToString);
  SetColorConsole(TConsoleColor.Green);
  WriteLn('Total Passed: ' + FTotalTestsPassed.ToString);
  SetColorConsole(TConsoleColor.Red);
  WriteLn('Total Failed: ' + FTotalTestsFailed.ToString);
  SetColorConsole(TConsoleColor.Maroon);
  WriteLn('Total with code errors: ' + FTotalTestsWithCodeErrors.ToString);
end;

class procedure TTest4DCore.SetFailedTest(var aTest : TTestMethod; aStatusMessage : string);
begin
  Inc(FTotalTestsFailed);
  aTest.Status        := TTestMethodStatus.Failed;
  aTest.StatusMessage := aStatusMessage;
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
  FTotalTests               := FTests.Count;

  lHasTestOnly := HasTestOnly;
  if lHasTestOnly then
    PrepareTestsForUniqueTest;
    
  for var lKey in FTests.Keys do
  begin
    var lTestMethod : TTestMethod;
    FTests.TryGetValue(lKey, lTestMethod);
    SetColorConsole(TConsoleColor.Gray);
    Writeln(lTestMethod.Name);
    SetColorConsole(TConsoleColor.White);
    if lTestMethod.Status = TTestMethodStatus.Skipped then
    begin
      Inc(FTotalTestsSkipped);
      Continue;
    end;

    try
      lTestMethod.Method();
      Inc(FTotalTestsPassed);
    except on E: Exception do
      begin
        if E is Test4DExceptionAssert then
          SetFailedTest(lTestMethod, E.Message)
        else if E is Test4DExceptionNotThrowedWillRaise then
          SetFailedTest(lTestMethod, E.Message)
        else if E is Test4DExceptionThrowedWillRaise then
          Inc(FTotalTestsPassed)     
        else if E is Test4DExceptionNotThrowedWillNotRaise then
          Inc(FTotalTestsPassed)
        else if E is Test4DExceptionThrowedWillNotRaise then
          SetFailedTest(lTestMethod, E.Message)     
        else     
          SetCodeErrorTest(lTestMethod, E.Message);

        FTests.AddOrSetValue(lKey, lTestMethod);
        Continue;
      end;
    end;
  end;

  WriteLn('');
  PrintConsoleTotals;
  PrintConsoleFailedTests;
  Readln;
end;

class procedure TTest4DCore.SetCodeErrorTest(var aTest : TTestMethod; aStatusMessage : string);
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
