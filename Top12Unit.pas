unit Top12Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TTop12Form = class(TForm)
    HighScoreCloseButton: TButton;
    ScorePageControl: TPageControl;
    NGameTabSheet: TTabSheet;
    RAGameTabSheet: TTabSheet;
    NGameNamesMemo: TMemo;
    NGameRankMemo: TMemo;
    NGameScoresMemo: TMemo;
    RAGameRankMemo: TMemo;
    RAGameNamesMemo: TMemo;
    RAGameScoresMemo: TMemo;
    procedure HighScoreCloseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

    private

    public

  end;

var
  Top12Form: TTop12Form;

implementation

uses MainUnit;

{$R *.DFM}

procedure TTop12Form.HighScoreCloseButtonClick(Sender: TObject);
begin
  ModalResult:=idOk;
end;

procedure TTop12Form.FormShow(Sender: TObject);
var i: Integer;
begin
  Left:=(MainForm.Left+MainForm.Width div 2)-Width div 2;
  Top:=(MainForm.Top+MainForm.Height div 2)-Height div 2;
  if Left<0 then Left:=0;
  if Top<0 then Top:=0;
  if Left+Width>Screen.Width then Left:=Screen.Width-Width;
  if Top+Height>Screen.Height then Top:=Screen.Height-Height;

  if MainForm.RandomTimerEnabled
  then ScorePageControl.ActivePage:=RAGameTabSheet
  else ScorePageControl.ActivePage:=NGameTabSheet;

  NGameNamesMemo.Clear;
  NGameScoresMemo.Clear;
  RAGameNamesMemo.Clear;
  RAGameScoresMemo.Clear;
  for i:=0 to 11
  do begin
    NGameNamesMemo.Lines.Insert(0, NGameScores.GetName(11-i));
    NGameScoresMemo.Lines.Insert(0, IntToStr(NGameScores.GetScore(11-i)));
    RAGameNamesMemo.Lines.Insert(0, RAGameScores.GetName(11-i));
    RAGameScoresMemo.Lines.Insert(0, IntToStr(RAGameScores.GetScore(11-i)));
  end;
end;

end.
