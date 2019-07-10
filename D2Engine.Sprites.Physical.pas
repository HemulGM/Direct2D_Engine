unit D2Engine.Sprites.Physical;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Sprite, D2Engine.Classes;

type
  TPhysicalSprite = class(TSprite)
    FSpeedDown: Double;
  private
    FOffCollisions: Boolean;
    procedure SetOffCollisions(const Value: Boolean);
  public
    procedure Update; override;
    procedure OnCollision(Sprite: TSprite); override;
    constructor Create(AOwner: TObject; ALayer: Integer); override;
    property OffCollisions: Boolean read FOffCollisions write SetOffCollisions;
  end;

implementation

uses
  Math, D2Engine.Simples;

{ TPhysicalSprite }

constructor TPhysicalSprite.Create(AOwner: TObject; ALayer: Integer);
begin
  inherited Create(AOwner, ALayer);
  FSpeedDown := 0;
  FOffCollisions := False;
  OnTheGround := False;
end;

procedure TPhysicalSprite.OnCollision(Sprite: TSprite);
begin
  if FOffCollisions then Exit;
  if Sprite is TFloor then
  begin
    OnTheGround := True;
    FSpeedDown := 0;
    //Ставим ровно на спрайт
    Position.Y := TFloor(Sprite).GetCollisonRect.LT.Y - (Size.Height / 2);
  end;

  if Sprite is TPlatform then
  begin
    //Если мы движемся вниз
    if FSpeedDown >= 0 then
    begin
      //И если расстояние уже меньше 5
      if Abs(GetCollisonRect.FocusRect.Bottom - Sprite.GetCollisonRect.LT.Y) <= 5 then
      begin
        OnTheGround := True;
        begin
          FSpeedDown := 0;
          //Ставим ровно на спрайт
          Position.Y := TFloor(Sprite).GetCollisonRect.LT.Y - (Size.Height / 2);
        end;
      end;
    end;
  end;
end;

procedure TPhysicalSprite.SetOffCollisions(const Value: Boolean);
begin
  FOffCollisions := Value;
end;

procedure TPhysicalSprite.Update;
begin
  Position.Y := Position.Y + FSpeedDown;
  FSpeedDown := Min(2, FSpeedDown + 0.05);
end;

end.
