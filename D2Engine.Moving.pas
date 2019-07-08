unit D2Engine.Moving;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections;

type
  TProcedure = procedure of object;

  TMovingThread = class(TThread)
  private
    FStop: Boolean;
    FSleepTime: Cardinal;
    FExecMethod: TProcedure;
    procedure SetExecMethod(const Value: TProcedure);
  protected
    procedure Execute; override;
  public
    constructor Create;
    procedure Stop;
    property ExecMethod: TProcedure read FExecMethod write SetExecMethod;
  end;

implementation

uses Math;

{ TMovingThread }

constructor TMovingThread.Create;
begin
  inherited Create(True);
  FStop := False;
  FSleepTime := 5;
  FreeOnTerminate := False;
end;

procedure TMovingThread.Execute;
var TickCount: Cardinal;
begin
  while not FStop do
  begin
    TickCount := GetTickCount;
    if Assigned(FExecMethod) then FExecMethod;
    TickCount := GetTickCount - TickCount;//Потрачено времени
    Sleep(Min(FSleepTime, Max(0, FSleepTime - TickCount)));
  end;
end;

procedure TMovingThread.SetExecMethod(const Value: TProcedure);
begin
  FExecMethod := Value;
end;

procedure TMovingThread.Stop;
begin
  FStop := True;
end;

end.
