unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ComCtrls, Spin, ExtCtrls, MMSystem, StrUtils, Windows, IniFiles;

type

  { TFMain }
  TFMain = class(TForm)
    DynamicsCheck: TCheckBox;
    TopCheck: TCheckBox;
    SaveLayoutDialog: TSaveDialog;
    SustainCheck: TCheckBox;
    FileMIDIOpen: TMenuItem;
    FileMIDIClose: TMenuItem;
    HelpAbout: TMenuItem;
    MenuEdit: TMenuItem;
    EditLayout: TMenuItem;
    EditShiftUp: TMenuItem;
    FileCreate: TMenuItem;
    FileSave: TMenuItem;
    FileSaveAs: TMenuItem;
    EditShiftDown: TMenuItem;
    N5: TMenuItem;
    TextLabel: TMemo;
    MuteCheck: TCheckBox;
    MIDIJumpCustom: TMenuItem;
    N4: TMenuItem;
    MIDIJump50: TMenuItem;
    MIDIJump10: TMenuItem;
    MIDIJump5: TMenuItem;
    MIDIJump: TMenuItem;
    MIDIJump1: TMenuItem;
    N3: TMenuItem;
    MIDINextButton: TButton;
    MIDIStop: TMenuItem;
    MIDIPause: TMenuItem;
    MIDIPlay: TMenuItem;
    MIDIPrevButton: TButton;
    OutputLabel: TLabel;
    OutputPorts: TComboBox;
    MIDITempoLabel: TLabel;
    MIDITempoLabel1: TLabel;
    N2: TMenuItem;
    MIDIPlayButton: TButton;
    FileLayout: TMenuItem;
    FileExit: TMenuItem;
    MIDIFrame: TGroupBox;
    MIDIPauseButton: TButton;
    MIDIStopButton: TButton;
    N1: TMenuItem;
    OpenLayout: TOpenDialog;
    MIDIProgress: TProgressBar;
    OpenMIDIDialog: TOpenDialog;
    MIDITempo: TSpinEdit;
    TransposeCheck: TCheckBox;
    DrumsCheck: TCheckBox;
    KeyboardCheck: TCheckBox;
    TuneShow: TLabel;
    TuneM: TButton;
    ThresholdLabel: TLabel;
    TuneLabel: TLabel;
    ThresholdShow: TLabel;
    OptionsFrame: TGroupBox;
    InputButton: TButton;
    InputPorts: TComboBox;
    InputFrame: TGroupBox;
    InputLabel: TLabel;
    MenuFile: TMenuItem;
    MenuHelp: TMenuItem;
    MenuMIDI: TMenuItem;
    TuneP: TButton;
    TuneTrack: TTrackBar;
    TopMenu: TMainMenu;
    ThresholdTrack: TTrackBar;
    procedure DrumsCheckChange(Sender: TObject);
    procedure DynamicsCheckChange(Sender: TObject);
    procedure EditLayoutClick(Sender: TObject);
    procedure EditShiftDownClick(Sender: TObject);
    procedure EditShiftUpClick(Sender: TObject);
    procedure FileCreateClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure ResizeKeys(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FileLayoutClick(Sender: TObject);
    procedure FileMIDICloseClick(Sender: TObject);
    procedure FileMIDIOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure HelpDocsClick(Sender: TObject);
    procedure InputButtonClick(Sender: TObject);
    procedure InputPortsChange(Sender: TObject);
    procedure KeyboardCheckChange(Sender: TObject);
    procedure MIDIJump10Click(Sender: TObject);
    procedure MIDIJump1Click(Sender: TObject);
    procedure MIDIJump50Click(Sender: TObject);
    procedure MIDIJump5Click(Sender: TObject);
    procedure MIDIJumpCustomClick(Sender: TObject);
    procedure MIDINextButtonClick(Sender: TObject);
    procedure MIDIPauseButtonClick(Sender: TObject);
    procedure MIDIPauseClick(Sender: TObject);
    procedure MIDIPlayButtonClick(Sender: TObject);
    procedure MIDIPlayClick(Sender: TObject);
    procedure MIDIPrevButtonClick(Sender: TObject);
    procedure MIDIStopButtonClick(Sender: TObject);
    procedure MIDIStopClick(Sender: TObject);
    procedure MIDITempoChange(Sender: TObject);
    procedure MuteCheckChange(Sender: TObject);
    procedure OutputPortsChange(Sender: TObject);
    procedure SustainCheckChange(Sender: TObject);
    procedure ThresholdTrackChange(Sender: TObject);
    procedure TopCheckChange(Sender: TObject);
    procedure TransposeCheckChange(Sender: TObject);
    procedure TuneMClick(Sender: TObject);
    procedure TunePClick(Sender: TObject);
    procedure TuneTrackChange(Sender: TObject);
  private

  public

  end;
  MidiSequence = array[0..3] of byte;
  MidiNote = record
    ntype, info: integer;
    key, velocity: byte;
    deltaTime: integer;
  end;
  PKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;
  TKBDLLHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;
  SequenceArray = array of MidiSequence;
  MidiFile = class
    bytes: array of byte;
    headerLength, headerOffset, format, tracks, division, divisionType, itr, runningStatus, tempo, deltaTime: integer;
    runningStatusSet: boolean;
    startSequence: SequenceArray;
    startCounter: array[0..2] of integer;
    typeDict: array of byte;
    typeName: array of string;

    notes: array of MidiNote;
    private

    public
      constructor Create(const fname: widestring);
      destructor Destroy;
      function GetType(const nbyte: byte):string;
      function CheckStartSequence : boolean;
      function GetInt(const i: integer): integer;
      function ReadText(const nlength: integer):string;
      function ReadLength: integer;
      procedure ReadVoiceEvent(const deltaT: integer);
      function ReadMidiMetaEvent(const deltaT: integer):boolean;
      procedure ReadMidiTrackEvent(const nlength: integer);
      procedure ReadMThd;
      procedure ReadMTrk;
      procedure ReadEvents;
  end;
  PianoKey = class(TShape)
    procedure PKMouseON(Sender: TObject);
    procedure PKMouseOFF(Sender: TObject);
    procedure PKClick(Sender: TObject);
    private

    public
      black: boolean;
      number: integer;
  end;
const
  MThd: MidiSequence = ($4D,$54,$68,$64);
  MTrk: MidiSequence = ($4D,$54,$72,$6B);
  FF: MidiSequence = ($FF,$FF,$FF,$FF);

var
  FMain: TFMain;
  Inputs: TStringList;
  InputIndex: integer = 0;
  InputDevice: HMIDIIN;
  InputHDR: TMIDIHDR;
  Outputs: TStringList;
  OutputIndex: integer = 0;
  OutputDevice: HMIDIOUT;
  midi: MidiFile;
  midiTimer, midiPointer: longint;
  timeScale: double = 0;
  timeTempo: double = 60;
  midiopen: boolean = false;
  midipaused: boolean = true;
  llKeyboardHook: HHOOK = 0;
  pianoKeys: array[0..60] of PianoKey;
  pianoLabels: array[0..60] of TLabel;
  remapMode: boolean = false;
  waitForKey: integer = -1;
  shiftDown: boolean = false;
  layoutChanged: boolean = false;
  layoutFile: string = '';
  ini: TIniFile;
  //PREFERENCES
  Transpose: boolean = false;
  Threshold: byte = 1;
  Tune: shortint = 0;
  TempoPercent: integer = 100;
  JumpAmount: integer = 1;
  Mute: boolean = false;
  PlayPercussion: boolean = false;
  LevelDynamics: boolean = false;
  Sustain: boolean = false;

  Layout: array[0..60] of char = (
  '1','!','2','@','3','4','$','5','%','6','^','7',
  '8','*','9','(','0','q','Q','w','W','e','E','r',
  't','T','y','Y','u','i','I','o','O','p','P','a',
  's','S','d','D','f','g','G','h','H','j','J','k',
  'l','L','z','Z','x','c','C','v','V','b','B','n', 'm');

  //TRANSLATIONS
  TRLastNote: string = 'Last played note number: ';
  TRLastVelocity: string = 'Last played note velocity: ';
  TRNotRegistered: string = ' (NOT REGISTERED)';

implementation

uses about, customJump;

function Clamp(val, min, max: integer):integer;
begin
  if (val < min) then val := min else if (val > max) then val := max;
  Clamp := val;
end;

constructor MidiFile.Create(const fname: widestring);
var
  f: file of byte;
  c: byte;
begin
  midiopen := true;
  headerLength := -1;
  headerOffset := 23;
  format := -1;
  tracks := -1;
  division := -1;
  divisionType := -1;
  itr := 0;
  runningStatus := -1;
  runningStatusSet := false;
  tempo := 120;

  startSequence := SequenceArray.Create(MThd, MTrk, FF);

  AssignFile(f, fname);
  Reset(f);
  while not EOF(f) do
  begin
    Read(f, c);
    SetLength(bytes, Length(bytes)+1);
    bytes[Length(bytes)-1] := c;
  end;
  CloseFile(f);
  ReadEvents;
end;
destructor MidiFile.Destroy;
begin
  midiopen := false;
end;
function MidiFile.GetType(const nbyte: byte):string;
begin
  case nbyte of
    $00: GetType:='Sequence Number';
    $01: GetType:='Text Event';
    $02: GetType:='Copyright Notice';
    $03: GetType:='Sequence/Track Name';
    $04: GetType:='Instrument Name';
    $05: GetType:='Lyric';
    $06: GetType:='Marker';
    $07: GetType:='Cue Point';
    $2F: GetType:='End of Track';
    $51: GetType:='Set Tempo';
    $54: GetType:='SMTPE Offset';
    $58: GetType:='Time Signature';
    $59: GetType:='Key Signature';
    $7F: GetType:='Sequencer-Specific Meta-event';
    $21: GetType:='Prefix Port';
    $20: GetType:='Prefix Channel';
    $09: GetType:='Other text format [0x09]';
    $08: GetType:='Other text format [0x08]';
    $0A: GetType:='Other text format [0x0A]';
    $0C: GetType:='Other text format [0x0C]';
    else GetType:='Unknown Event '+HexStr(@nbyte);
  end;
end;
function MidiFile.CheckStartSequence : boolean;
var
  i:integer;
begin
  CheckStartSequence := false;
  for i:=0 to Length(startSequence)-1 do if Length(startSequence[i]) = startCounter[i] then CheckStartSequence := true;
end;
function MidiFile.GetInt(const i: integer): integer;
var
  k: integer = 0;
  n: integer;
  nbytes: array of byte;
begin
  for n:=itr to itr+i-1 do
  begin
    SetLength(nbytes, Length(nbytes)+1);
    nbytes[Length(nbytes)-1] := bytes[n];
  end;
  for n:=0 to Length(nbytes)-1 do
  begin
    //WriteLn('n is ',nbytes[n]);
    k := (k << 8)+nbytes[n];
  end;
  itr := itr+i;
  //WriteLn('k is ',k);
  GetInt := k;
end;
function MidiFile.ReadLength: integer;
var
  contFlag: boolean = true;
  nlength: integer = 0;
begin
  while contFlag do
  begin
    if ((bytes[itr] and $80) >> 7) = $1 then
      nlength := (nlength << 7) + (bytes[itr] and $7F)
    else begin
      contFlag := false;
      nlength := (nlength << 7) + (bytes[itr] and $7F);
    end;
    itr := itr + 1;
  end;
  //WriteLn('LENGTH ',nlength);
  ReadLength := nlength;
end;
function MidiFile.ReadText(const nlength: integer):string;
var
  s: string = '';
  start: integer;
begin
  start := itr;
  while (itr < nlength+start) do
  begin
    s := s+Chr(bytes[itr]);
    itr := itr+1;
  end;
  ReadText := s;
end;
function MidiFile.ReadMidiMetaEvent(const deltaT: integer):boolean;
var
  ntype: byte;
  nlength: integer;
begin
  ntype := bytes[itr];
  itr := itr+1;
  nlength := ReadLength;


  //WriteLn('MIDIMETAEVENT ',eventName,' LENGTH ',nlength,' DT ',deltaT);
  if ntype = $2F then
  begin
    //WriteLn('END TRACK');
    itr := itr+2;
    ReadMidiMetaEvent := false;
    Exit;
  end;
  if ((ntype >= 1) and (ntype <= 10)) or (ntype = $0C) then //WriteLn('READ EVENT ', ReadText(nlength))
  else if ntype = $51 then
  begin
    tempo := Round(GetInt(3) * 0.00024);
    SetLength(notes, Length(notes)+1);
      notes[Length(notes)-1].ntype := $51;
      notes[Length(notes)-1].info := tempo;
      notes[Length(notes)-1].deltaTime := deltaTime;
    //WriteLn('NEW TEMPO IS ', IntToStr(tempo), ' DT ',deltaTime);
  end
  else itr := itr+nlength;
  ReadMidiMetaEvent := true;
end;
procedure MidiFile.ReadVoiceEvent(const deltaT: integer);
var
  ntype: integer;
  channel, key, velocity: integer;
begin
  if (bytes[itr] < $80) and runningStatusSet then
  begin
    ntype := runningStatus;
    channel := ntype and $0F;
  end
  else
  begin
    ntype := bytes[itr];
    channel := bytes[itr] and $0F;
    if (ntype >= $80) and (ntype <= $F7) then
    begin
      runningStatus := ntype;
      runningStatusSet := true;
    end;
    itr := itr+1;
  end;

  if (ntype >> 4) = $9 then
  begin
    key := bytes[itr];
    itr := itr+1;
    velocity := bytes[itr];
    itr := itr+1;

    if velocity >= 0  then
      if channel <> 9 then
      begin
        SetLength(notes, Length(notes)+1);
        notes[Length(notes)-1].ntype := $9;
        notes[Length(notes)-1].key := key;
        notes[Length(notes)-1].velocity := velocity;
        notes[Length(notes)-1].deltaTime := deltaTime;
        //WriteLn('CHANNEL ', channel,' NOTE ',key,' TIME ',deltaTime);
      end
      else
      begin
        SetLength(notes, Length(notes)+1);
        notes[Length(notes)-1].ntype := $10;
        notes[Length(notes)-1].key := key;
        notes[Length(notes)-1].velocity := velocity;
        notes[Length(notes)-1].deltaTime := deltaTime;
      end;
  end
  else if (ntype >> 4) = $B then
  begin
    key := bytes[itr];
    itr := itr+1;
    velocity := bytes[Clamp(itr, 0, Length(bytes)-1)];
    itr := itr+1;
    if key = $40 then
    begin
      SetLength(notes, Length(notes)+1);
      notes[Length(notes)-1].ntype := $40;
      notes[Length(notes)-1].velocity := velocity;
      notes[Length(notes)-1].deltaTime := deltaTime;
    end;
  end
  else if not (((ntype >> 4 >= 8) and (ntype >> 4 <= 11)) or (ntype >> 4 = $D) or (ntype >> 4 = $E)) then
  begin
    itr := itr+1;
  end
  else
  begin
    itr := itr+2;
  end;
end;
procedure MidiFile.ReadMidiTrackEvent(const nlength: integer);
var
  start, deltaT: integer;
  continueFlag: boolean;
begin
  //WriteLn('TRACKEVENT');
  deltaTime := 0;
  start := itr;
  continueFlag := true;
  while (nlength > itr - start) and (continueFlag) do
  begin
    deltaT := ReadLength;
    deltaTime := deltaTime + deltaT;
    if (bytes[itr] = $FF) then
    begin
      itr := itr+1;
      continueFlag := ReadMidiMetaEvent(deltaT);
    end
    else if(bytes[itr] >= $F0) and (bytes[itr] <= $F7) then
    begin
      runningStatusSet := false;
      runningStatus := -1;
      //WriteLn('RUNNING STATUS SET: ',hexStr(@bytes[itr]));
    end
    else ReadVoiceEvent(deltaT);
  end;
  //WriteLn('End of MTrk event, jumping from ',self.itr,' to ',start+nlength);
  itr := start+nlength;
end;
procedure MidiFile.ReadMThd;
var
  ddiv: integer;
begin
  headerLength := GetInt(4);
  format := GetInt(2);
  tracks := GetInt(2);
  ddiv := GetInt(2);
  divisionType := (ddiv and $8000) >> 16;
  division := ddiv and $7FFF;
end;
procedure MidiFile.ReadMTrk;
var
  nlength: integer;
begin
  //WriteLn('MTrk');
  nlength := GetInt(4);
  //WriteLn('MTrk len ', nlength);
  ReadMidiTrackEvent(nlength);
end;
procedure MidiFile.ReadEvents;
var
  i: integer;
begin
  while itr+1 < Length(bytes) do
  begin
    for i:=0 to Length(startCounter)-1 do startCounter[i] := 0;
    while (itr+1 < Length(bytes)) and not (CheckStartSequence) do
    begin
      for i:=0 to Length(startSequence)-1 do
        if bytes[itr] = startSequence[i][startCounter[i]] then
          startCounter[i] := startCounter[i]+1
        else
          startCounter[i] := 0;
      if itr+1 < Length(bytes) then itr := itr+1;

      if startCounter[0] = 4 then ReadMThd
      else if startCounter[1] = 4 then ReadMTrk;
    end;
  end;
end;
procedure TriggerChanges;
begin
  if not layoutChanged then
  begin
    layoutChanged := true;
    FMain.Caption := FMain.Caption + '*';
  end;
end;
procedure SaveLayout;
var
  mlf: TextFile;
  i: integer;
begin
  AssignFile(mlf, layoutFile);
  try
    Rewrite(mlf);
    for i:=0 to Length(Layout)-1 do
    begin
      WriteLn(mlf, Layout[i]);
    end;
  finally
    CloseFile(mlf);
    FMain.Caption := 'MIRP (MIDI Input to Roblox Piano) - '+ExtractFileName(layoutFile);
    layoutChanged := false;
  end;
end;

procedure PianoKey.PKMouseON(Sender: TObject);
begin
  if (remapMode) and (waitForKey = -1) then
  begin
    Brush.Color := clLtGray;
  end;
end;
procedure PianoKey.PKMouseOFF(Sender: TObject);
begin
  if (remapMode) and (waitForKey = -1) then
  begin
    if black then Brush.Color := clBlack else Brush.Color := clWhite;
  end;
end;
procedure PianoKey.PKClick(Sender: TObject);
begin
  if (remapMode) and (waitForKey = -1)  then
  begin
    waitForKey := number;
    FMain.TextLabel.Text := 'Press a key to assign... Press Esc to cancel.';
  end;
end;

procedure PrintTStingList(const InputStrings: TStringList);
var
  i: integer;
begin
  for i:=0 to InputStrings.Count-1 do //WriteLn(InputStrings[i]);
  //InputStrings.Free;
end;
{$IFDEF MSWINDOWS}
function GetLocaleInformation(Flag: integer): string;
var
  pcLCA: array[0..20] of char;
begin
  if (GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0) then
  begin
    pcLCA[0] := #0;
  end;
  Result := pcLCA;
end;
{$ENDIF}
function GetLocaleLanguage: string;
begin
  {$IFDEF MSWINDOWS}
   Result := GetLocaleInformation(LOCALE_SENGLANGUAGE);
  {$ELSE}
   Result := SysUtils.GetEnvironmentVariable('LANG');
  {$ENDIF}
end;

function MIDIPartition(var arr: array of MidiNote; low, high: integer):integer;
var
  i, j, pivot:integer;
  tempNote: MidiNote;
begin
  i := (low-1);
  pivot := arr[high].deltaTime;

  for j:=low to high-1 do
    if arr[j].deltaTime <= pivot then
    begin
      i := i+1;
      tempNote := arr[i];
      arr[i] := arr[j];
      arr[j] := tempNote;
    end;
  tempNote := arr[i+1];
  arr[i+1] := arr[high];
  arr[high] := tempNote;
  MIDIPartition := i+1;
end;
procedure MIDISort(var arr: array of MidiNote; low, high: integer);
var
  pindex: integer;
begin
  if low < high then
  begin
    pindex := MIDIPartition(arr, low, high);

    MIDISort(arr, low, pindex-1);
    MIDISort(arr, pindex+1, high);
  end;
end;

procedure Translate;
var
  Lang: string;
begin
  Lang := GetLocaleLanguage;
  with FMain do
  begin
    if (Lang = 'Russian') or (Lang = 'Ukrainian') or (Lang = 'Belarusian') then
    begin
      TRLastNote := 'Последняя сыгранная нота: ';
      TRLastVelocity := 'Сила последней сыгранной ноты: ';
      TRNotRegistered := ' (НЕ ЗАРЕГИСТРИРОВАННО)';
      InputFrame.Caption := 'Конфигурация ввода';
        InputPorts.Hint := 'Тут будут отображаться все доступные устройства ввода.';
        InputLabel.Caption := 'Ввод из:';
        InputButton.Caption := 'Обновить';
      OptionsFrame.Caption := 'Опции';
        ThresholdTrack.Hint := 'Ноты с силой менее указанной не будут сыграны.';
        ThresholdLabel.Caption := 'Предельная сила:';
        TuneTrack.Hint := 'Настраивает ввод по полутонам.';
        TuneLabel.Caption := 'Настр.';
        TransposeCheck.Caption := 'Транспонировать октавы вне диапазона';
        TransposeCheck.Hint := 'Если включено, ноты, сыгранные вне диапазона ф-но Роблокса будут транспонированы на чистую октаву вверх или вниз.';
      TextLabel.Caption := 'Сыграйте любую ноту на вашей клавиатуре.';
    end;
  end;
end;
function InRange(const val, ran, range: real): boolean;
begin
  InRange := false;
  if (val >= ran-range) and (val <= ran+range) then InRange := true;
end;

function IsShifted(const charIn: char):boolean;
var
  pressValue: byte;
begin
  pressValue := Ord(charIn);
  IsShifted := false;
  if ((pressValue >= 65) and (pressValue <= 90)) or (AnsiContainsStr(')!@#$%^&*(', charIn)) then IsShifted := true;
end;
function GetKeyValue(const charIn: char):byte;
var
  pressValue: byte;
begin
  pressValue := Ord(charIn);
  if (pressValue >= 97) and (pressValue <= 122) then GetKeyValue := pressValue - 32;
  if ((pressValue >= 48) and (pressValue <= 57)) or ((pressValue >= 65) and (pressValue <= 90)) then GetKeyValue := pressValue;
  if AnsiContainsStr(')!@#$%^&*(', charIn) then GetKeyValue := Pos(charIn, ')!@#$%^&*(') + 47;
end;
procedure QueryInput;
var
  i, amount: integer;
  devCaps: TMIDIINCAPS;
begin
  Inputs.Clear;
  amount := midiInGetNumDevs;
  for i:=0 to amount-1 do
  begin
    if midiInGetDevCaps(i, @devCaps, SizeOf(TMIDIINCAPS)) = MMSYSERR_NOERROR then
    begin
      Inputs.Add(StrPas(devCaps.szPname));
    end;
  end;
  FMain.InputPorts.Items := Inputs;
  FMain.InputPorts.ItemIndex := FMain.InputPorts.Items.Count-1;
  PrintTStingList(Inputs);
  FMain.InputPortsChange(nil);
end;
procedure QueryOutput;
var
  i, amount: integer;
  devCaps: TMIDIOUTCAPS;
begin
  Outputs.Clear;
  amount := midiOutGetNumDevs;
  Outputs.Add('None');
  for i:=0 to amount-1 do
  begin
    if midiOutGetDevCaps(i, @devCaps, SizeOf(TMIDIOUTCAPS)) = MMSYSERR_NOERROR then
    begin
      Outputs.Add(StrPas(devCaps.szPname));
    end;
  end;
  FMain.OutputPorts.Items := Outputs;
  FMain.OutputPorts.ItemIndex := 0;
  PrintTStingList(Outputs);
  FMain.OutputPortsChange(nil);
end;

procedure CloseInput;
begin
  midiInStop(InputDevice);
  midiInReset(InputDevice);
  //midiInUnprepareHeader(InputDevice, @InputHDR, SizeOf(TMIDIHDR));
  midiInClose(InputDevice);
end;
procedure CloseOutput;
begin
  midiOutReset(OutputDevice);
  //midiInUnprepareHeader(InputDevice, @InputHDR, SizeOf(TMIDIHDR));
  midiOutClose(OutputDevice);
end;
function PressKey(ptrIn: pointer):ptrint;
var
  intIn, keyNum: integer;
begin
  intIn := PtrInt(ptrIn);
  //ShowMessage(IntToStr(intIn));
  pianoKeys[intIn].Brush.Color := clLtGray;
  Sleep(200);
  keyNum := intIn mod 12;
  if pianoKeys[intIn].black then
    pianoKeys[intIn].Brush.Color := clBlack
  else
    pianoKeys[intIn].Brush.Color := clWhite;
end;
procedure PressLetter(const charIn: byte);
var
  kv: byte;
begin
  if Layout[charIn] <> ' ' then
  begin
    kv := GetKeyValue(Layout[charIn]);
    if (IsShifted(Layout[charIn])) then keybd_event(160, MapVirtualKey(160, 0), 0, 0);
    keybd_event(kv, MapVirtualKey(kv, 0), 0, 0);
    keybd_event(kv, MapVirtualKey(kv, 0), 2, 0);
    if (IsShifted(Layout[charIn])) then keybd_event(160, MapVirtualKey(160, 0), 2, 0);
  end;
  if (FMain.KeyboardCheck.Checked) and (remapMode = false) then
  begin
    BeginThread(@PressKey, Pointer(charIn));
  end;
end;

procedure DoMidiInData(aMidiInHandle: PHMIDIIN; aMsg: Integer; aInstance, aMidiData, aTimeStamp: integer); stdcall;
var
  channel: byte;
  key: byte;
  playedKey: integer;
  velocity: byte;
begin
  if (aMsg = MIM_DATA) and (not remapMode) then
  begin
    channel := aMidiData and $000000FF;
    key := Clamp(((aMidiData and $0000FF00) shr 8) + Tune, 0, 255);
    velocity := (aMidiData and $00FF0000) shr 16;
    if (channel >= 144) and (channel <= 146) and (velocity > Threshold) then
    begin
      playedKey := key-36;
      //ShowMessage(IntToStr(playedKey));
      if Mute then
      begin
        FMain.TextLabel.Text := TRLastNote+IntToStr(key)+TRNotRegistered+#13+
        TRLastVelocity+IntToStr(velocity);
        Exit;
      end;
      if (playedKey >= 0) and (playedKey<Length(Layout)) then
      begin
        PressLetter(playedKey);
      end
      else
      begin
        if Transpose then
        begin
          if key < 36 then playedKey := key mod 12;
          if key >= Length(Layout) then playedKey := Length(Layout) - 13 + (key mod 12);
          PressLetter(playedKey);
        end
        else
        begin
          FMain.TextLabel.Text := TRLastNote+IntToStr(key)+TRNotRegistered+#13+
          TRLastVelocity+IntToStr(velocity);
          Exit;
        end;
      end;
      FMain.TextLabel.Text := TRLastNote+IntToStr(key)+' ('+Layout[Max(0, Min(playedKey, Length(Layout)-1))]+')'+#13+
      TRLastVelocity+IntToStr(velocity);
    end;
  end;
end;
procedure DoMIDITimer(TimeID, Msg: UINT; dwUser, dw1, dw2: DWORD); stdcall;
var
  tempo: double;
  playedKey: integer;
  key, velocity: byte;
begin
  tempo := (120/timeTempo)/100*TempoPercent;
  FMain.MIDIProgress.Position := Round(timeScale/100);
  while InRange(midi.notes[midiPointer].deltaTime, Round(timeScale), tempo) do
  begin
    case midi.notes[midiPointer].ntype of
      $9 : begin
        key := Clamp(midi.notes[midiPointer].key + Tune, 0, 255);
        velocity := midi.notes[midiPointer].velocity;
        if (LevelDynamics) and (velocity <> 0) then velocity := 64;
        if (velocity > Threshold) or ((velocity = 0) and (not sustain)) then
        midiOutShortMsg(OutputDevice, $90 +
        (Clamp(key+Tune, 0, 127) shl 8)+
        (velocity shl 16));
        playedKey := key-36;
        if (velocity > Threshold) and (not remapMode) then
        begin
          if Mute then
          begin
            FMain.TextLabel.Text := TRLastNote+IntToStr(key)+TRNotRegistered+#13+
            TRLastVelocity+IntToStr(velocity);
          end
          else if (playedKey >= 0) and (playedKey<Length(Layout)) then
            PressLetter(playedKey)
          else
          begin
            if Transpose then
            begin
              if key < 36 then playedKey := key mod 12;
              if key >= Length(Layout) then playedKey := Length(Layout) - 13 + (key mod 12);
              PressLetter(playedKey);
            end
            else
            begin
              FMain.TextLabel.Text := TRLastNote+IntToStr(key)+TRNotRegistered+#13+
              TRLastVelocity+IntToStr(velocity);
              timeScale := timeScale - tempo;
              midiPointer := midiPointer + 1;
              if midiPointer >= Length(midi.notes)-1 then
              begin
                timeKillEvent(midiTimer);
                Break;
              end;
              Exit;
            end;
          end;
          if not Mute then
            FMain.TextLabel.Text := TRLastNote+IntToStr(key)+' ('+Layout[Max(0, Min(playedKey, Length(Layout)-1))]+')'+#13+
            TRLastVelocity+IntToStr(velocity);
        end;
      end;
      $10 : begin
        if PlayPercussion then
        begin
          key := Clamp(midi.notes[midiPointer].key + Tune, 0, 255);
          velocity := midi.notes[midiPointer].velocity;
          if (LevelDynamics) and (velocity <> 0) then velocity := 64;
          if (velocity > Threshold) or ((velocity = 0) and (not sustain)) then
          midiOutShortMsg(OutputDevice, $90 +
          (Clamp(key+Tune, 0, 127) shl 8)+
          (velocity shl 16));
          playedKey := key-36;
          if (velocity > Threshold) and (not remapMode) then
          begin
            if Mute then
            begin
              FMain.TextLabel.Text := TRLastNote+IntToStr(key)+TRNotRegistered+#13+
              TRLastVelocity+IntToStr(velocity);
            end
            else if (playedKey >= 0) and (playedKey<Length(Layout)) then
              PressLetter(playedKey)
            else
            begin
              if Transpose then
              begin
                if key < 36 then playedKey := key mod 12;
                if key >= Length(Layout) then playedKey := Length(Layout) - 13 + (key mod 12);
                PressLetter(playedKey);
              end
              else
              begin
                FMain.TextLabel.Text := TRLastNote+IntToStr(key)+TRNotRegistered+#13+
                TRLastVelocity+IntToStr(velocity);
                timeScale := timeScale - tempo;
                midiPointer := midiPointer + 1;
                if midiPointer >= Length(midi.notes)-1 then
                begin
                  timeKillEvent(midiTimer);
                  Break;
                end;
                Exit;
              end;
            end;
            if not Mute then
              FMain.TextLabel.Text := TRLastNote+IntToStr(key)+' ('+Layout[Max(0, Min(playedKey, Length(Layout)-1))]+')'+#13+
              TRLastVelocity+IntToStr(velocity);
          end;
        end;
      end;
      $40 : midiOutShortMsg(OutputDevice, $B0 + ($40 shl 8) + (midi.notes[midiPointer].velocity shl 16));
      $51 : timeTempo := midi.notes[midiPointer].info;
    end;
    //timeScale := timeScale - tempo;
    midiPointer := midiPointer + 1;
    if midiPointer >= Length(midi.notes) then
    begin
      timeKillEvent(midiTimer);
      Break;
    end;
  end;
  timeScale := timeScale + tempo;
end;
procedure OpenMIDI(const fname: widestring);
begin
  midi := MidiFile.Create(fname);
  MIDISort(midi.notes, 0, Length(midi.notes)-1);
  //WriteLn('LENGTH IS ',midi.notes[Length(midi.notes)-1].deltaTime);
end;
procedure StopMIDI; forward;
procedure PlayMIDI;
begin
  if midiopen then
  begin
    midipaused := false;
    if midiPointer >= Length(midi.notes) then
      StopMIDI;
    FMain.MIDIProgress.Max := Round(midi.notes[Length(midi.notes)-1].deltaTime/100);
    timeKillEvent(midiTimer);
    //WriteLn(midiTimer);
    midiTimer := timeSetEvent(1, 0, @DoMIDITimer, 0, TIME_PERIODIC);
  end;
end;
procedure PauseMIDI;
begin
  if midipaused then PlayMIDI
  else
  begin
    timeKillEvent(midiTimer);
    midiOutReset(OutputDevice);
    midipaused := true;
  end
end;
procedure StopMIDI;
begin
  midipaused := false;
  PauseMidi;
  midipaused := true;
  FMain.MIDIProgress.Position := 0;
  midiPointer := 0;
  timeScale := 0;
end;
procedure JumpMIDI(amount: integer);
begin
  if midiopen then
  begin
    midiPointer := Clamp(midiPointer+amount, 0, Length(midi.notes));
    timeScale := midi.notes[midiPointer].deltaTime;
    FMain.MIDIProgress.Position := Round(timeScale/100);
  end;
end;
function LowLevelKeyboardHook(nCode: Integer; wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
var
  pkbhs: PKBDLLHOOKSTRUCT;
  VirtualKey: integer;
  Key: char;
begin
  pkbhs := PKBDLLHOOKSTRUCT(Pointer(lParam));
  if nCode = HC_ACTION then
    VirtualKey := pkbhs^.vkCode;
    if wParam = WM_KEYDOWN then
    begin
      case VirtualKey of
        VK_END: PauseMIDI;
        VK_RSHIFT: shiftDown:=true;
        VK_LSHIFT: shiftDown:=true;
        VK_ESCAPE: if (remapMode) and (waitForKey <> -1) then
        begin
          if pianoKeys[waitForKey].black then pianoKeys[waitForKey].Brush.Color := clBlack else pianoKeys[waitForKey].Brush.Color := clWhite;
          FMain.TextLabel.Text := 'Layout edit (mapping) mode on, no input will be registered.'+#13+'Click a key to assign a character to it.';
          waitForKey := -1;
        end;
      end;
      if remapMode then
      begin
        if (waitForKey <> -1) and ((VirtualKey >= $30) and (VirtualKey <= $5A)) then
        begin
          Key := Chr(VirtualKey);
          if shiftDown then
          begin
            case VirtualKey of
              $30: Key := ')';
              $31: Key := '!';
              $32: Key := '@';
              $33: Key := '#';
              $34: Key := '$';
              $35: Key := '%';
              $36: Key := '^';
              $37: Key := '&';
              $38: Key := '*';
              $39: Key := '(';
              else Key := UpCase(Key);
            end;
          end
            else Key := LowerCase(Key);
          pianoLabels[waitForKey].Caption := Key;
          Layout[waitForKey] := Key;
          FMain.TextLabel.Text := 'Key assigned as '''+Key+'''.';
          if pianoKeys[waitForKey].black then pianoKeys[waitForKey].Brush.Color := clBlack else
          begin
            pianoKeys[waitForKey].Brush.Color := clWhite;
            pianoLabels[waitForKey].Caption := #13#13+Key;
          end;
          waitForKey := -1;
          TriggerChanges;
        end;
      end;
    end
    else if wParam = WM_KEYUP then
    begin
      case VirtualKey of
        VK_RSHIFT: shiftDown:=false;
        VK_LSHIFT: shiftDown:=false;
      end;
    end;
  Result := CallNextHookEx(llKeyboardHook, nCode, wParam, lParam);
end;
procedure TFMain.ResizeKeys(Sender: TObject);
var
  i, keyNum: integer;
  leftAcc, keyWidth: double;
begin
  if KeyboardCheck.Checked then
  begin
    keyWidth := FMain.Width / 36;
    leftAcc := 0;
    for i:=0 to Length(pianoKeys)-1 do
    begin
      pianoKeys[i].Width := Round(keyWidth);
      pianoLabels[i].Width := pianoKeys[i].Width;
      pianoKeys[i].Left := Round(leftAcc);
      pianoLabels[i].Left := pianoKeys[i].Left;
      pianoKeys[i].Top := Height - 84;
      pianoLabels[i].Top := pianoKeys[i].Top;
      keyNum := i mod 12;
      leftAcc := leftAcc + keyWidth;
      if pianoKeys[i].black then
      begin
        pianoKeys[i].Width := Round(keyWidth/1.5);
        pianoLabels[i].Width := pianoKeys[i].Width;
        pianoKeys[i].Left := Round(leftAcc-keyWidth*1.35);
        pianoLabels[i].Left := pianoKeys[i].Left;
        //pianoLabels[i].Top := pianoKeys[i].Top;
        leftAcc := leftAcc - keyWidth;
      end
      else
        if (keyNum <> 0) and (keyNum <> 5) then
        begin
          pianoKeys[i-1].BringToFront;
        end;
      if i>0 then
        pianoLabels[i-1].BringToFront;
    end;
    pianoLabels[Length(pianoLabels)-1].BringToFront;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
var
  i, keyNum: integer;
begin
  SetPriorityClass(GetCurrentProcess, $8000);
  //Translate;
  Inputs := TStringList.Create;
  Outputs := TStringList.Create;
  QueryInput;
  QueryOutput;
  if Inputs.Count > 0 then
  begin
    InputIndex := 0;
    InputPorts.ItemIndex:=0;
  end;
  if llKeyboardHook = 0 then
    llKeyboardHook := SetWindowsHookEx(13, @LowLevelKeyboardHook, HInstance, 0);
  for i:=0 to Length(pianoKeys)-1 do
  begin
    pianoKeys[i] := PianoKey.Create(FMain);
    pianoKeys[i].number := i;
    pianoKeys[i].black := false;
    pianoLabels[i] := TLabel.Create(FMain);
    pianoLabels[i].OnMouseEnter := @pianoKeys[i].PKMouseON;
    pianoLabels[i].OnMouseLeave := @pianoKeys[i].PKMouseOFF;
    pianoLabels[i].OnClick := @pianoKeys[i].PKClick;
    pianoLabels[i].AutoSize := false;
    pianoLabels[i].Layout := tlCenter;
    pianoLabels[i].Alignment := taCenter;
    keyNum := i mod 12;
    pianoKeys[i].Pen.Color := clGray;
    pianoLabels[i].Font.Color := clGray;
    pianoLabels[i].Height := 64;
    pianoKeys[i].Height := 64;
    pianoLabels[i].Caption := #13#13+Layout[i];
    if (keyNum = 1) or (keyNum = 3) or (keyNum = 6) or (keyNum = 8) or (keyNum = 10) then
    begin
      pianoKeys[i].black := true;
      pianoKeys[i].Brush.Color := clBlack;
      pianoLabels[i].Font.Color := clWhite;
      pianoLabels[i].Height := 40;
      pianoKeys[i].Height := 40;
      pianoLabels[i].Caption := Layout[i];
    end;
    pianoLabels[i].Parent := FMain;
    pianoKeys[i].Parent := FMain;
    pianoLabels[i].Visible := false;
    pianoKeys[i].Visible := false;
    //pianoKeys[i].Enabled := false;
  end;
  //midiOutOpen(@OutputDevice, OutputIndex, 0, 0, CALLBACK_NULL);
  // LOAD PREFERENCES
  ini := TIniFile.Create('preferences.ini');
  ThresholdTrack.Position := ini.ReadInteger('Options', 'Threshold', 0);
  TuneTrack.Position := ini.ReadInteger('Options', 'Tune', 0);
  TransposeCheck.Checked := ini.ReadBool('Options', 'Transpose', false);
  MuteCheck.Checked := ini.ReadBool('Options', 'Mute', false);
  TopCheck.Checked := ini.ReadBool('Options', 'StayOnTop', false);
  DrumsCheck.Checked := ini.ReadBool('MIDI', 'PlayPercussion', false);
  DynamicsCheck.Checked := ini.ReadBool('MIDI', 'LevelDynamics', false);
  SustainCheck.Checked := ini.ReadBool('MIDI', 'Sustain', false);
  MIDITempo.Value := ini.ReadInteger('MIDI', 'TempoPercent', 100);
  JumpAmount := ini.ReadInteger('MIDI', 'JumpAmount', 1);
  case JumpAmount of
    1: MIDIJump1.Checked := true;
    5: MIDIJump5.Checked := true;
    10: MIDIJump10.Checked := true;
    50: MIDIJump50.Checked := true;
    else MIDIJumpCustom.Checked := true;
  end;
  if ini.ReadBool('Options', 'ShowKeyboard', false) then
  begin
    KeyboardCheck.Checked := true;
    InputFrame.Top := InputFrame.Top+84;
    OptionsFrame.Top := OptionsFrame.Top+84;
    MIDIFrame.Top := MIDIFrame.Top+84;
  end;
  //KeyboardCheck.Checked := ini.ReadBool('Options', 'ShowKeyboard', false);
end;
procedure TFMain.FileLayoutClick(Sender: TObject);
var
  charFile: TextFile;
  charRead: string;
  i: integer;
begin
  if OpenLayout.Execute then
  begin
    AssignFile(charFile, OpenLayout.FileName);
    Reset(charFile);
    for i:=0 to Length(Layout)-1 do
    begin
      ReadLn(charFile, charRead);
      Layout[i] := charRead[1];
      pianoLabels[i].Caption := charRead[1];
    end;
    CloseFile(charFile);
  end;
end;
procedure TFMain.FileMIDICloseClick(Sender: TObject);
begin
  if midiopen then midi.Destroy;
  midiopen := false;
  StopMIDI;
end;
procedure TFMain.FileMIDIOpenClick(Sender: TObject);
begin
  if OpenMIDIDialog.Execute then
  begin
    StopMIDI;
    if midiopen then midi.Destroy;
    OpenMIDI(OpenMIDIDialog.FileName);
  end;
end;

procedure TFMain.DrumsCheckChange(Sender: TObject);
begin
  PlayPercussion := DrumsCheck.Checked;
  ini.WriteBool('MIDI', 'PlayPercussion', PlayPercussion);
end;
procedure TFMain.DynamicsCheckChange(Sender: TObject);
begin
  LevelDynamics := DynamicsCheck.Checked;
  ini.WriteBool('MIDI', 'LevelDynamics', LevelDynamics);
end;
procedure TFMain.EditLayoutClick(Sender: TObject);
begin
  remapMode:=EditLayout.Checked;
  if not KeyboardCheck.Checked then
  begin
    KeyboardCheck.Checked := true;
  end;
  if remapMode then TextLabel.Text := 'Layout edit (mapping) mode on, no input will be registered.'+#13+'Click a key to assign a character to it.' else TextLabel.Text := 'Play any note on your piano keyboard.';
end;
procedure TFMain.EditShiftDownClick(Sender: TObject);
var
  i: integer;
  c: char;
begin
  c := Layout[0];
  for i:=0 to Length(Layout)-2 do
  begin
    Layout[i] := Layout[i+1];
    if pianoKeys[i].black then
      pianoLabels[i].Caption := Layout[i]
    else
      pianoLabels[i].Caption := #13#13+Layout[i];
  end;
  Layout[Length(Layout)-1] := c;
  pianoLabels[Length(pianoLabels)-1].Caption := #13#13+c;
  TriggerChanges;
end;
procedure TFMain.EditShiftUpClick(Sender: TObject);
var
  i: integer;
  c: char;
begin
  c := Layout[Length(Layout)-1];
  for i:=Length(Layout)-1 downto 1 do
  begin
    Layout[i] := Layout[i-1];
    if pianoKeys[i].black then
      pianoLabels[i].Caption := Layout[i]
    else
      pianoLabels[i].Caption := #13#13+Layout[i];
  end;
  Layout[0] := c;
  pianoLabels[0].Caption := #13#13+c;
  TriggerChanges;
end;
procedure TFMain.FileCreateClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to Length(Layout)-1 do
  begin
    Layout[i] := ' ';
    pianoLabels[i].Caption := ' ';
  end;
end;
procedure TFMain.FileSaveAsClick(Sender: TObject);
begin
  if SaveLayoutDialog.Execute then
  begin
    layoutFile := SaveLayoutDialog.FileName;
    SaveLayout;
  end;
end;
procedure TFMain.FileSaveClick(Sender: TObject);
begin
  if layoutFile = '' then
    if SaveLayoutDialog.Execute then
    begin
      layoutFile := SaveLayoutDialog.FileName;
    end;
  if layoutFile <> '' then
  begin
    SaveLayout;
  end;
end;
procedure TFMain.FileExitClick(Sender: TObject);
begin
  Halt;
end;
procedure TFMain.FormDestroy(Sender: TObject);
begin
  StopMIDI;
  CloseInput;
  CloseOutput;
  if (llKeyboardHook <> 0) and UnhookWindowsHookEx(llKeyboardHook) then
  begin
    llKeyboardHook := 0;
  end;
end;
procedure TFMain.HelpAboutClick(Sender: TObject);
begin
  FAbout.ShowModal;
end;
procedure TFMain.HelpDocsClick(Sender: TObject);
begin
  FAbout.BtnDocsClick(nil);
end;
procedure TFMain.InputButtonClick(Sender: TObject);
begin
  QueryInput;
  QueryOutput;
end;
procedure TFMain.InputPortsChange(Sender: TObject);
begin
  CloseInput;
  InputIndex := InputPorts.ItemIndex;
  if midiInGetNumDevs > 0 then
  begin
    midiInOpen(@InputDevice, InputIndex, Cardinal(@DoMidiInData), InputIndex, CALLBACK_FUNCTION);
    //midiInPrepareHeader(InputDevice, @InputHDR, SizeOf(TMIDIHDR));
    //midiInAddBuffer(InputDevice, @InputHDR, SizeOf(TMIDIHDR));
    midiInStart(InputDevice);
    //if (InputIndex >= 0) then WriteLn('Changed input to '+Inputs[InputIndex], InputIndex);
  end;
end;
procedure TFMain.KeyboardCheckChange(Sender: TObject);
var
  KeyboardHeight: integer = 64;
  i: integer;
begin
  if KeyboardCheck.Checked then
  begin
    Constraints.MinHeight := FMain.Constraints.MinHeight+KeyboardHeight;
    Height := FMain.Height+KeyboardHeight;
    InputFrame.Top := InputFrame.Top-KeyboardHeight;
    OptionsFrame.Top := OptionsFrame.Top-KeyboardHeight;
    MIDIFrame.Top := MIDIFrame.Top-KeyboardHeight;
    for i:=0 to Length(pianoKeys)-1 do
    begin
      pianoKeys[i].Visible := true;
      pianoLabels[i].Visible := true;
    end;
  end
  else
  begin
    Constraints.MinHeight := FMain.Constraints.MinHeight-KeyboardHeight;
    Height := FMain.Height-KeyboardHeight;
    InputFrame.Top := InputFrame.Top+KeyboardHeight;
    OptionsFrame.Top := OptionsFrame.Top+KeyboardHeight;
    MIDIFrame.Top := MIDIFrame.Top+KeyboardHeight;
    for i:=0 to Length(pianoKeys)-1 do
    begin
      pianoKeys[i].Visible := false;
      pianoLabels[i].Visible := false;
    end;
  end;
  ini.WriteBool('Options', 'ShowKeyboard', KeyboardCheck.Checked);
end;

procedure TFMain.MIDIJump10Click(Sender: TObject);
begin
  JumpAmount := 10;
  ini.WriteInteger('MIDI', 'JumpAmount', JumpAmount);
end;
procedure TFMain.MIDIJump1Click(Sender: TObject);
begin
  JumpAmount := 1;
  ini.WriteInteger('MIDI', 'JumpAmount', JumpAmount);
end;
procedure TFMain.MIDIJump50Click(Sender: TObject);
begin
  JumpAmount := 50;
  ini.WriteInteger('MIDI', 'JumpAmount', JumpAmount);
end;
procedure TFMain.MIDIJump5Click(Sender: TObject);
begin
  JumpAmount := 5;
  ini.WriteInteger('MIDI', 'JumpAmount', JumpAmount);
end;
procedure TFMain.MIDIJumpCustomClick(Sender: TObject);
var
  strval: string;
begin
  Str(JumpAmount, strval);
  FJump.JumpInput.Text := IntToStr(JumpAmount);
  if FJump.ShowModal = mrOK then
  begin
    JumpAmount := CustomJumpResult;
    MIDIJumpCustom.Checked := true;
    ini.WriteInteger('MIDI', 'JumpAmount', JumpAmount);
  end;
end;

procedure TFMain.MIDINextButtonClick(Sender: TObject);
begin
  JumpMIDI(JumpAmount);
end;
procedure TFMain.MIDIPauseButtonClick(Sender: TObject);
begin
  PauseMIDI;
end;
procedure TFMain.MIDIPauseClick(Sender: TObject);
begin
  PauseMIDI;
end;
procedure TFMain.MIDIPlayButtonClick(Sender: TObject);
begin
  PlayMIDI;
end;
procedure TFMain.MIDIPlayClick(Sender: TObject);
begin
  PlayMIDI;
end;
procedure TFMain.MIDIPrevButtonClick(Sender: TObject);
begin
  JumpMIDI(-JumpAmount);
end;
procedure TFMain.MIDIStopButtonClick(Sender: TObject);
begin
  StopMIDI;
end;
procedure TFMain.MIDIStopClick(Sender: TObject);
begin
  StopMIDI;
end;
procedure TFMain.MIDITempoChange(Sender: TObject);
begin
  //Val(MIDITempo.text, prsInt);
  TempoPercent := MIDITempo.Value;
  //WriteLn(TempoPercent);
  ini.WriteInteger('MIDI', 'TempoPercent', TempoPercent);
end;
procedure TFMain.MuteCheckChange(Sender: TObject);
begin
  Mute := MuteCheck.Checked;
  ini.WriteBool('Options', 'Mute', Mute);
end;
procedure TFMain.OutputPortsChange(Sender: TObject);
begin
  CloseOutput;
  OutputIndex := OutputPorts.ItemIndex;
  if OutputIndex > 0 then
  begin
    midiOutOpen(@OutputDevice, OutputIndex-1, 0, 0, CALLBACK_NULL);
    //WriteLn('Changed output to '+Outputs[OutputIndex], OutputIndex);
  end;
end;
procedure TFMain.SustainCheckChange(Sender: TObject);
begin
  Sustain := SustainCheck.Checked;
  ini.WriteBool('MIDI', 'Sustain', Sustain);
end;
procedure TFMain.ThresholdTrackChange(Sender: TObject);
begin
  ThresholdShow.Caption := IntToStr(ThresholdTrack.Position);
  Threshold := ThresholdTrack.Position;
  ini.WriteInteger('Options', 'Threshold', Threshold);
end;
procedure TFMain.TopCheckChange(Sender: TObject);
begin
  if TopCheck.Checked then
  begin
    FMain.FormStyle := fsSystemStayOnTop;
    ini.WriteBool('Options', 'StayOnTop', true);
  end
  else begin
    FMain.FormStyle := fsNormal;
    ini.WriteBool('Options', 'StayOnTop', false);
  end;
end;

procedure TFMain.TransposeCheckChange(Sender: TObject);
begin
  Transpose := TransposeCheck.Checked;
  ini.WriteBool('Options', 'Transpose', Transpose);
end;
procedure TFMain.TuneMClick(Sender: TObject);
begin
  TuneTrack.Position := TuneTrack.Position-1;

end;
procedure TFMain.TunePClick(Sender: TObject);
begin
  TuneTrack.Position := TuneTrack.Position+1;
end;
procedure TFMain.TuneTrackChange(Sender: TObject);
begin
  TuneShow.Caption := IntToStr(TuneTrack.Position);
  Tune := TuneTrack.Position;
  ini.WriteInteger('Options', 'Tune', Tune);
end;

{$R *.lfm}

end.

