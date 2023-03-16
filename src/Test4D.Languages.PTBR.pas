unit Test4D.Languages.PTBR;

interface

uses
  Test4D.Types;

type
  TTest4DLanguagePTBR = class(TInterfacedObject, iTest4DLanguage)
  private

  public
    class function New : iTest4DLanguage;

    function PrintConsoleFailedTestsMethod : string;
    function PrintConsoleTotalsTotalTests : string;
    function PrintConsoleTotalsTotalSkipped : string;
    function PrintConsoleTotalsTotalPassed : string;
    function PrintConsoleTotalsTotalFailed : string;
    function PrintConsoleTotalsTotalWithErrorsOnCode : string;
    function PrintConsoleExitMessage : string;
    function PrintTestList : string;
    function AssertExceptionExpected : string;
    function AssertExceptionFound : string;
    function AssertExceptionAreNotEqual : string;
    function AssertExceptionWillNotRaise : string;
    function AssertExceptionWillRaise : string;
    function AssertExceptionWillRaiseWithDifExceptionType(aExpect, aActual : string) : string;
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

{ TTest4DLanguagePTBR }

function TTest4DLanguagePTBR.AssertExceptionAreEqualStream: string;
begin
  Result := 'Streams não são iguais ';
end;

function TTest4DLanguagePTBR.AssertExceptionAreNotEqual: string;
begin
  Result := ' é igual a ';
end;

function TTest4DLanguagePTBR.AssertExceptionAreNotEqualMemory: string;
begin
  Result := 'Os valores de Memory são iguais. ';
end;

function TTest4DLanguagePTBR.AssertExceptionAreNotEqualStream: string;
begin
  Result := ' é igual a ';
end;

function TTest4DLanguagePTBR.AssertExceptionExpected: string;
begin
  Result := 'Experado: ';
end;

function TTest4DLanguagePTBR.AssertExceptionFound: string;
begin
  Result := ' Encontrado: ';
end;

function TTest4DLanguagePTBR.AssertExceptionImplements: string;
begin
  Result := 'O valor não implementa ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsFalse: string;
begin
  Result := 'Condição é True quando False é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullInterface: string;
begin
  Result := 'Interface é nil quando nil não é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullObject: string;
begin
  Result := 'Object é nil quando nil não é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullPointer: string;
begin
  Result := 'Pointer é nil quando nil não é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullVariant: string;
begin
  Result := 'Variant é Null quando Null não é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullInterface: string;
begin
  Result := 'Interface não é nil quando nil é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullObject: string;
begin
  Result := 'Object não é nil quando nil é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullPointer: string;
begin
  Result := 'Pointer não é nil quando nil é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullVariant: string;
begin
  Result := 'Variant não é Null quando Null é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsTrue: string;
begin
  Result := 'Condição é False quando True é esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionWillNotRaise: string;
begin
  Result := 'Exception não é esperado, mas aconteceu. ';
end;

function TTest4DLanguagePTBR.AssertExceptionWillRaise: string;
begin
  Result := 'Exception esperado, mas não aconteceu. '
end;

function TTest4DLanguagePTBR.AssertExceptionWillRaiseWithDifExceptionType(aExpect, aActual: string): string;
begin
  Result := 'Exceção lançada, mas não é igual. Esperado: ' + aExpect + ' Lançada: ' + aActual;
end;

class function TTest4DLanguagePTBR.New: iTest4DLanguage;
begin
  Result := Self.Create;
end;

function TTest4DLanguagePTBR.PrintConsoleExitMessage: string;
begin
  Result := '<Pressione qualquer tecla para sair>';
end;

function TTest4DLanguagePTBR.PrintConsoleFailedTestsMethod: string;
begin
  Result := 'Método ';
end;

function TTest4DLanguagePTBR.PrintConsoleTotalsTotalFailed: string;
begin
  Result := 'Total de Testes com Falhas: ';
end;

function TTest4DLanguagePTBR.PrintConsoleTotalsTotalPassed: string;
begin
  Result := 'Total de Testes Passados: ';
end;

function TTest4DLanguagePTBR.PrintConsoleTotalsTotalSkipped: string;
begin
  Result := 'Total de Testes Pulados: ';
end;

function TTest4DLanguagePTBR.PrintConsoleTotalsTotalTests: string;
begin
  Result := 'Total de Testes: ';
end;

function TTest4DLanguagePTBR.PrintConsoleTotalsTotalWithErrorsOnCode: string;
begin
  Result := 'Total de Testes com erros no código: ';
end;

function TTest4DLanguagePTBR.PrintTestList: string;
begin
  Result := 'Lista de Testes:';
end;

end.
