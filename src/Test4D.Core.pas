unit Test4D.Core;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  {$SCOPEDENUMS ON}
  TTestMethodStatus = (None, Active, Skipped);
  {$SCOPEDENUMS OFF}

  TTestMethod = record
    Status : TTestMethodStatus;
    Name : string;
    Method : TProc;
  end;

  TTest4DCore = class
  private
    FTests : TDictionary<string, TTestMethod>;
    FTestOnly : TTestMethod;
    procedure AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Test(aName : string; aMethod : TProc);
    procedure TestOnly(aName : string; aMethod : TProc);
    procedure Skip(aName : string; aMethod : TProc);
  end;

implementation

{ TTest4DCore }

procedure TTest4DCore.AddMethod(aStatus : TTestMethodStatus; aName : string; aMethod : TProc);
begin
  var lTestMethod : TTestMethod;
  lTestMethod.Status := aStatus;
  lTestMethod.Name := aName;
  lTestMethod.Method := aMethod;
  FTests.Add(aName, lTestMethod);
end;

constructor TTest4DCore.Create;
begin
  FTests := TDictionary<string, TTestMethod>.Create;
end;

destructor TTest4DCore.Destroy;
begin
  FTests.DisposeOf;
  inherited;
end;

procedure TTest4DCore.Skip(aName : string; aMethod : TProc);
begin

end;

procedure TTest4DCore.Test(aName : string; aMethod : TProc);
begin
  AddMethod(Active, aName, aMethod);
end;

procedure TTest4DCore.TestOnly(aName : string; aMethod : TProc);
begin
  FTestOnly.Name := aName;
  FTestOnly.Method := aMethod;
end;

end.
