unit Test4D.Commands;

interface

uses
  System.SysUtils,
  System.Rtti,
  System.Math,
  System.Classes,
  System.TypInfo,
  System.Variants,
  Test4D.Types,
  Test4D.Core;


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

    class procedure WillRaise(const aValue : TProc; aMessage : string = '');
    class procedure WillNotRaise(const aValue: TProc; aMessage : string = '');

    class function Implements<T : IInterface>(aValue : IInterface; const aMessage : string = '' ) : T;

    class procedure IsTrue(const aCondition : boolean; const aMessage : string = '');
    class procedure IsFalse(const aCondition : boolean; const aMessage : string = '');

    class procedure IsNull(const aCondition : TObject; const aMessage : string = '');overload;
    class procedure IsNull(const aCondition : Pointer; const aMessage : string = '');overload;
    class procedure IsNull(const aCondition : IInterface; const aMessage : string = '');overload;
    class procedure IsNull(const aCondition : Variant; const aMessage : string = '');overload;

    class procedure IsNotNull(const aCondition : TObject; const aMessage : string = '');overload;
    class procedure IsNotNull(const aCondition : Pointer; const aMessage : string = '');overload;
    class procedure IsNotNull(const aCondition : IInterface; const aMessage : string = '');overload;
    class procedure IsNotNull(const aCondition : Variant; const aMessage : string = '');overload;
  end;

implementation

{ Assert }

class procedure Assert.AreEqual(const aValue, aTobe : string; const aMessage : string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: integer; const aMessage : string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Extended; const aMessage : string);
begin
  TTest4DCore.IncValidation;
  if not SameValue(aValue, aTobe, 0) then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.ThrowAssertException(aValue, aTobe: TValue; aMessage : string);
begin
  var Language := TTest4DCore.Configurations.Language;
  if aMessage.IsEmpty then
    raise Test4DExceptionAssert.Create(Language.AssertExceptionExpected + aTobe.ToString + Language.AssertExceptionFound + aValue.ToString)
  else
    raise Test4DExceptionAssert.Create(Language.AssertExceptionExpected + aTobe.ToString + Language.AssertExceptionFound + aValue.ToString + ' [' + aMessage + ']');
end;

class procedure Assert.ThrowAssertExceptionAreNotEqual(aValue, aTobe: TValue;
  aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  if aMessage.IsEmpty then
    raise Test4DExceptionAssert.Create(aValue.ToString + Language.AssertExceptionAreNotEqual + aTobe.ToString)
  else
    raise Test4DExceptionAssert.Create(aValue.ToString + Language.AssertExceptionAreNotEqual + aTobe.ToString + ' [' + aMessage + ']');
end;

class procedure Assert.WillNotRaise(const aValue: TProc; aMessage : string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  try
    aValue();
  except on E: Exception do
    if aMessage.IsEmpty then
      raise Test4DExceptionThrowedWillNotRaise.Create(Language.AssertExceptionWillNotRaise)
    else
      raise Test4DExceptionThrowedWillNotRaise.Create(Language.AssertExceptionWillNotRaise + ' [' + aMessage + ']')
  end;

  raise Test4DExceptionNotThrowedWillNotRaise.Create('');
end;

class procedure Assert.WillRaise(const aValue : TProc; aMessage : string = '');
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  try
    aValue();
  except on E: Exception do
    raise Test4DExceptionThrowedWillRaise.Create(E.Message);
  end;

  if aMessage.IsEmpty then
    raise Test4DExceptionNotThrowedWillRaise.Create(TTest4DCore.Configurations.Language.AssertExceptionWillRaise)
  else
    raise Test4DExceptionNotThrowedWillRaise.Create(TTest4DCore.Configurations.Language.AssertExceptionWillRaise + ' [' + aMessage + ']')
end;

class procedure Assert.AreEqual(const aValue, aTobe: Double; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if not SameValue(aValue, aTobe, 0) then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Word; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Cardinal; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Boolean; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
    ThrowAssertException(aValue, aTobe, aMessage);
end;

class procedure Assert.AreEqual(const aValue, aTobe: TStream;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not StreamsAreEqual(aValue, aTobe) then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionAreEqualStream)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionAreEqualStream + ' [' + aMessage + ']');
  end;
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Boolean;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Cardinal;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Word;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe, aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: integer;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
    ThrowAssertExceptionAreNotEqual(aValue, aTobe, aMessage);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: TStream;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not StreamsAreEqual(aValue, aTobe) then
    Exit;

  var lTypeValue := TRttiContext.Create.GetType(aValue);
  var lTypeTobe := TRttiContext.Create.GetType(aTobe);
  try
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(lTypeValue.Name + Language.AssertExceptionAreNotEqualStream + lTypeTobe.Name + ' ' + aMessage)
    else
      raise Test4DExceptionAssert.Create(lTypeValue.Name + Language.AssertExceptionAreNotEqualStream + lTypeTobe.Name + ' [' + aMessage + ']')
  finally
    lTypeValue.DisposeOf;
    lTypeTobe.DisposeOf;
  end;
end;

class procedure Assert.AreNotEqualMemory(const aValue, aTobe: Pointer;
  const size: Cardinal; const amessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if CompareMem(aValue, aTobe, size) then
  begin
    if amessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionAreNotEqualMemory)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionAreNotEqualMemory + '[' + aMessage + ']');
  end;
end;

class function Assert.Implements<T>(aValue: IInterface;
  const aMessage: string): T;
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not Supports(aValue, GetTypeData(TypeInfo(T)).Guid,result) then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionImplements + GetTypeName(TypeInfo(T)) + aMessage)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionImplements + GetTypeName(TypeInfo(T)) + aMessage);
  end;
end;

class procedure Assert.IsFalse(const aCondition: boolean;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsFalse)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsFalse + aMessage);
  end;
end;

class procedure Assert.IsNotNull(const aCondition: IInterface;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition = nil then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullInterface)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullInterface + aMessage);
  end;
end;

class procedure Assert.IsNotNull(const aCondition: Pointer;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition = nil then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullPointer)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullPointer + aMessage);
  end;
end;

class procedure Assert.IsNotNull(const aCondition: TObject;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition = nil then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullObject)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullObject + aMessage);
  end;
end;

class procedure Assert.IsNotNull(const aCondition: Variant;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if VarIsNull(aCondition) then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullVariant)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullVariant + aMessage);
  end;
end;

class procedure Assert.IsNull(const aCondition: Variant; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not VarIsNull(aCondition) then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullVariant)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullVariant + aMessage);
  end;
end;

class procedure Assert.IsNull(const aCondition: IInterface; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition <> nil then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullInterface)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullInterface + aMessage);
  end;
end;

class procedure Assert.IsNull(const aCondition: TObject; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition <> nil then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullObject)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullObject + aMessage);
  end;
end;

class procedure Assert.IsNull(const aCondition: Pointer; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition <> nil then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullPointer)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNullPointer + aMessage);
  end;
end;

class procedure Assert.IsTrue(const aCondition: boolean; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not aCondition then
  begin
    if aMessage.IsEmpty then
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsTrue)
    else
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsTrue + aMessage);
  end;
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: TClass;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
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
