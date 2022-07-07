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
  Result := 'Streams n�o s�o iguais ';
end;

function TTest4DLanguagePTBR.AssertExceptionAreNotEqual: string;
begin
  Result := ' � igual a ';
end;

function TTest4DLanguagePTBR.AssertExceptionAreNotEqualMemory: string;
begin
  Result := 'Os valores de Memory s�o iguais. ';
end;

function TTest4DLanguagePTBR.AssertExceptionAreNotEqualStream: string;
begin
  Result := ' � igual a ';
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
  Result := 'O valor n�o implementa ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsFalse: string;
begin
  Result := 'Condi��o � True quando False � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullInterface: string;
begin
  Result := 'Interface � nil quando nil n�o � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullObject: string;
begin
  Result := 'Object � nil quando nil n�o � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullPointer: string;
begin
  Result := 'Pointer � nil quando nil n�o � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNotNullVariant: string;
begin
  Result := 'Variant � Null quando Null n�o � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullInterface: string;
begin
  Result := 'Interface n�o � nil quando nil � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullObject: string;
begin
  Result := 'Object n�o � nil quando nil � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullPointer: string;
begin
  Result := 'Pointer n�o � nil quando nil � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsNullVariant: string;
begin
  Result := 'Variant n�o � Null quando Null � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionIsTrue: string;
begin
  Result := 'Condi��o � False quando True � esperado. ';
end;

function TTest4DLanguagePTBR.AssertExceptionWillNotRaise: string;
begin
  Result := 'Exception n�o � esperado, mas aconteceu. ';
end;

function TTest4DLanguagePTBR.AssertExceptionWillRaise: string;
begin
  Result := 'Exception esperado, mas n�o aconteceu. '
end;

function TTest4DLanguagePTBR.AssertExceptionWillRaiseWithDifExceptionType(aExpect, aActual: string): string;
begin
  Result := 'Exce��o lan�ada, mas n�o � igual. Esperado: ' + aExpect + ' Lan�ada: ' + aActual;
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
  Result := 'M�todo ';
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
  Result := 'Total de Testes com erros no c�digo: ';
end;

function TTest4DLanguagePTBR.PrintTestList: string;
begin
  Result := 'Lista de Testes:';
end;

end.
