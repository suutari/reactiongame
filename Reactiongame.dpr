program Reactiongame;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  AskNameUnit in 'AskNameUnit.pas' {AskNameForm},
  Top12Unit in 'Top12Unit.pas' {Top12Form},
  NonVisualObjectsUnit in 'NonVisualObjectsUnit.pas' {NonVisualObjects: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Reaktiopeli';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TAskNameForm, AskNameForm);
  Application.CreateForm(TTop12Form, Top12Form);
  Application.Run;
end.
