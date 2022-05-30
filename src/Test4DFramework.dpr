program Test4DFramework;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Test4D.Core in 'Test4D.Core.pas',
  Test4D.Types in 'Test4D.Types.pas',
  Test4D in 'Test4D.pas',
  Test4D.Commands in 'Test4D.Commands.pas';

begin
  TTest4D.Test('teste assert string quebrado',
  procedure
  begin
    TTest4DCommands.Assert<string>('teste aseert string', 'TesteAssert');
  end);

  TTest4D.Test('teste assert string OK',
  procedure
  begin
    TTest4DCommands.Assert<string>('teste de assert string', 'teste de assert string');
  end);

  TTest4D.Test('teste assert integer quebrado',
  procedure
  begin
    TTest4DCommands.Assert<integer>(0, 1);
  end);

  TTest4D.Test('teste assert integer OK',
  procedure
  begin
    TTest4DCommands.Assert<integer>(0, 0);
  end);

  TTest4D.Test('teste assert float quebrado',
  procedure
  begin
    TTest4DCommands.Assert<Extended>(0.00, 0.0001);
  end);

  TTest4D.Test('teste assert float OK',
  procedure
  begin
    TTest4DCommands.Assert<Extended>(0.00, 0.00);
  end);

  TTest4D.Test('teste erro de código',
  procedure
  begin
    raise Exception.Create('Code Error.');
  end);

  TTest4D.Test('teste willraise quebrado',
  procedure
  begin
    TTest4DCommands.WillRaise(
    procedure
    begin

    end);
  end);

  TTest4D.Test('teste willraise ok',
  procedure
  begin
    TTest4DCommands.WillRaise(
    procedure
    begin
      raise Exception.Create('Error Message');
    end);
  end);

  TTest4D.Test('teste willnotraise quebrado',
  procedure
  begin
    TTest4DCommands.WillNotRaise(
    procedure
    begin
      raise Exception.Create('Error Message');
    end);
  end);

  TTest4D.Test('teste willnotraise ok',
  procedure
  begin
    TTest4DCommands.WillNotRaise(
    procedure
    begin

    end);
  end);

  TTest4D.Run;
end.
