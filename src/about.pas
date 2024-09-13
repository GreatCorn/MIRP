unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DOS, LCLIntf;

type

  { TFAbout }

  TFAbout = class(TForm)
    AboutText: TStaticText;
    BtnClose: TButton;
    ImgMIRP: TImage;
    ImgGPL: TImage;
    ImgCorn: TImage;
    LabelGPL: TLabel;
    LabelMIRP: TLabel;
    LabelCorn: TLabel;
    StaticText1: TStaticText;
    procedure BtnDocsClick(Sender: TObject);
    procedure ImgCornClick(Sender: TObject);
    procedure ImgGPLClick(Sender: TObject);
    procedure ImgMIRPClick(Sender: TObject);
    procedure LabelCornClick(Sender: TObject);
    procedure LabelGPLClick(Sender: TObject);
    procedure LabelMIRPClick(Sender: TObject);
  private

  public

  end;

var
  FAbout: TFAbout;

implementation

{$R *.lfm}

{ TFAbout }

procedure TFAbout.BtnDocsClick(Sender: TObject);
begin
  OpenURL('https://greatcorn.github.io/MIRP/docs/About.htm');
end;

procedure TFAbout.ImgCornClick(Sender: TObject);
begin
  OpenURL('https://www.youtube.com/GreatCornholio231432');
end;

procedure TFAbout.ImgGPLClick(Sender: TObject);
begin
  OpenURL('https://www.gnu.org/licenses/gpl-3.0.txt');
end;

procedure TFAbout.ImgMIRPClick(Sender: TObject);
begin
  OpenURL('https://greatcorn.github.io/MIRP');
end;

procedure TFAbout.LabelCornClick(Sender: TObject);
begin
  OpenURL('https://www.youtube.com/GreatCornholio231432');
end;

procedure TFAbout.LabelGPLClick(Sender: TObject);
begin
  OpenURL('https://www.gnu.org/licenses/gpl-3.0.txt');
end;

procedure TFAbout.LabelMIRPClick(Sender: TObject);
begin
  OpenURL('https://greatcorn.github.io/MIRP');
end;

end.

