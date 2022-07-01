unit Test4D.Configurations;

interface

uses
  Test4D.Types;

type
  TTest4DConfigurations = class
  private
    FShowTestList : boolean;
    FLanguage : iTest4DLanguage;
  public
    property ShowTestList: boolean read FShowTestList write FShowTestList;
    property Language: iTest4DLanguage read FLanguage write FLanguage;
  end;

implementation


end.
