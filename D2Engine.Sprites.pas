unit D2Engine.Sprites;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Sprite, D2Engine.Layers,
  D2Engine.Moving, D2Engine.Classes;

type
  TSprites = class(TList<TSprite>)
    procedure Clear;
    procedure Delete(Index: Integer);
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

procedure TSprites.Delete(Index: Integer);
begin
  Items[Index].Free;
  inherited;
end;

end.
