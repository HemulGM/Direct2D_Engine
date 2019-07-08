unit D2Engine.Simples;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Sprite, D2Engine.Classes;

type
  TSquare = class(TSprite)
    function GetCollisonRect: TFloatRect; override;
  private
    FColor: TColor;
    FR, FG, FB: Byte;
    procedure SetColor(const Value: TColor);
  public
    procedure Draw(Canvas: TDirect2DCanvas); override;
    procedure Update; override;
    procedure OnCollision(Sprite: TSprite); override;
    constructor Create(ALayer: Integer; Rct: TRect; Angle: Double); virtual;
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
    constructor Create(ALayer: Integer; Rct: TRect; Angle: Double); virtual;
    property Color: TColor read FColor write SetColor;
  end;

implementation

{ TSquare }

constructor TSquare.Create(ALayer: Integer; Rct: TRect; Angle: Double);
begin
  inherited Create(ALayer);
  FPosition := Rct.CenterPoint;
  FIsStatic := False;
  FRotation := Angle;
  FSize := Rct.Size;
  FR := 255;
  FG := 0;
  FB := 0;
  FColor := RGB(FR, FG, FB);
end;

procedure TSquare.Draw(Canvas: TDirect2DCanvas);
begin
  with Canvas do
  begin
    Brush.Color := Color;
    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
    RenderTarget.SetTransform(TD2DMatrix3x2F.Rotation(FRotation, FPosition.Round));
    FillRect(CollisionRect.FocusRect);
    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
  end;
end;

function TSquare.GetCollisonRect: TFloatRect;
begin
  Result := TFloatRect.Create(TPoint.Create(Round(FPosition.X - FSize.Width / 2), Round(FPosition.Y - FSize.Height / 2)), FSize.Width, FSize.Height);
end;

procedure TSquare.OnCollision(Sprite: TSprite);
begin
  FPosition.Y := FPosition.Y - 1;
  FPosition.X := FPosition.X - 1;
end;

procedure TSquare.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TSquare.Update;
begin
  FPosition.X := FPosition.X + 1;
  FRotation := Angle(FRotation + 5);
end;

{ TWheel }

constructor TWheel.Create(ALayer: Integer; Rct: TRect; Angle: Double);
begin
  inherited Create(ALayer);
  FPosition := Rct.CenterPoint;
  FIsStatic := False;
  FRotation := Angle;
  FSize := Rct.Size;
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
    RenderTarget.SetTransform(TD2DMatrix3x2F.Rotation(FRotation, FPosition.Round));
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
  Result := TFloatRect.Create(TPoint.Create(Round(FPosition.X - FSize.Width / 2), Round(FPosition.Y - FSize.Height / 2)), FSize.Width, FSize.Height);
end;

procedure TWheel.OnCollision(Sprite: TSprite);
begin
  FPosition.Y := FPosition.Y - 1;
  FPosition.X := FPosition.X - 1;
end;

procedure TWheel.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TWheel.Update;
begin
  FPosition.X := FPosition.X + 1;
  FPosition.Y := FPosition.Y + 1;
  FRotation := Angle(FRotation + 5);
end;

end.
