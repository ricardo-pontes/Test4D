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
    class procedure FailedTestAreEqual(aValue, aTobe : TValue; aMessage : string);
    class procedure FailedTestAreNotEqual(aValue, aTobe : TValue; aMessage : string);
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

    class procedure WillRaise(const aValue : TProc; aMessage : string = ''); overload;
    class procedure WillRaise(const aValue : TProc; aExceptionClass: ExceptClass = nil; aMessage : string = ''); overload;
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
  begin
    FailedTestAreEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreEqual(const aValue, aTobe: integer; const aMessage : string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
  begin
    FailedTestAreEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Extended; const aMessage : string);
begin
  TTest4DCore.IncValidation;
  if not SameValue(aValue, aTobe, 0) then
  begin
    FailedTestAreEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.WillNotRaise(const aValue: TProc; aMessage : string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  try
    aValue();
  except on E: Exception do
    begin
      if aMessage.IsEmpty then
        TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionWillNotRaise)
      else
        TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionWillNotRaise + ' [' + aMessage + ']');

      Exit;
    end;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.WillRaise(const aValue: TProc; aExceptionClass : ExceptClass = nil; aMessage: string = '');
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  try
    aValue();
  except on E: Exception do
    begin
      if E.ClassType <> aExceptionClass then
      begin
        if aMessage.IsEmpty then
          TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionWillRaiseWithDifExceptionType(aExceptionClass.ClassName, E.ClassName))
        else
          TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionWillRaiseWithDifExceptionType(aExceptionClass.ClassName, E.ClassName) + ' [' + aMessage + ']')
      end
      else
        TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);

      Exit;
    end;
  end;

  if aMessage.IsEmpty then
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionWillRaise)
  else
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionWillRaise + ' [' + aMessage + ']')
end;

class procedure Assert.WillRaise(const aValue : TProc; aMessage : string = '');
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  try
    aValue();
  except on E: Exception do
    TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
  end;

  if aMessage.IsEmpty then
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, TTest4DCore.Configurations.Language.AssertExceptionWillRaise)
  else
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, TTest4DCore.Configurations.Language.AssertExceptionWillRaise + ' [' + aMessage + ']')
end;

class procedure Assert.AreEqual(const aValue, aTobe: Double; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if not SameValue(aValue, aTobe, 0) then
  begin
    FailedTestAreEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Word; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
  begin
    FailedTestAreEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Cardinal; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
  begin
    FailedTestAreEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreEqual(const aValue, aTobe: Boolean; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue <> aTobe then
  begin
    FailedTestAreEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreEqual(const aValue, aTobe: TStream;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not StreamsAreEqual(aValue, aTobe) then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionAreEqualStream)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionAreEqualStream + ' [' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.FailedTestAreEqual(aValue, aTobe: TValue; aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  if aMessage.IsEmpty then
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionExpected + aTobe.ToString + Language.AssertExceptionFound + aValue.ToString)
  else
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionExpected + aTobe.ToString + Language.AssertExceptionFound + aValue.ToString + ' [' + aMessage + ']');
end;

class procedure Assert.FailedTestAreNotEqual(aValue, aTobe: TValue; aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  if aMessage.IsEmpty then
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, aValue.ToString + Language.AssertExceptionAreNotEqual + aTobe.ToString)
  else
    TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, aValue.ToString + Language.AssertExceptionAreNotEqual + aTobe.ToString + ' [' + aMessage + ']');
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Boolean;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
  begin
    FailedTestAreNotEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Cardinal;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
  begin
    FailedTestAreNotEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Word;
  const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
  begin
    FailedTestAreNotEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe, aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
  begin
    FailedTestAreNotEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: integer; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
  begin
    FailedTestAreNotEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: TStream; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not StreamsAreEqual(aValue, aTobe) then
  begin
    TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
    Exit;
  end;

  var lTypeValue := TRttiContext.Create.GetType(aValue);
  var lTypeTobe := TRttiContext.Create.GetType(aTobe);
  try
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, lTypeValue.Name + Language.AssertExceptionAreNotEqualStream + lTypeTobe.Name + ' ' + aMessage)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, lTypeValue.Name + Language.AssertExceptionAreNotEqualStream + lTypeTobe.Name + ' [' + aMessage + ']')
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
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionAreNotEqualMemory)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionAreNotEqualMemory + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class function Assert.Implements<T>(aValue: IInterface;
  const aMessage: string): T;
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not Supports(aValue, GetTypeData(TypeInfo(T)).Guid,result) then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionImplements + GetTypeName(TypeInfo(T)))
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionImplements + GetTypeName(TypeInfo(T)) + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsFalse(const aCondition: boolean;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsFalse)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsFalse + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
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
      raise Test4DExceptionAssert.Create(Language.AssertExceptionIsNotNullInterface + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsNotNull(const aCondition: Pointer;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition = nil then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNotNullPointer)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNotNullPointer + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsNotNull(const aCondition: TObject;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition = nil then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNotNullObject)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNotNullObject + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsNotNull(const aCondition: Variant;
  const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if VarIsNull(aCondition) then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNotNullVariant)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNotNullVariant + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsNull(const aCondition: Variant; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not VarIsNull(aCondition) then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullVariant)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullVariant + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsNull(const aCondition: IInterface; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition <> nil then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullInterface)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullInterface + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsNull(const aCondition: TObject; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition <> nil then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullObject)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullObject + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsNull(const aCondition: Pointer; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if aCondition <> nil then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullPointer)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsNullPointer + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.IsTrue(const aCondition: boolean; const aMessage: string);
begin
  var Language := TTest4DCore.Configurations.Language;
  TTest4DCore.IncValidation;
  if not aCondition then
  begin
    if aMessage.IsEmpty then
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsTrue)
    else
      TTest4DCore.SetFailedTest(TTest4DCore.TestIndex, Language.AssertExceptionIsTrue + '[' + aMessage + ']');

    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: TClass; const aMessage: string);
begin
  TTest4DCore.IncValidation;
  if aValue = aTobe then
  begin
    FailedTestAreNotEqual(aValue.ClassName, aTobe.ClassName, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Double; const aMessage: string);
begin
  if SameValue(aValue, aTobe, 0) then
  begin
    FailedTestAreNotEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

class procedure Assert.AreNotEqual(const aValue, aTobe: Extended; const aMessage: string);
begin
  if SameValue(aValue, aTobe, 0) then
  begin
    FailedTestAreNotEqual(aValue, aTobe, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
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
  begin
    FailedTestAreEqual(aValue.ClassName, aTobe.ClassName, aMessage);
    Exit;
  end;
  TTest4DCore.SetPassedTest(TTest4DCore.TestIndex);
end;

end.
