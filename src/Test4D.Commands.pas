unit Test4D.Commands;

interface

uses
  System.SysUtils,
  System.Rtti,
  System.Math,
  System.Classes,
  Test4D.Types;


type
  Assert = class
  private
    class function StreamsAreEqual(aValue, aTobe : TStream) : boolean;
    class procedure ThrowAssertException(aValue, aTobe : TValue; aMessage : string = '');
    class procedure ThrowAssertExceptionAreNotEqual(aValue, aTobe : TValue; aMessage : string = '');
  public
    class procedure AreEqual(const aValue, aTobe : string; const aMessage : string = ''); overload;
    class procedure AreEqual(const aValue, aTobe : Word; const aMessage : string = ''); overload;
    class procedure AreEqual(const aValue, aTobe : Cardinal; const aMessage : string = ''); overload;
    class procedure AreEqual(const aValue, aTobe : Boolean; const aMessage : string = ''); overload;
    class procedure AreEqual(const aValue, aTobe : integer; const aMessage : string = ''); overload;
    class procedure AreEqual(const aValue, aTobe : Extended; const aMessage : string = ''); overload;
    class procedure AreEqual(const aValue, aTobe : Double; const aMessage : string = ''); overload;
    class procedure AreEqual(const aValue, aTobe : TClass; const aMessage : string = '');overload;
    class procedure AreEqual(const aValue, aTobe : TStream; const aMessage : string = '');overload;

    class procedure AreNotEqual(const aValue, aTobe : string; const aMessage : string = ''); overload;
    class procedure AreNotEqual(const aValue, aTobe : Word; const aMessage : string = ''); overload;
    class procedure AreNotEqual(const aValue, aTobe : Cardinal; const aMessage : string = ''); overload;
    class procedure AreNotEqual(const aValue, aTobe : Boolean; const aMessage : string = ''); overload;
    class procedure AreNotEqual(const aValue, aTobe : integer; const aMessage : string = ''); overload;
    class procedure AreNotEqual(const aValue, aTobe : Extended; const aMessage : string = ''); overload;
    class procedure AreNotEqual(const aValue, aTobe : Double; const aMessage : string = ''); overload;
    class procedure AreNotEqual(const aValue, aTobe : TClass; const aMessage : string = '');overload;
    class procedure AreNotEqual(const aValue, aTobe : TStream; const aMessage : string = '');overload;

    class procedure AreNotEqualMemory(const aValue : Pointer; const aTobe : Pointer; const size : Cardinal; const amessage : string = '');

    class procedure WillRaise(const aValue : TProc);
    class procedure WillNotRaise(const aValue : TProc);
  end;

implementation

{ Assert }

class procedure Assert.AreEqual(const aValue, aTobe : string; const aMessage : string);
begin
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: integer; const aMessage : string);
begin
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Extended; const aMessage : string);
begin
  if not SameValue(aValue, aTobe, 0) then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.ThrowAssertException(aValue, aTobe: TValue; aMessage : string);
begin
  raise Test4DExceptionAssert.Create('Expected: ' + aTobe.ToString + '  Found: ' + aValue.ToString + ' ' + aMessage);
end;

class procedure Assert.ThrowAssertExceptionAreNotEqual(aValue, aTobe: TValue;
  aMessage: string);
begin
  raise Test4DExceptionAssert.Create(aValue.ToString + ' are equal to ' + aTobe.ToString + ' ' + aMessage);
end;

class procedure Assert.WillNotRaise(const aValue: TProc);
begin
  try
    aValue();
  except on E: Exception do
    raise Test4DExceptionThrowedWillNotRaise.Create('Exception not expected but throwed');
  end;

  raise Test4DExceptionNotThrowedWillNotRaise.Create('');
end;

class procedure Assert.WillRaise(const aValue: TProc);
begin
  try
    aValue();
  except on E: Exception do
    raise Test4DExceptionThrowedWillRaise.Create(E.Message);
  end;

  raise Test4DExceptionNotThrowedWillRaise.Create('Exception expected but not throwed');
end;

class procedure Assert.AreEqual(const aValue, aTobe: Double; const aMessage: string);
begin
  if not SameValue(aValue, aTobe, 0) then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Word; const aMessage: string);
begin
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Cardinal; const aMessage: string);
begin
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Boolean; const aMessage: string);
begin
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: TStream;
  const aMessage: string);
begin
  if not StreamsAreEqual(aValue, aTobe) then
    raise Test4DExceptionAssert.Create('Streams are not equal ' + aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Boolean;
  const aMessage: string);
begin
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Cardinal;
  const aMessage: string);
begin
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Word;
  const aMessage: string);
begin
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe, aMessage: string);
begin
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: integer;
  const aMessage: string);
begin
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: TStream;
  const aMessage: string);
begin
  if not StreamsAreEqual(aValue, aTobe) then
    Exit;

  var lTypeValue := TRttiContext.Create.GetType(aValue);
  var lTypeTobe := TRttiContext.Create.GetType(aTobe);
  try
    raise Test4DExceptionAssert.Create(lTypeValue.Name + ' are equal to ' + lTypeTobe.Name + ' ' + aMessage);
  finally
    lTypeValue.DisposeOf;
    lTypeTobe.DisposeOf;
  end;
end;

class procedure Assert.AreNotEqualMemory(const aValue, aTobe: Pointer;
  const size: Cardinal; const amessage: string);
begin
  if CompareMem(aValue, aTobe, size) then
    raise Test4DExceptionAssert.Create('Memory values are equal ' + aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: TClass;
  const aMessage: string);
begin
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue.ClassName, aTobe.ClassName, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Double;
  const aMessage: string);
begin
  if SameValue(aValue, aTobe, 0) then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Extended;
  const aMessage: string);
begin
  if SameValue(aValue, aTobe, 0) then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class function Assert.StreamsAreEqual(aValue, aTobe: TStream): boolean;
const
  BlockSize = 4096;
var
  Buffer1: array[0..BlockSize - 1] of byte;
  Buffer2: array[0..BlockSize - 1] of byte;
  BufferLen: integer;
begin
  Result := False;

  if aValue.Size = aTobe.Size then
  begin
    aValue.Position := 0;
    aTobe.Position := 0;

    while aValue.Position < aValue.Size do
    begin
      BufferLen := aValue.Read(Buffer1, BlockSize);
      aTobe.Read(Buffer2, BlockSize);
      if not CompareMem(@Buffer1, @Buffer2, BufferLen) then
        exit;
    end;

    Result := True;
  end;
end;

class procedure Assert.AreEqual(const aValue, aTobe: TClass;
  const aMessage: string);
begin
  if aValue <> aTobe then
    ThrowAssertException(aValue.ClassName, aTobe.ClassName, aMessage);
end;

end.
