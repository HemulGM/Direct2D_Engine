unit D2Engine.Simples;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Sprite, D2Engine.Classes, D2Engine.Sprites.Physical;

type
  TSquare = class(TPhysicalSprite)
    function GetCollisonRect: TFloatRect; override;
  private
    FColor: TColor;
    FR, FG, FB: Byte;
    FDoJump: Boolean;
    FJumpSize: Double;
    FMaxJumpSize: Integer;
    procedure SetColor(const Value: TColor);
  public
    procedure Draw(Canvas: TDirect2DCanvas); override;
    procedure Update; override;
    procedure OnCollision(Sprite: TSprite); override;
    constructor Create(AOwner: TObject; ALayer: Integer; Rct: TRect; Angle: Double); virtual;
    property Color: TColor read FColor write SetColor;
  end;

  TWheel = class(TSprite)
    function GetCollisonRect: TFloatRect; override;
  private
    FColor: TColor;
    FR, FG, FB: Byte;
    procedure SetColor(const Value: TColor);
  public
    procedure Draw(Canvas: TDirect2DCanvas); override;
    procedure Update; override;
    procedure OnCollision(Sprite: TSprite); override;
    constructor Create(AOwner: TObject; ALayer: Integer; Rct: TRect; Angle: Double); virtual;
    property Color: TColor read FColor write SetColor;
  end;

  TFloor = class(TSprite)
    function GetCollisonRect: TFloatRect; override;
  private
    FColor: TColor;
    procedure SetColor(const Value: TColor);
  public
    procedure Draw(Canvas: TDirect2DCanvas); override;
    constructor Create(AOwner: TObject; ALayer: Integer; Height: Double); virtual;
    property Color: TColor read FColor write SetColor;
  end;

  TWall = class(TSprite)
    function GetCollisonRect: TFloatRect; override;
  private
    FColor: TColor;
    procedure SetColor(const Value: TColor);
  public
    procedure Draw(Canvas: TDirect2DCanvas); override;
    procedure Update; override;
    procedure OnCollision(Sprite: TSprite); override;
    constructor Create(AOwner: TObject; ALayer: Integer; Height: Double); virtual;
    property Color: TColor read FColor write SetColor;
  end;

  TPlatform = class(TSprite)
    function GetCollisonRect: TFloatRect; override;
  private
    FColor: TColor;
    procedure SetColor(const Value: TColor);
  public
    procedure Draw(Canvas: TDirect2DCanvas); override;
    constructor Create(AOwner: TObject; ALayer: Integer); virtual;
    property Color: TColor read FColor write SetColor;
  end;

implementation

uses
  Math, D2Engine.Core;

{ TSquare }

constructor TSquare.Create(AOwner: TObject; ALayer: Integer; Rct: TRect; Angle: Double);
begin
  inherited Create(AOwner, ALayer);
  Position := Rct.CenterPoint;
  IsStatic := False;
  Rotation := Angle;
  Size := Rct.Size;
  FR := 255;
  FG := 0;
  FB := 0;
  FJumpSize := 0;
  FMaxJumpSize := 6;
  FDoJump := True;
  FColor := RGB(FR, FG, FB);
end;

procedure TSquare.Draw(Canvas: TDirect2DCanvas);
begin
  with Canvas do
  begin
    Brush.Color := Color;
    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
    RenderTarget.SetTransform(TD2DMatrix3x2F.Rotation(Rotation, Position.Round));
    FillRect(CollisionRect.FocusRect);
    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
    TextOut(10, 10, FJumpSize.ToString);
  end;
end;

function TSquare.GetCollisonRect: TFloatRect;
begin
  Result := TFloatRect.Create(TPointF.Create(Position.X - Size.Width / 2, Position.Y - Size.Height / 2), Size.Width, Size.Height);
end;

procedure TSquare.OnCollision(Sprite: TSprite);
begin
  inherited;
  //Position.Y := Position.Y - 1;
  //Position.X := Position.X - 1;
end;

procedure TSquare.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TSquare.Update;
var Core: TD2EngineCore;
begin
  Core := TD2EngineCore(Owner);

  if OnTheGround then
  begin
    FDoJump := False;
    FJumpSize := 0;
  end;
  if ((not FDoJump) and (FSpeedDown = 0)) or (FJumpSize > 0) then
  begin
    if Core.Keys.KeyIsDown(VK_SPACE) then
    begin
      if FJumpSize < FMaxJumpSize then
      begin
        FJumpSize := FJumpSize + 0.6;
        OnTheGround := False;
        FDoJump := True;
        FSpeedDown := FSpeedDown - 0.3;
      end;
    end
    else FJumpSize := 0;
  end;
  if Core.Keys.KeyIsDown(VK_SHIFT) then
  begin
    OffCollisions := True;
  end
  else
    OffCollisions := False;
  if Core.Keys.KeyIsDown(VK_LEFT) then
  begin
    Position.X := Position.X - 3;
  end;
  if Core.Keys.KeyIsDown(VK_RIGHT) then
  begin
    Position.X := Position.X + 3;
  end;

  if FDoJump then
  begin
    Position.Y := Position.Y + FSpeedDown;
    FSpeedDown := Min(2, FSpeedDown + 0.05);
  end
  else
  begin
    inherited;
  end;

  //Rotation := Angle(Rotation + 5);
end;

{ TWheel }

constructor TWheel.Create(AOwner: TObject; ALayer: Integer; Rct: TRect; Angle: Double);
begin
  inherited Create(AOwner, ALayer);
  Position := Rct.CenterPoint;
  IsStatic := False;
  Rotation := Angle;
  Size := Rct.Size;
  FR := 100;
  FG := 100;
  FB := 100;
  FColor := RGB(FR, FG, FB);
end;

procedure TWheel.Draw(Canvas: TDirect2DCanvas);
var Rc: TRect;
begin
  with Canvas do
  begin
    Brush.Color := Color;
    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
    RenderTarget.SetTransform(TD2DMatrix3x2F.Rotation(Rotation, Position.Round));
    Ellipse(CollisionRect.FocusRect);
    Rc := CollisionRect.FocusRect;
    Rc.Inflate(-10, -10);
    Brush.Color := clWhite;
    FillRect(Rc);
    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
  end;
end;

function TWheel.GetCollisonRect: TFloatRect;
begin
  Result := TFloatRect.Create(TPointF.Create(Position.X - Size.Width / 2, Position.Y - Size.Height / 2), Size.Width, Size.Height);
end;

procedure TWheel.OnCollision(Sprite: TSprite);
begin         {
  if Sprite is TSquare then
  begin
    ToDelete := True;
  end;        }
  //Position.Y := Position.Y - 1;
  //Position.X := Position.X - 1;
end;

procedure TWheel.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TWheel.Update;
begin
  Position.X := Position.X + 1;
  Position.Y := Position.Y + 1;
  Rotation := Angle(Rotation + 1);
end;

{ TFloor }

constructor TFloor.Create(AOwner: TObject; ALayer: Integer; Height: Double);
var Core: TD2EngineCore;
begin
  inherited Create(AOwner, ALayer);
  Core := TD2EngineCore(Owner);
  Position := TPointF.Create(Core.Buffer.Width / 2, Core.Buffer.Height - Height / 2);
  IsStatic := True;
  Rotation := 0;
  Size := TSizeF.Create(Core.Buffer.Width, Height);
  FColor := clWhite;
end;

procedure TFloor.Draw(Canvas: TDirect2DCanvas);
begin
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(CollisionRect.FocusRect);
  end;
end;

function TFloor.GetCollisonRect: TFloatRect;
begin
  Result := TFloatRect.Create(TPointF.Create(Position.X - Size.Width / 2, Position.Y - Size.Height / 2), Size.Width, Size.Height);
end;

procedure TFloor.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

{ TPlatform }

constructor TPlatform.Create(AOwner: TObject; ALayer: Integer);
//var Core: TD2EngineCore;
begin
  inherited Create(AOwner, ALayer);
  //Core := TD2EngineCore(Owner);
  IsStatic := True;
  Rotation := 0;
  FColor := clWhite;
end;

procedure TPlatform.Draw(Canvas: TDirect2DCanvas);
begin
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(CollisionRect.FocusRect);
  end;
end;

function TPlatform.GetCollisonRect: TFloatRect;
begin
  Result := TFloatRect.Create(TPointF.Create(Position.X - Size.Width / 2, Position.Y - Size.Height / 2), Size.Width, Size.Height);
end;

procedure TPlatform.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

{ TWall }

constructor TWall.Create(AOwner: TObject; ALayer: Integer; Height: Double);
var Core: TD2EngineCore;
begin
  inherited Create(AOwner, ALayer);
  Core := TD2EngineCore(Owner);
  Position := TPointF.Create(Core.Buffer.Width / 2, Core.Buffer.Height - Height / 2);
  IsStatic := True;
  Rotation := 0;
  Size := TSizeF.Create(Core.Buffer.Width, Height);
  FColor := $00999999;
end;

procedure TWall.Draw(Canvas: TDirect2DCanvas);
begin
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(CollisionRect.FocusRect);
  end;
end;

function TWall.GetCollisonRect: TFloatRect;
begin
  Result := TFloatRect.Create(TPointF.Create(Position.X - Size.Width / 2, Position.Y - Size.Height / 2), Size.Width, Size.Height);
end;

procedure TWall.OnCollision(Sprite: TSprite);
begin

end;

procedure TWall.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TWall.Update;
begin

end;

end.
