unit Test4D.Types;

interface

uses
  System.SysUtils;

type
  iTest4DLanguage = interface
    ['{716FE025-BA96-4FF6-A3C7-D106AF8D00CF}']
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

  Test4DException = class(Exception)

  end;

  Test4DExceptionAssert = class(Test4DException)

  end;

  Test4DExceptionThrowedWillRaise = class(Test4DException)

  end;

  Test4DExceptionNotThrowedWillRaise = class(Test4DException)

  end;

  Test4DExceptionThrowedWillNotRaise = class(Test4DException)

  end;

  Test4DExceptionNotThrowedWillNotRaise = class(Test4DException)

  end;

implementation

end.
