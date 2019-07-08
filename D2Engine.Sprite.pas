unit D2Engine.Sprite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Classes;

type
  TSprite = class
    FLayer: Integer;
    FPosition: TPointF;
    FSize: TSizeF;
    FIsStatic: Boolean;
    FRotation: Double;
    //
    function GetCollisonRect: TFloatRect; virtual; abstract;
    //
    procedure SetLayer(const Value: Integer); virtual;
    procedure SetIsStatic(const Value: Boolean); virtual;
  public
    //
    constructor Create(ALayer: Integer); virtual;
    procedure Draw(Canvas: TDirect2DCanvas); virtual; abstract;
    procedure Update; virtual; abstract;
    procedure OnCollision(Sprite: TSprite); virtual; abstract;
    //
    property Layer:Integer read FLayer write SetLayer;
    property IsStatic: Boolean read FIsStatic write SetIsStatic;
    property CollisionRect: TFloatRect read GetCollisonRect;
  end;

  TSprites = class(TList<TSprite>)
    procedure Clear;
  end;

implementation

{ TSprites }

procedure TSprites.Clear;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Items[i].Free;
  end;
  inherited Clear;
end;

{ TSprite }

constructor TSprite.Create(ALayer: Integer);
begin
  inherited Create;
  FLayer := ALayer;
  FRotation := 0;
  FIsStatic := True;
end;

procedure TSprite.SetIsStatic(const Value: Boolean);
begin
  FIsStatic := Value;
end;

procedure TSprite.SetLayer(const Value: Integer);
begin
  FLayer := Value;
end;

end.
