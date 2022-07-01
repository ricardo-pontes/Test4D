unit Test4D.Languages.EN;

interface

uses
  Test4D.Types;

type
  TTest4DLanguageEN = class(TInterfacedObject, iTest4DLanguage)
  private

  public
    class function New : iTest4DLanguage;

    function PrintConsoleFailedTestsMethod : string;
    function PrintConsoleTotalsTotalTests : string;
    function PrintConsoleTotalsTotalSkipped : string;
    function PrintConsoleTotalsTotalPassed : string;
    function PrintConsoleTotalsTotalFailed : string;
    function PrintConsoleTotalsTotalWithErrorsOnCode : string;
    function PrintTestList : string;
    function AssertExceptionExpected : string;
    function AssertExceptionFound : string;
    function AssertExceptionAreNotEqual : string;
    function AssertExceptionWillNotRaise : string;
    function AssertExceptionWillRaise : string;
    function AssertExceptionAreEqualStream : string;
    function AssertExceptionAreNotEqualStream : string;
    function AssertExceptionAreNotEqualMemory : string;
    function AssertExceptionImplements : string;
    function AssertExceptionIsFalse : string;
    function AssertExceptionIsTrue : string;
    function AssertExceptionIsNotNullInterface : string;
    function AssertExceptionIsNotNullPointer : string;
    function AssertExceptionIsNotNullObject : string;
    function AssertExceptionIsNotNullVariant : string;
    function AssertExceptionIsNullInterface : string;
    function AssertExceptionIsNullPointer : string;
    function AssertExceptionIsNullObject : string;
    function AssertExceptionIsNullVariant : string;
  end;

implementation

{ TTest4DLanguageEN }

function TTest4DLanguageEN.AssertExceptionAreEqualStream: string;
begin
  Result := 'Streams are not equal ';
end;

function TTest4DLanguageEN.AssertExceptionAreNotEqual: string;
begin
  Result := ' are equal to ';
end;

function TTest4DLanguageEN.AssertExceptionAreNotEqualMemory: string;
begin
  Result := 'Memory values are equal. ';
end;

function TTest4DLanguageEN.AssertExceptionAreNotEqualStream: string;
begin
  Result := ' are equal to ';
end;

function TTest4DLanguageEN.AssertExceptionExpected: string;
begin
  Result := 'Expected: ';
end;

function TTest4DLanguageEN.AssertExceptionFound: string;
begin
  Result := ' Found: ';
end;

function TTest4DLanguageEN.AssertExceptionImplements: string;
begin
  Result := 'value does not implement ';
end;

function TTest4DLanguageEN.AssertExceptionIsFalse: string;
begin
  Result := 'Condition is True when False expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNotNullInterface: string;
begin
  Result := 'Interface is Nil when not nil expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNotNullObject: string;
begin
  Result := 'Object is Nil when Not Nil expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNotNullPointer: string;
begin
  Result := 'Pointer is Nil when Not Nil expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNotNullVariant: string;
begin
  Result := 'Variant is Null when not Null expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNullInterface: string;
begin
  Result := 'Interface is not nil when nil expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNullObject: string;
begin
  Result := 'Object is not nil when nil expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNullPointer: string;
begin
  Result := 'Pointer is not nil when nil expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsNullVariant: string;
begin
  Result := 'Variant is Not Null when Null expected. ';
end;

function TTest4DLanguageEN.AssertExceptionIsTrue: string;
begin
  Result := 'Condition is False when True expected. ';
end;

function TTest4DLanguageEN.AssertExceptionWillNotRaise: string;
begin
  Result := 'Exception not expected but throwed.';
end;

function TTest4DLanguageEN.AssertExceptionWillRaise: string;
begin
  Result := 'Exception expected but not throwed.'
end;

class function TTest4DLanguageEN.New: iTest4DLanguage;
begin
  Result := Self.Create;
end;

function TTest4DLanguageEN.PrintConsoleFailedTestsMethod: string;
begin
  Result := 'Method ';
end;

function TTest4DLanguageEN.PrintConsoleTotalsTotalFailed: string;
begin
  Result := 'Total Failed: ';
end;

function TTest4DLanguageEN.PrintConsoleTotalsTotalPassed: string;
begin
  Result := 'Total Passed: ';
end;

function TTest4DLanguageEN.PrintConsoleTotalsTotalSkipped: string;
begin
  Result := 'Total Skipped: ';
end;

function TTest4DLanguageEN.PrintConsoleTotalsTotalTests: string;
begin
  Result := 'TotalTests: ';
end;

function TTest4DLanguageEN.PrintConsoleTotalsTotalWithErrorsOnCode: string;
begin
  Result := 'Total with errors in the code: ';
end;

function TTest4DLanguageEN.PrintTestList: string;
begin
  Result := 'Test List';
end;

end.
