unit customJump;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TFJump }

  TFJump = class(TForm)
    JumpCancel: TButton;
    JumpOk: TButton;
    JumpInput: TLabeledEdit;
    procedure JumpInputChange(Sender: TObject);
    procedure JumpOkClick(Sender: TObject);
  private

  public

  end;

var
  FJump: TFJump;
  CustomJumpResult: integer;

implementation

{$R *.lfm}

{ TFJump }

procedure TFJump.JumpInputChange(Sender: TObject);
var
  intval: integer;
begin
  Val(JumpInput.Text, intval);
  JumpInput.Text := IntToStr(intval);
end;

procedure TFJump.JumpOkClick(Sender: TObject);
begin
  Val(JumpInput.Text, CustomJumpResult);
end;

end.

