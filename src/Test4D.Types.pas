unit Test4D.Types;

interface

uses
  System.SysUtils;

type
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
