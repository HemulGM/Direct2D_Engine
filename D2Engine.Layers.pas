unit D2Engine.Layers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections;

type
  TLayer = record
   Name: string;
  end;

  TLayers = class(TList<TLayer>)
    function Add(AName: string): Integer; overload;
  end;


implementation

{ TLayers }

function TLayers.Add(AName: string): Integer;
var Item: TLayer;
begin
  Item.Name := AName;
  Result := inherited Add(Item);
end;

end.
