unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, ComCtrls, NonVisualObjectsUnit;

const
  cProgVersion: String = 'Versio 1.0.8 (27.3.2001)';
  opnAccel: array[0..4] of Integer = (0, 2, 4, 6, 9);
  opnSpeed: array[0..2] of Integer = (2000, 800, 520);

type
  TButtonColor=(btnRed, btnGreen, btnBlue, btnYellow);
  TMainForm = class(TForm)
    ButtonPanel: TPanel;
    StartButton: TButton;
    Top12Button: TButton;
    QuitButton: TButton;
    ActionPanel: TPanel;
    RedButton: TImage;
    GreenButton: TImage;
    BlueButton: TImage;
    YellowButton: TImage;
    MainMenu: TMainMenu;
    ActionsMenuItem: TMenuItem;
    StartMenuItem: TMenuItem;
    Top12MenuItem: TMenuItem;
    QuitMenuItem: TMenuItem;
    OptionsMenuItem: TMenuItem;
    GameTypeMenuItem: TMenuItem;
    NGameMenuItem: TMenuItem;
    RAGameMenuItem: TMenuItem;
    StartingSpeedMenuItem: TMenuItem;
    SlowSpeedMenuItem: TMenuItem;
    NormalSpeedMenuItem: TMenuItem;
    FastSpeedMenuItem: TMenuItem;
    AccelMenuItem: TMenuItem;
    EasyAccelMenuItem: TMenuItem;
    NormalAccelMenuItem: TMenuItem;
    FastAccelMenuItem: TMenuItem;
    CrazyAccelMenuItem: TMenuItem;
    ImpossibleAccelMenuItem: TMenuItem;
    AboutMenuItem: TMenuItem;
    ScoreBox: TPanel;

    procedure FormCreate(Sender: TObject);
    function NewColorButton(const FileName: String): TBitmap;
    procedure StartButtonClick(Sender: TObject);
    procedure Top12ButtonClick(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure EnlightOneButton(WhichOne: TButtonColor);
    procedure ColorButtonClick(Sender: TObject);
    procedure ResetSettings;
    procedure EndGame;
    procedure DarkenButtons;
    procedure EnlightButtons;
    procedure DisableMenus;
    procedure EnableMenus;
    procedure AccelMenuItemClick(Sender: TObject);
    procedure SpeedMenuItemClick(Sender: TObject);
    procedure NGameMenuItemClick(Sender: TObject);
    procedure RAGameMenuItemClick(Sender: TObject);
    procedure AboutMenuItemClick(Sender: TObject);
    procedure KeyboardKeyPress(Sender: TObject; var Key: Char);

    private
      StartingTime, NumberOfClicks: Integer;
      RedButtonImage, GreenButtonImage,
      BlueButtonImage, YellowButtonImage,
      DarkRedButtonImage, DarkGreenButtonImage,
      DarkBlueButtonImage, DarkYellowButtonImage: TBitmap;
      ScoresEnabled, AMessageShown, SMessageShown: Boolean;

    public
      LastButtons: Variant;
      TimerInterval, Acceleration: Integer;
      ButtonsEnlighted, RandomTimerEnabled: Boolean;

  end;

var
  MainForm: TMainForm;
  NGameScores, RAGameScores: TTop12List;
  PlayerName: String;

implementation

uses AboutUnit, Top12Unit, AskNameUnit;

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Randomize;

  NonVisualObjects:=TNonVisualObjects.Create(Self);

  NGameScores:=TTop12List.Create('NormalGameScores');
  NGameScores.LoadScores;
  RAGameScores:=TTop12List.Create('RandomAcceleratedGameScores');
  RAGameScores.LoadScores;

  Acceleration:=opnAccel[NormalAccelMenuItem.Tag];
  StartingTime:=opnSpeed[NormalSpeedMenuItem.Tag];
  ScoresEnabled:=True;
  RandomTimerEnabled:=False;

  RedButtonImage:=NewColorButton('images\RedButton.bmp');
  GreenButtonImage:=NewColorButton('images\GreenButton.bmp');
  BlueButtonImage:=NewColorButton('images\BlueButton.bmp');
  YellowButtonImage:=NewColorButton('images\YellowButton.bmp');

  DarkRedButtonImage:=NewColorButton('images\DarkRedButton.bmp');
  DarkGreenButtonImage:=NewColorButton('images\DarkGreenButton.bmp');
  DarkBlueButtonImage:=NewColorButton('images\DarkBlueButton.bmp');
  DarkYellowButtonImage:=NewColorButton('images\DarkYellowButton.bmp');

  ResetSettings;
end;

procedure TMainForm.QuitButtonClick(Sender: TObject);
begin
  Close;
end;

function TMainForm.NewColorButton(const FileName: String): TBitmap;
var ImageObject: TBitmap;
begin
  ImageObject:=TBitmap.Create;
  with ImageObject do
  begin
    Height:=128;
    Width:=128;
  end;
  ImageObject.LoadFromFile(FileName);
  Result:=ImageObject;
end;

procedure TMainForm.EnlightOneButton(WhichOne: TButtonColor);
begin
  DarkenButtons;

  VarArrayRedim(LastButtons, VarArrayHighBound(LastButtons,1)+1);

  case WhichOne of
    btnRed: begin
      RedButton.Picture.Graphic:=RedButtonImage;
      LastButtons[VarArrayHighBound(LastButtons,1)]:=Integer(btnRed);
    end;
    btnGreen: begin
      GreenButton.Picture.Graphic:=GreenButtonImage;
      LastButtons[VarArrayHighBound(LastButtons,1)]:=Integer(btnGreen);
    end;
    btnBlue: begin
      BlueButton.Picture.Graphic:=BlueButtonImage;
      LastButtons[VarArrayHighBound(LastButtons,1)]:=Integer(btnBlue);
    end;
    btnYellow: begin
      YellowButton.Picture.Graphic:=YellowButtonImage;
      LastButtons[VarArrayHighBound(LastButtons,1)]:=Integer(btnYellow);
    end;
  end;
end;

procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  if NonVisualObjects.GameTimer.Enabled=False
  then begin
    ResetSettings;
    StartButton.Caption:='Pysäytä';
    StartMenuItem.Caption:='&Pysäytä peli';
    ScoreBox.Caption:='0';
    NonVisualObjects.LightsTimer.Enabled:=False;
    DarkenButtons;
    DisableMenus;
    NonVisualObjects.GameTimer.Enabled:=True;
  end
  else ResetSettings;
end;

procedure TMainForm.DisableMenus;
begin
  SlowSpeedMenuItem.Enabled:=False;
  NormalSpeedMenuItem.Enabled:=False;
  FastSpeedMenuItem.Enabled:=False;
  EasyAccelMenuItem.Enabled:=False;
  NormalAccelMenuItem.Enabled:=False;
  FastAccelMenuItem.Enabled:=False;
  CrazyAccelMenuItem.Enabled:=False;
  ImpossibleAccelMenuItem.Enabled:=False;
  NGameMenuItem.Enabled:=False;
  RAGameMenuItem.Enabled:=False;
end;

procedure TMainForm.EnableMenus;
begin
  SlowSpeedMenuItem.Enabled:=True;
  NormalSpeedMenuItem.Enabled:=True;
  FastSpeedMenuItem.Enabled:=True;
  EasyAccelMenuItem.Enabled:=True;
  NormalAccelMenuItem.Enabled:=True;
  FastAccelMenuItem.Enabled:=True;
  CrazyAccelMenuItem.Enabled:=True;
  ImpossibleAccelMenuItem.Enabled:=True;
  NGameMenuItem.Enabled:=True;
  RAGameMenuItem.Enabled:=True;
end;

procedure TMainForm.ResetSettings;
begin
  NonVisualObjects.GameTimer.Enabled:=False;
  TimerInterval:=StartingTime;
  StartButton.Caption:='Aloita!';
  StartMenuItem.Caption:='&Aloita peli!';
  VarClear(LastButtons);
  LastButtons:=VarArrayCreate([0,0], varSmallInt);
  DarkenButtons;
  ScoreBox.Caption:='';
  if ScoresEnabled
  then ScoreBox.Font.Color:=clAqua
  else ScoreBox.Font.Color:=clRed;
  NumberOfClicks:=0;
  EnableMenus;
end;

procedure TMainForm.DarkenButtons;
begin
  RedButton.Picture.Graphic:=DarkRedButtonImage;
  GreenButton.Picture.Graphic:=DarkGreenButtonImage;
  BlueButton.Picture.Graphic:=DarkBlueButtonImage;
  YellowButton.Picture.Graphic:=DarkYellowButtonImage;
  ButtonsEnlighted:=False;
end;

procedure TMainForm.EnlightButtons;
begin
  RedButton.Picture.Graphic:=RedButtonImage;
  GreenButton.Picture.Graphic:=GreenButtonImage;
  BlueButton.Picture.Graphic:=BlueButtonImage;
  YellowButton.Picture.Graphic:=YellowButtonImage;
  ButtonsEnlighted:=True;
end;

procedure TMainForm.EndGame;
var Score: Integer;
begin
  Score:=NumberOfClicks;
  ResetSettings;
  ScoreBox.Caption:=IntToStr(Score);
  NonVisualObjects.LightsTimer.Enabled:=True;
  if ScoresEnabled
  then begin
    if RandomTimerEnabled
    then begin
      if RAGameScores.FitsInList(Score)
      then begin
        if AskNameForm.ShowModal=idOk
        then begin
          RAGameScores.PutNewEntry(Score, PlayerName);
          Top12Form.ShowModal;
        end;
      end;
    end
    else begin
      if NGameScores.FitsInList(Score)
      then begin
        if AskNameForm.ShowModal=idOk
        then begin
          NGameScores.PutNewEntry(Score, PlayerName);
          Top12Form.ShowModal;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.ColorButtonClick(Sender: TObject);
begin
  if VarArrayHighBound(LastButtons,1) >= NumberOfClicks+1
  then begin
    if LastButtons[NumberOfClicks+1] = (Sender as TImage).Tag
    then begin
      NumberOfClicks:=NumberOfClicks+1;
      ScoreBox.Caption:=IntToStr(NumberOfClicks);
    end
    else EndGame;
  end;
end;

procedure TMainForm.AboutMenuItemClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.Top12ButtonClick(Sender: TObject);
begin
  Top12Form.ShowModal;
end;

procedure TMainForm.AccelMenuItemClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Tag=1
  then begin
    if StartingTime=opnSpeed[NormalSpeedMenuItem.Tag] then ScoresEnabled:=True;
  end
  else begin
    ScoresEnabled:=False;
    if not AMessageShown
    then begin
      MessageDlg(
      'Et voi päästä TOP12-listalle, jos kiihtyvyys ei ole "Tavallinen".',
      mtWarning, [mbOK], 0);
      AMessageShown:=True;
    end;
  end;

  (Sender as TMenuItem).Checked:=True;
  Acceleration:=opnAccel[(Sender as TMenuItem).Tag];
end;

procedure TMainForm.SpeedMenuItemClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Tag=1
  then begin
    if Acceleration=opnAccel[NormalAccelMenuItem.Tag] then ScoresEnabled:=True;
  end
  else begin
    ScoresEnabled:=False;
    if not SMessageShown
    then begin
      MessageDlg(
      'Et voi päästä TOP12-listalle, jos lähtönopeus ei ole "Normaali".',
      mtWarning, [mbOK], 0);
      SMessageShown:=True;
    end;
  end;

  (Sender as TMenuItem).Checked:=True;
  StartingTime:=opnSpeed[(Sender as TMenuItem).Tag];
end;

procedure TMainForm.NGameMenuItemClick(Sender: TObject);
begin
  RandomTimerEnabled:=False;
  NGameMenuItem.Checked:=True;
end;

procedure TMainForm.RAGameMenuItemClick(Sender: TObject);
begin
  RandomTimerEnabled:=True;
  RAGameMenuItem.Checked:=True;
end;

procedure TMainForm.KeyboardKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    'z', 'a', 'h', '1': ColorButtonClick(RedButton);
    'x', 's', 'j', '2': ColorButtonClick(GreenButton);
    'c', 'd', 'k', '3': ColorButtonClick(BlueButton);
    'v', 'f', 'l', '4': ColorButtonClick(YellowButton);
  end;
end;

end.
