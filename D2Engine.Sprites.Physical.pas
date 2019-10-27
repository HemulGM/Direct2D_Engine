unit D2Engine.Sprites.Physical;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Sprite, D2Engine.Classes;

type
  TBlockDirect = (bdLeft, bdTop, bdRight, bdBottom);
  TBlocks = set of TBlockDirect;

  TPhysicalSprite = class(TSprite)
    FSpeedDown: Double;
  private
    FOffCollisions: Boolean;
    FBlocks: TBlocks;
    procedure SetOffCollisions(const Value: Boolean);
    procedure SetBlocks(const Value: TBlocks);
  public
    procedure Update; override;
    procedure OnCollision(Sprite: TSprite); override;
    procedure AfterCollisionCheck; override;
    constructor Create(AOwner: TObject; ALayer: Integer); override;
    property OffCollisions: Boolean read FOffCollisions write SetOffCollisions;
    property Blocks: TBlocks read FBlocks write SetBlocks;
  end;

implementation

uses
  Math, D2Engine.Simples;

{ TPhysicalSprite }

procedure TPhysicalSprite.AfterCollisionCheck;
begin
  inherited;
  Blocks := [];
end;

constructor TPhysicalSprite.Create(AOwner: TObject; ALayer: Integer);
begin
  inherited Create(AOwner, ALayer);
  FSpeedDown := 0;
  FOffCollisions := False;
  OnTheGround := False;
  FBlocks := [];
end;

procedure TPhysicalSprite.OnCollision(Sprite: TSprite);
begin
  if FOffCollisions then Exit;

  if Sprite is TWall then
  begin
    //Sprite.GetCollisonRect.
    Exit;
  end;

  if Sprite is TFloor then
  begin
    OnTheGround := True;
    Include(FBlocks, bdBottom);
    FSpeedDown := 0;
    //Ставим ровно на спрайт
    Position.Y := TFloor(Sprite).GetCollisonRect.LT.Y - (Size.Height / 2);
    Exit;
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
        Include(FBlocks, bdBottom);
        begin
          FSpeedDown := 0;
          //Ставим ровно на спрайт
          Position.Y := TFloor(Sprite).GetCollisonRect.LT.Y - (Size.Height / 2);
        end;
      end;
    end;
    Exit;
  end;
end;

procedure TPhysicalSprite.SetBlocks(const Value: TBlocks);
begin
  FBlocks := Value;
end;

procedure TPhysicalSprite.SetOffCollisions(const Value: Boolean);
begin
  FOffCollisions := Value;
end;

procedure TPhysicalSprite.Update;
begin
  Position.Y := Position.Y + FSpeedDown;
  FSpeedDown := Min(2, FSpeedDown + 0.2);
end;

end.
