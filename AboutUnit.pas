unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellApi;

type
  TAboutForm = class(TForm)
    AboutCloseButton: TButton;
    ProgramNameLabel: TLabel;
    ProgramVersionLabel: TLabel;
    MadeByLabel: TLabel;
    MailToLabel: TLabel;
    procedure AboutCloseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MailToLabelClick(Sender: TObject);

    private

    public

  end;

var
  AboutForm: TAboutForm;

implementation

uses MainUnit;

{$R *.DFM}

procedure TAboutForm.AboutCloseButtonClick(Sender: TObject);
begin
  ModalResult:=idOk;
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  ProgramVersionLabel.Caption:=cProgVersion;
  Left:=(MainForm.Left+MainForm.Width div 2)-Width div 2;
  Top:=(MainForm.Top+MainForm.Height div 2)-Height div 2;
  if Left<0 then Left:=0;
  if Top<0 then Top:=0;
  if Left+Width>Screen.Width then Left:=Screen.Width-Width;
  if Top+Height>Screen.Height then Top:=Screen.Height-Height;
end;

procedure TAboutForm.MailToLabelClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, 'mailto:tuomas.suutari@naantali.fi', '', '',
  SW_SHOWNORMAL);
end;

end.
