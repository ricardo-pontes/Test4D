unit Test4D.Core;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  Rest.JSON,
  Winapi.Windows,
  Test4D.Configurations,
  Test4D.Languages.EN,
  Test4D.Types, Test4D.Totals;

type
  {$SCOPEDENUMS ON}
  TTestMethodStatus = (None, Active, Only, Skipped, Failed, CodeError, Passed);
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
    class var FTotalValidations : integer;
    class var FDefaultInstance : TTest4DCore;
    class var FConfigurations : TTest4DConfigurations;
    class var FAbort : boolean;
    class var FAbortMessage : string;
    class var FTestIndex : integer;
    class var FTotals : TTest4DTotals;

    class procedure AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc; aBeforeTest : Tproc = nil; aAfterTest : TProc = nil);
    class procedure SetCodeErrorTest(aIndex : integer; aStatusMessage : string);
    class procedure SetColorConsole(AColor:TConsoleColor);
    class function GetDefaultInstance : TTest4DCore;
    class procedure PrintConsoleHeader;
    class procedure PrintConsoleTotals;
    class procedure PrintConsoleFailedTests;
    class function HasTestOnly : boolean;
    class procedure PrepareTestsForUniqueTest;
    class function GetConfigurations: TTest4DConfigurations; static;
    class function GetTotals: TTest4DTotals; static;
  public
    constructor Create;
    class destructor Destroy;
    class function Use(aLanguage : iTest4DLanguage) : TTest4DCore;
    class procedure SetFailedTest(aIndex : integer; aStatusMessage : string);
    class procedure SetPassedTest(aIndex : integer);
    class procedure IncValidation;
    class procedure IncFailedTest(aIndex : integer; aMessage : string);
    class function TestIndex : integer;
    class function Test(aName : string; aMethod : TProc) : TTest4DCore; overload;
    class function Test(aName : string; aMethod : TProc; aBeforeTest : TProc) : TTest4DCore; overload;
    class function Test(aName : string; aMethod : TProc; aBeforeTest : TProc; aAfterTest : TProc) : TTest4DCore; overload;
    class function TestOnly(aName : string; aMethod : TProc) : TTest4DCore; overload;
    class function TestOnly(aName : string; aMethod : TProc; aBeforeTest : TProc) : TTest4DCore; overload;
    class function TestOnly(aName : string; aMethod : TProc; aBeforeTest : TProc; aAfterTest : TProc) : TTest4DCore; overload;
    class function Skip(aName : string; aMethod : TProc) : TTest4DCore; overload;
    class function Skip(aName : string; aMethod : TProc; aBeforeTest : TProc) : TTest4DCore; overload;
    class function Skip(aName : string; aMethod : TProc; aBeforeTest : TProc; aAfterTest : TProc) : TTest4DCore; overload;
    class procedure Run;
    class function Version : string;
    class property Configurations : TTest4DConfigurations read GetConfigurations;
    class property Totals : TTest4DTotals read GetTotals;
    class procedure ConsoleLog(aValue : TObject);
  end;

const
  TEST4D_VERSION = '1.4.2';
  UTF8_CHECKMARK = #$E2#$9C#$93;

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

class procedure TTest4DCore.AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc; aBeforeTest : Tproc = nil; aAfterTest : TProc = nil);
begin
  if aStatus = TTestMethodStatus.Only then
  begin
    for var lTest in FTests do
    begin
      if lTest.Status = TTestMethodStatus.Only then
      begin
        FAbortMessage := 'TestOnly exists. Method: ' + lTest.Name;
        FAbort := True;
        Exit;
      end;
    end;
  end;
  var lTestMethod : TTestMethod;
  lTestMethod.Status := aStatus;
  lTestMethod.Name   := aName;
  lTestMethod.Method := aMethod;
  lTestMethod.BeforeTest := aBeforeTest;
  lTestMethod.AfterTest := aAfterTest;
  FTests.Add(lTestMethod);
end;

class procedure TTest4DCore.ConsoleLog(aValue: TObject);
var
  lJSON : TJSONObject;
  lJSONArray : TJSONArray;
  lObject : TObject;
begin
  if aValue.ClassName.Contains('TObjectList<') then begin
    lJSONArray := TJSONArray.Create;
    for lObject in TObjectList<TObject>(aValue) do begin
      lJSON := TJson.ObjectToJsonObject(lObject);
      lJSONArray.Add(lJSON);
    end;
    try
      Writeln(lJSONArray.Format());
    finally
      lJSONArray.DisposeOf;
    end;
  end
  else begin
    lJSON := TJson.ObjectToJSONObject(aValue);
    try
      Writeln(lJSON.Format());
    finally
      lJSON.DisposeOf;
    end;
  end;
end;

constructor TTest4DCore.Create;
begin
  FTests := TList<TTestMethod>.Create;
  FDefaultInstance := Self;
  FConfigurations := TTest4DConfigurations.Create;
  FConfigurations.Language := TTest4DLanguageEN.New;
  FTotals := TTest4DTotals.Create(FDefaultInstance);
end;

class destructor TTest4DCore.Destroy;
begin
  FTests.DisposeOf;
  if Assigned(FDefaultInstance) then
    FDefaultInstance.DisposeOf;

  if Assigned(FConfigurations) then
    FConfigurations.DisposeOf;

  if Assigned(FTotals) then
    FTotals.DisposeOf;
  inherited;
end;

class function TTest4DCore.GetConfigurations: TTest4DConfigurations;
begin
  GetDefaultInstance;
  Result := FConfigurations;
end;

class function TTest4DCore.GetDefaultInstance : TTest4DCore;
begin
  if not Assigned(FDefaultInstance) then
    FDefaultInstance := TTest4DCore.Create;

  Result := FDefaultInstance;
end;

class function TTest4DCore.GetTotals: TTest4DTotals;
begin
  GetDefaultInstance;
  Result := FTotals;
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

class procedure TTest4DCore.IncFailedTest(aIndex : integer; aMessage : string);
begin
  SetFailedTest(aIndex, aMessage);
end;

class procedure TTest4DCore.IncValidation;
begin
  Inc(FTotalValidations);
end;

class procedure TTest4DCore.PrintConsoleHeader;
begin
  Writeln('88888888888888888888888888888888888888888888888888888888888');
  Writeln('8           TEST4D (C) 2022 - Apache License 2.0          8');
  WriteLn('8                                                         8');
  WriteLn('8  Version: ' + Version + '                                         8');
  Writeln('8  Created by Ricardo Pontes | github.com/ricardo-pontes  8');
  Writeln('88888888888888888888888888888888888888888888888888888888888');
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
      Writeln(FConfigurations.Language.PrintConsoleFailedTestsMethod + FTests.Items[I].Name + ':');
      WriteLn('  * ' + FTests.Items[I].StatusMessage);
    end
    else if FTests.Items[I].Status = TTestMethodStatus.CodeError then
    begin
      WriteLn('');
      SetColorConsole(TConsoleColor.Maroon);
      Writeln(FConfigurations.Language.PrintConsoleFailedTestsMethod + FTests.Items[I].Name + ':');
      WriteLn('  * ' + FTests.Items[I].StatusMessage);
    end;
  end;
end;

class procedure TTest4DCore.PrintConsoleTotals;
begin
  SetColorConsole(TConsoleColor.White);
  WriteLn('');
  Writeln(FConfigurations.Language.PrintConsoleTotalsTotalTests + FTotals.TotalTests);
  WriteLn(FConfigurations.Language.PrintConsoleTotalsTotalSkipped + FTotals.TotalSkippedTests);
  SetColorConsole(TConsoleColor.Green);
  WriteLn(FConfigurations.Language.PrintConsoleTotalsTotalPassed + FTotals.TotalPassedTests);
  SetColorConsole(TConsoleColor.Red);
  WriteLn(FConfigurations.Language.PrintConsoleTotalsTotalFailed + FTotals.TotalFailedTests);
  SetColorConsole(TConsoleColor.Maroon);
  WriteLn(FConfigurations.Language.PrintConsoleTotalsTotalWithErrorsOnCode + FTotals.TotalErrorInCodeTests);
end;

class procedure TTest4DCore.SetFailedTest(aIndex : integer; aStatusMessage : string);
begin
  if (FTests.Items[aIndex].Status = TTestMethodStatus.Failed) or (FTests.Items[aIndex].Status = TTestMethodStatus.Passed) then
    Exit;

  var lTestMethod := FTests.ExtractAt(aIndex);
  lTestMethod.Status := TTestMethodStatus.Failed;
  lTestMethod.StatusMessage := aStatusMessage;
  FTests.Insert(aIndex, lTestMethod);
  FTotals.IncFailedTest;
end;

class procedure TTest4DCore.SetPassedTest(aIndex: integer);
begin
  if (FTests.Items[aIndex].Status = TTestMethodStatus.Failed) or (FTests.Items[aIndex].Status = TTestMethodStatus.Passed) then
    Exit;

  var lTestMethod := FTests.ExtractAt(aIndex);
  lTestMethod.Status := TTestMethodStatus.Passed;
  FTests.Insert(aIndex, lTestMethod);
  FTotals.IncPassedTest;
end;

class function TTest4DCore.Skip(aName: string; aMethod, aBeforeTest: TProc): TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Skipped, aName, aMethod, aBeforeTest, nil);
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
  if FAbort then
  begin
    Writeln('');
    Writeln(FAbortMessage);
    Readln;
    Exit;
  end;

  if FConfigurations.ShowTestList = True then
    Writeln(FConfigurations.Language.PrintTestList);

  FTotals.Init;
  FTotals.TotalTests(FTests.Count);

  lHasTestOnly := HasTestOnly;
  if lHasTestOnly then
    PrepareTestsForUniqueTest;

  for var I := 0 to Pred(FTests.Count) do
  begin
    FTestIndex := I;
    SetColorConsole(TConsoleColor.Gray);
    if FConfigurations.ShowTestList then
      Writeln(FTests.Items[I].Name);
    SetColorConsole(TConsoleColor.White);
    if FTests.Items[I].Status = TTestMethodStatus.Skipped then
    begin
      FTotals.IncSkippedTest;
      Continue;
    end;

    try
      if Assigned(FTests.Items[I].BeforeTest) then
        FTests.Items[I].BeforeTest();

      FTests.Items[I].Method();

      if Assigned(FTests.Items[I].AfterTest) then
        FTests.Items[I].AfterTest();
    except on E: Exception do
      begin
        SetCodeErrorTest(I, E.Message);
        Continue;
      end;
    end;
  end;

  WriteLn('');
  PrintConsoleTotals;
  PrintConsoleFailedTests;
  SetColorConsole(TConsoleColor.White);
  WriteLn('');
  Writeln(FConfigurations.Language.PrintConsoleExitMessage);
  Readln;
end;

class procedure TTest4DCore.SetCodeErrorTest(aIndex : integer; aStatusMessage : string);
begin
  FTotals.IncErrorInCodeTest;
  var lTestMethod := FTests.ExtractAt(aIndex);
  lTestMethod.Status := TTestMethodStatus.CodeError;
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

class function TTest4DCore.TestIndex: integer;
begin
  Result := FTestIndex;
end;

class function TTest4DCore.TestOnly(aName: string; aMethod, aBeforeTest: TProc): TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Only, aName, aMethod, aBeforeTest, nil);
end;

class function TTest4DCore.Test(aName: string; aMethod, aBeforeTest: TProc): TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Active, aName, aMethod, aBeforeTest, nil);
end;

class function TTest4DCore.TestOnly(aName: string; aMethod, aBeforeTest, aAfterTest: TProc): TTest4DCore;
begin
  Result := GetDefaultInstance;
  AddMethod(TTestMethodStatus.Only, aName, aMethod, aBeforeTest, aAfterTest);
end;

class function TTest4DCore.Use(aLanguage: iTest4DLanguage): TTest4DCore;
begin
  Result := GetDefaultInstance;
  FConfigurations.Language := aLanguage;
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
