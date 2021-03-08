unit AskNameUnit;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TAskNameForm = class(TForm)
    NameBox: TEdit;
    AskNameText: TLabel;
    OKButton: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NameBoxKeyPress(Sender: TObject; var Key: Char);

    private

    public

  end;

var
  AskNameForm: TAskNameForm;

implementation

uses MainUnit;

{$R *.lfm}

procedure TAskNameForm.OKButtonClick(Sender: TObject);
begin
  if NameBox.Text <> ''
  then begin
    PlayerName:=NameBox.Text;
    SelectFirst;
    NameBox.SelectAll;
    ModalResult:=idOk;
  end;
end;

procedure TAskNameForm.FormShow(Sender: TObject);
begin
  Left:=(MainForm.Left+MainForm.Width div 2)-Width div 2;
  Top:=(MainForm.Top+MainForm.Height div 2)-Height div 2;
  if Left<0 then Left:=0;
  if Top<0 then Top:=0;
  if Left+Width>Screen.Width then Left:=Screen.Width-Width;
  if Top+Height>Screen.Height then Top:=Screen.Height-Height;
end;

procedure TAskNameForm.NameBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then OKButtonClick(NameBox);
end;

end.
