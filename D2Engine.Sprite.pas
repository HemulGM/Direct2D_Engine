unit D2Engine.Sprite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Classes;

type
  TSprite = class
    FLayer: Integer;
    Position: TPointF;
    Size: TSizeF;
    FIsStatic: Boolean;
    Rotation: Double;
    ToDelete: Boolean;
    //
    function GetCollisonRect: TFloatRect; virtual; abstract;
    //
    procedure SetLayer(const Value: Integer); virtual;
    procedure SetIsStatic(const Value: Boolean); virtual;
  private
    FOnTheGround: Boolean;
    FOwner: TObject;
    procedure SetOwner(const Value: TObject);
  public
    //
    constructor Create(AOwner: TObject; ALayer: Integer); virtual;
    procedure Draw(Canvas: TDirect2DCanvas); virtual; abstract;
    procedure Update; virtual; abstract;
    procedure OnCollision(Sprite: TSprite); virtual; abstract;
    procedure OnOutOfWorld(Direct: TWorldDirection; NewPosition: TPointF; var Handled: Boolean); virtual;
    //
    property CollisionRect: TFloatRect read GetCollisonRect;

    property Layer:Integer read FLayer write SetLayer;
    property IsStatic: Boolean read FIsStatic write SetIsStatic;

    property OnTheGround: Boolean read FOnTheGround write FOnTheGround;
    property Owner: TObject read FOwner write SetOwner;
  end;

implementation

{ TSprite }

constructor TSprite.Create(AOwner: TObject; ALayer: Integer);
begin
  inherited Create;
  FOwner := AOwner;
  FOnTheGround := False;
  FLayer := ALayer;
  Rotation := 0;
  FIsStatic := True;
end;

procedure TSprite.OnOutOfWorld(Direct: TWorldDirection; NewPosition: TPointF;
  var Handled: Boolean);
begin
  Handled := False;
end;

procedure TSprite.SetIsStatic(const Value: Boolean);
begin
  FIsStatic := Value;
end;

procedure TSprite.SetLayer(const Value: Integer);
begin
  FLayer := Value;
end;

procedure TSprite.SetOwner(const Value: TObject);
begin
  FOwner := Value;
end;

end.
