program Test4DFramework;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Test4D.Core in 'Test4D.Core.pas',
  Test4D.Types in 'Test4D.Types.pas',
  Test4D in 'Test4D.pas',
  Test4D.Commands in 'Test4D.Commands.pas',
  Test4D.Configurations in 'Test4D.Configurations.pas',
  Test4D.Languages.EN in 'Test4D.Languages.EN.pas',
  Test4D.Languages.PTBR in 'Test4D.Languages.PTBR.pas',
  Test4D.Totals in 'Test4D.Totals.pas';

begin
  TTest4D.Use(TTest4DLanguagePTBR.New);
  TTest4D.Test('teste assert string quebrado',
  procedure
  begin
    Assert.AreEqual('teste aseert string', 'TesteAssert', 'Teste');
  end);

  TTest4D.Test('teste assert string OK',
  procedure
  begin
    Assert.AreEqual('teste de assert string', 'teste de assert string');
  end);

  TTest4D.Test('teste assert integer quebrado',
  procedure
  begin
    Assert.AreEqual(0, 1);
  end);

  TTest4D.Test('teste assert integer OK',
  procedure
  begin
    Assert.AreEqual(0, 0);
  end);

  TTest4D.Test('teste assert float quebrado',
  procedure
  begin
    Assert.AreEqual(0.00, 0.0001);
  end);

  TTest4D.Test('teste assert float OK',
  procedure
  begin
    Assert.AreEqual(0.00, 0.00);
  end);

  TTest4D.Test('teste assert boolean quebrado',
  procedure
  begin
    Assert.AreEqual(True, False);
  end);

  TTest4D.Test('teste assert boolean OK',
  procedure
  begin
    Assert.AreEqual(True, True);
  end);

  TTest4D.Test('teste erro de código',
  procedure
  begin
    raise Exception.Create('Code Error.');
  end);

  TTest4D.Test('teste willraise quebrado',
  procedure
  begin
    Assert.WillRaise(
    procedure
    begin

    end, Exception);
  end);

  TTest4D.Test('teste willraise ok',
  procedure
  begin
    Assert.WillRaise(
    procedure
    begin
      raise Exception.Create('Error Message');
    end, Exception);
  end);

  TTest4D.Test('teste willnotraise quebrado',
  procedure
  begin
    Assert.WillNotRaise(
    procedure
    begin
      raise Exception.Create('Error Message');
    end);
  end);

  TTest4D.Test('teste willnotraise ok',
  procedure
  begin
    Assert.WillNotRaise(
    procedure
    begin

    end);
  end);

  TTest4D.Run;
end.
