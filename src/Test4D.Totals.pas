unit Test4D.Totals;

interface

uses
  System.SysUtils;

type
  TTest4DTotals = class
  private
    FTotalTests : integer;
    FFailedTests : integer;
    FSkippedTests : integer;
    FPassedTests : integer;
    FErrorInCodeTests : integer;
    FParent : TObject;
  public
    constructor Create(aParent : TObject);
    procedure Init;
    procedure TotalTests(aValue : integer); overload;
    function TotalTests : string; overload;
    procedure IncFailedTest;
    function TotalFailedTests : string;
    procedure IncSkippedTest;
    function TotalSkippedTests : string;
    procedure IncPassedTest;
    function TotalPassedTests : string;
    procedure IncErrorInCodeTest;
    function TotalErrorInCodeTests : string;
  end;

implementation

uses
  Test4D.Core;

{ TTest4DTotals }

constructor TTest4DTotals.Create(aParent: TObject);
begin
  FParent := aParent;
end;

procedure TTest4DTotals.IncErrorInCodeTest;
begin
  Inc(FErrorInCodeTests);
end;

procedure TTest4DTotals.IncFailedTest;
begin
  Inc(FFailedTests);
end;

procedure TTest4DTotals.IncPassedTest;
begin
  Inc(FPassedTests);
end;

procedure TTest4DTotals.IncSkippedTest;
begin
  Inc(FSkippedTests);
end;

procedure TTest4DTotals.Init;
begin
  FTotalTests := 0;
  FFailedTests := 0;
  FSkippedTests := 0;
  FPassedTests := 0;
  FErrorInCodeTests := 0;
end;

function TTest4DTotals.TotalErrorInCodeTests: string;
begin
  Result := FErrorInCodeTests.ToString;
end;

function TTest4DTotals.TotalFailedTests: string;
begin
  Result := FFailedTests.ToString;
end;

function TTest4DTotals.TotalPassedTests: string;
begin
  Result := FPassedTests.ToString;
end;

function TTest4DTotals.TotalSkippedTests: string;
begin
  Result := FSkippedTests.ToString;
end;

function TTest4DTotals.TotalTests: string;
begin
  Result := FTotalTests.ToString;
end;

procedure TTest4DTotals.TotalTests(aValue: integer);
begin
  FTotalTests := aValue;
end;

end.
