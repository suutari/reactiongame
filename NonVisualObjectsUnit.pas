unit NonVisualObjectsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TNonVisualObjects = class(TDataModule)
    GameTimer: TTimer;
    LightsTimer: TTimer;
    procedure GameTimerTimer(Sender: TObject);
    procedure LightsTimerTimer(Sender: TObject);

    private

    public

  end;

  {**************************
  TOP12-listalle tehty luokka
  ***************************}
  TTop12List = class
    private
      ScoreFile, ChkSumFile: String;
      FileNamesAreSet, FileIsLoaded: Boolean;
      Scores: array[0..11] of Integer;
      Names: array[0..11] of String;
      ScoreLines: TStringList;
      FileChkSum: Integer;
      procedure CreateNewFile;
      procedure GenerateFileChkSum;
      procedure SaveFileChkSum;
      function FileChkSumIsOk: Boolean;
      procedure MakeSureFileIsCorrect;

    public
      constructor Create(FileNamePrefix: String);
      destructor Destroy; override;
      procedure SetFile(FileNamePrefix: String);
      procedure LoadScores;
      procedure SaveScores;
      function FitsInList(Score: Integer): Boolean;
      procedure PutNewEntry(Score: Integer; Name: String);
      function GetScore(Position: Integer): Integer;
      function GetName(Position: Integer): String;
  end;


var
  NonVisualObjects: TNonVisualObjects;

implementation

uses MainUnit;

{$R *.DFM}

constructor TTop12List.Create(FileNamePrefix: String);
begin
  ScoreLines:=TStringList.Create;
  SetFile(FileNamePrefix);
  FileIsLoaded:=False;
  FileChkSum:=0;
end;

destructor TTop12List.Destroy;
begin
  ScoreLines.Free;
end;

procedure TTop12List.SetFile(FileNamePrefix: String);
begin
  ScoreFile:=FileNamePrefix + '.txt';
  ChkSumFile:=FileNamePrefix + '.chksum';
  FileNamesAreSet:=True;
end;

procedure TTop12List.CreateNewFile;
var i: Integer;
begin
  if FileNamesAreSet
  then begin
    ScoreLines.Clear;
    for i:=0 to 11
    do begin
      ScoreLines.Insert(0, '0');
      ScoreLines.Insert(0, '-');
    end;
    ScoreLines.SaveToFile(ScoreFile);
    FileIsLoaded:=True;
    SaveFileChkSum;
    ScoreLines.Clear;
    FileIsLoaded:=False;
  end;
end;

procedure TTop12List.GenerateFileChkSum;
var line, col: Integer;
begin
  if FileIsLoaded
  then begin
    FileChkSum:=0;
    for line:=0 to ScoreLines.Count-1
    do begin
      if Length(ScoreLines.Strings[line]) > 0
      then for col:=0 to Length(ScoreLines.Strings[line])
      do begin
        FileChkSum:=FileChkSum
         +Integer(ScoreLines.Strings[line][col])*(line+col);
      end
      else FileChkSum:=FileChkSum+line;
    end;
  end;
end;

procedure TTop12List.SaveFileChkSum;
var ChkSumLines: TStringList;
begin
  if FileIsLoaded
  then begin
    GenerateFileChkSum;

    if FileNamesAreSet
    then begin
      ChkSumLines:=TStringList.Create;
      ChkSumLines.Insert(0, IntToStr(FileChkSum));
      ChkSumLines.SaveToFile(ChkSumFile);
      ChkSumLines.Free;
    end;
  end;

end;

function TTop12List.FileChkSumIsOk: Boolean;
var ChkSumLines: TStringList; Correct: Boolean;
begin
  Correct:=False;
  if FileIsLoaded
  then begin
    GenerateFileChkSum;

    if FileNamesAreSet
    then begin
      ChkSumLines:=TStringList.Create;
      ChkSumLines.LoadFromFile(ChkSumFile);
      if StrToIntDef(ChkSumLines.Strings[0], 0) = FileChkSum
      then Correct:=True;
      ChkSumLines.Free;
    end;
  end;
  Result:=Correct;
end;

procedure TTop12List.MakeSureFileIsCorrect;
var i, last, current: Integer; correct: Boolean;
begin
  if FileNamesAreSet
  then begin
    if FileExists(ScoreFile)
    then begin
      ScoreLines.LoadFromFile(ScoreFile);
      FileIsLoaded:=True;
      if not FileChkSumIsOk then CreateNewFile
      else begin
        correct:=true;
        last:=0;
        for i:=0 to 11
        do begin
          current:=StrToIntDef(ScoreLines.Strings[(11-i)*2+1], -1);
          if current < last
          then begin
            correct:=false;
            break;
          end;
          last:=current;
        end;
        if not correct then CreateNewFile;
      end;
      ScoreLines.Clear;
      FileIsLoaded:=False;
    end
    else CreateNewFile;
  end;
end;

procedure TTop12List.LoadScores;
var i: Integer;
begin
  if FileNamesAreSet
  then begin
    MakeSureFileIsCorrect;
    ScoreLines.LoadFromFile(ScoreFile);

    for i:=0 to 11
    do begin
      Names[i]:=ScoreLines.Strings[i*2];
      Scores[i]:=StrToIntDef(ScoreLines.Strings[i*2+1], 0);
    end;

    FileIsLoaded:=True;

  end;
end;

procedure TTop12List.SaveScores;
var i: Integer;
begin
  if FileIsLoaded
  then begin
    for i:=0 to 11
    do begin
      ScoreLines.Strings[i*2]:=Names[i];
      ScoreLines.Strings[i*2+1]:=IntToStr(Scores[i]);
    end;
    ScoreLines.SaveToFile(ScoreFile);
    SaveFileChkSum;
  end;
end;

function TTop12List.FitsInList(Score: Integer): Boolean;
begin
  if Score>Scores[11] then Result:=True
  else Result:=False;
end;

procedure TTop12List.PutNewEntry(Score: Integer; Name: String);
var p, i: Integer;
begin if FitsInList(Score) then begin
  p:=11;
  while Scores[p-1]<Score
  do if p<1 then break else p:=p-1;

  for i:=p to 11
  do begin
    Scores[11-i+p]:=Scores[10-i+p];
    Names[11-i+p]:=Names[10-i+p];
  end;
  Scores[p]:=Score;
  Names[p]:=Name;
  SaveScores;
end; end;

function TTop12List.GetScore(Position: Integer): Integer;
begin
  Result:=0;
  if FileIsLoaded
  then begin
    if (Position>=0) and (Position<=11)
    then Result:=Scores[Position];
  end;
end;

function TTop12List.GetName(Position: Integer): String;
begin
  if FileIsLoaded
  then begin
    if (Position>=0) and (Position<=11)
    then Result:=Names[Position]
    else Result:='-';
  end;
end;

procedure TNonVisualObjects.GameTimerTimer(Sender: TObject);
var RandomValue: ShortInt;
begin
  with MainForm
  do begin
    if TimerInterval>10
    then TimerInterval:=(200*TimerInterval) div (200+Acceleration);

    GameTimer.Interval:=TimerInterval;

    if RandomTimerEnabled
    then GameTimer.Interval:=GameTimer.Interval+
     Random(4*TimerInterval div 5)-2*TimerInterval div 5;

    repeat RandomValue:=Random(4)
    until RandomValue <> LastButtons[VarArrayHighBound(LastButtons,1)];

    EnlightOneButton(TButtonColor(RandomValue));
  end;
end;

procedure TNonVisualObjects.LightsTimerTimer(Sender: TObject);
begin
  with MainForm do
    if ButtonsEnlighted then DarkenButtons else EnlightButtons;
end;

end.
