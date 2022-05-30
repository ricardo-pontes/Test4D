unit Test4D.Commands;

interface

uses
  System.SysUtils,
  System.Rtti, Test4D.Types;


type
  TTest4DCommands = class
  private
    class procedure ThrowAssertException(aValue, aTobe : TValue);
  public
    class procedure Assert<T>(aValue, aTobe : T);
    class procedure WillRaise(aValue : TProc);
    class procedure WillNotRaise(aValue : TProc);
  end;

implementation

{ TTest4DCommands }

class procedure TTest4DCommands.Assert<T>(aValue, aTobe: T);
var
  LValue : TValue;
  lToBe : TValue;
begin
  LValue := TValue.From<T>(aValue);
  lToBe := TValue.From<T>(aTobe);
  case LValue.Kind of
    tkInteger    : if LValue.AsInteger <> lToBe.AsInteger then ThrowAssertException(lValue, lToBe);
    tkChar       : if LValue.AsString <> lToBe.AsString then ThrowAssertException(lValue, lToBe);
    tkFloat      : if LValue.AsExtended <> lToBe.AsExtended then ThrowAssertException(lValue, lToBe);
    tkString     : if LValue.AsString <> lToBe.AsString then ThrowAssertException(lValue, lToBe);
    tkWChar      : if LValue.AsString <> lToBe.AsString then ThrowAssertException(lValue, lToBe);
    tkLString    : if LValue.AsString <> lToBe.AsString then ThrowAssertException(lValue, lToBe);
    tkWString    : if LValue.AsString <> lToBe.AsString then ThrowAssertException(lValue, lToBe);
    tkInt64      : if LValue.AsInt64 <> lToBe.AsInt64 then ThrowAssertException(lValue, lToBe);
    tkUString    : if LValue.AsString <> lToBe.AsString then ThrowAssertException(lValue, lToBe);
    tkUnknown    : ;
    tkEnumeration: ;
    tkSet        : ;
    tkClass      : ;
    tkMethod     : ;
    tkDynArray   : ;
    tkVariant    : ;
    tkArray      : ;
    tkRecord     : ;
    tkInterface  : ;
    tkClassRef   : ;
    tkPointer    : ;
    tkProcedure  : ;
    tkMRecord    : ;
  end;
end;

class procedure TTest4DCommands.ThrowAssertException(aValue, aTobe: TValue);
begin
  raise Test4DExceptionAssert.Create('Expected: ' + aValue.ToString + '  Found: ' + aToBe.ToString);
end;

class procedure TTest4DCommands.WillNotRaise(aValue: TProc);
begin
  try
    aValue();
  except on E: Exception do
    raise Test4DExceptionThrowedWillNotRaise.Create('Exception not expected but throwed');
  end;

  raise Test4DExceptionNotThrowedWillNotRaise.Create('');
end;

class procedure TTest4DCommands.WillRaise(aValue: TProc);
begin
  try
    aValue();
  except on E: Exception do
    raise Test4DExceptionThrowedWillRaise.Create(E.Message);
  end;

  raise Test4DExceptionNotThrowedWillRaise.Create('Exception expected but not throwed');
end;

end.
