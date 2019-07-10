unit D2Engine.Core;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, System.Generics.Collections, D2Engine.Layers, D2Engine.Simples,
  D2Engine.Moving, D2Engine.Classes, D2Engine.Sprites, D2Engine.Sprite;

type
  TD2EngineCore = class;

  TKeys = class

  public
    function KeyIsDown(Key: Word): Boolean;
    constructor Create(AOwner: TD2EngineCore);
  end;

  TD2EngineCore = class
  private
    FBuffer: TBitmap;
    FLayers: TLayers;
    FSprites: TSprites;
    FMoving: TMovingThread;
    FLoopedWorld: Boolean;
    FKeys: TKeys;
    procedure FPaint(ACanvas: TDirect2DCanvas);
    procedure SetBuffer(const Value: TBitmap);
    function GetBuffer: TBitmap;
    function CollisionLine(LA1, LB1, LA2, LB2: TPointF): Boolean;
    procedure SetLoopedWorld(const Value: Boolean);
    procedure SetSprites(const Value: TSprites);
    procedure SetKeys(const Value: TKeys);
  public
    function CollisionFloatRect(S1, S2: TSprite): Boolean;
    procedure Resize(Width, Height: Integer); virtual;
    procedure Paint; virtual;
    procedure Update; virtual;
    procedure Run; virtual;
    procedure CreateTest;
    constructor Create(VideoWidth, VideoHeight: Integer); virtual;
    destructor Destroy; override;
    property Buffer: TBitmap read GetBuffer write SetBuffer;
    property Sprites: TSprites read FSprites write SetSprites;
    property LoopedWorld: Boolean read FLoopedWorld write SetLoopedWorld;       //Если предмет выходит за границы мира, он появляется с другой его стороны
    property Keys: TKeys read FKeys write SetKeys;
  end;

implementation

{ TD2EngineCore }

function TD2EngineCore.CollisionLine(LA1, LB1, LA2, LB2: TPointF): Boolean;
var
  v1, v2, v3, v4: Double;
begin
  v1 := (LB2.X - LA2.X) * (LA1.Y - LA2.Y) - (LB2.Y - LA2.Y) * (LA1.X - LA2.X);
  v2 := (LB2.X - LA2.X) * (LB1.Y - LA2.Y) - (LB2.Y - LA2.Y) * (LB1.X - LA2.X);
  v3 := (LB1.X - LA1.X) * (LA2.Y - LA1.Y) - (LB1.Y - LA1.Y) * (LA2.X - LA1.X);
  v4 := (LB1.X - LA1.X) * (LB2.Y - LA1.Y) - (LB1.Y - LA1.Y) * (LB2.X - LA1.X);
  Result := (v1 * v2 < 0) and (v3 * v4 < 0);
end;

function TD2EngineCore.CollisionFloatRect(S1, S2: TSprite): Boolean;
var R1, R2: TFloatRect;
begin
  R1 := S1.GetCollisonRect;
  R2 := S2.GetCollisonRect;
  Result := CollisionLine(R1.LT, R1.LB, R2.LT, R2.LB) or
            CollisionLine(R1.LT, R1.LB, R2.LT, R2.RT) or
            CollisionLine(R1.LT, R1.LB, R2.RT, R2.RB) or
            CollisionLine(R1.LT, R1.LB, R2.RB, R2.LB) or

            CollisionLine(R1.LT, R1.RT, R2.LT, R2.LB) or
            CollisionLine(R1.LT, R1.RT, R2.LT, R2.RT) or
            CollisionLine(R1.LT, R1.RT, R2.RT, R2.RB) or
            CollisionLine(R1.LT, R1.RT, R2.RB, R2.LB) or

            CollisionLine(R1.RT, R1.RB, R2.LT, R2.LB) or
            CollisionLine(R1.RT, R1.RB, R2.LT, R2.RT) or
            CollisionLine(R1.RT, R1.RB, R2.RT, R2.RB) or
            CollisionLine(R1.RT, R1.RB, R2.RB, R2.LB) or

            CollisionLine(R1.RB, R1.LB, R2.LT, R2.LB) or
            CollisionLine(R1.RB, R1.LB, R2.LT, R2.RT) or
            CollisionLine(R1.RB, R1.LB, R2.RT, R2.RB) or
            CollisionLine(R1.RB, R1.LB, R2.RB, R2.LB);

end;

constructor TD2EngineCore.Create(VideoWidth, VideoHeight: Integer);
begin
  inherited Create;
  FLayers := TLayers.Create;
  FLayers.Add('default');
  FSprites := TSprites.Create;
  //
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf24bit;
  FBuffer.SetSize(VideoWidth, VideoHeight);

  FMoving := TMovingThread.Create;
  FMoving.ExecMethod := Update;

  FKeys := TKeys.Create(Self);
end;

procedure TD2EngineCore.CreateTest;
var
  i: Integer;
begin
  //FSprites.Add(TFloor.Create(Self, 0, 20));
  FLayers.Add('1');
  FLayers.Add('2');

  with FSprites[FSprites.Add(TPlatform.Create(Self, 1))] do
  begin
    Size.Width := 100;
    Size.Height := 20;
    Position.X := 100;
    Position.Y := FBuffer.Height - 100;
  end;

  with FSprites[FSprites.Add(TPlatform.Create(Self, 1))] do
  begin
    Size.Width := FBuffer.Width div 3;
    Size.Height := 20;
    Position.X := 0 + Size.Width / 2;
    Position.Y := FBuffer.Height - Size.Height;
  end;

  with FSprites[FSprites.Add(TPlatform.Create(Self, 1))] do
  begin
    Size.Width := FBuffer.Width div 3;
    Size.Height := 20;
    Position.X := 0 + Size.Width / 2 * 4;
    Position.Y := FBuffer.Height - Size.Height;
  end;

  FSprites.Add(TSquare.Create(Self, 2, Rect(100, 100, 150, 150), 0));
         {
  FSprites.Add(TWheel.Create(Self, 0, TRect.Create(Point(10, 10), 40, 40), 0));
  for i := 0 to 100 do
  begin
    FSprites.Add(TWheel.Create(Self, 0, TRect.Create(Point(Random(700), Random(500)), 40, 40), 0));
  end;     }
end;

destructor TD2EngineCore.Destroy;
begin
  FMoving.Stop;
  while not FMoving.Finished do Sleep(100);
  FMoving.Free;
  FLayers.Free;
  FSprites.Clear;
  FSprites.Free;
  FBuffer.Free;
  FKeys.Free;
  inherited;
end;

procedure TD2EngineCore.FPaint(ACanvas: TDirect2DCanvas);
var
  l, s: Integer;
begin
  with ACanvas do
  begin
    Brush.Color := clBlack;
    FillRect(Rect(0, 0, FBuffer.Width, FBuffer.Height));
    {Brush.Color := clRed;
    Rectangle(10, 10, 50, 50);  }

    for l := 0 to FLayers.Count-1 do
    begin
      for s := 0 to FSprites.Count-1 do
      begin
        if FSprites[s].Layer = l then
        begin
          FSprites[s].Draw(ACanvas);
        end;
      end;
    end;
  end;
end;

function TD2EngineCore.GetBuffer: TBitmap;
begin
  Paint;
  Result := FBuffer;
end;

procedure TD2EngineCore.Paint;
var Cnv: TDirect2DCanvas;
begin
  Cnv := TDirect2DCanvas.Create(FBuffer.Canvas, Rect(0, 0, FBuffer.Width, FBuffer.Height));
  with Cnv do
  begin
    BeginDraw;
    try
      FPaint(Cnv);
    finally
      EndDraw;
      Free;
    end;
  end;
end;

procedure TD2EngineCore.Resize(Width, Height: Integer);
begin
  FBuffer.SetSize(Width, Height);
end;

procedure TD2EngineCore.Run;
begin
  FMoving.Start;
end;

procedure TD2EngineCore.SetBuffer(const Value: TBitmap);
begin
  FBuffer := Value;
end;

procedure TD2EngineCore.SetKeys(const Value: TKeys);
begin
  FKeys := Value;
end;

procedure TD2EngineCore.SetLoopedWorld(const Value: Boolean);
begin
  FLoopedWorld := Value;
end;

procedure TD2EngineCore.SetSprites(const Value: TSprites);
begin
  FSprites := Value;
end;

procedure TD2EngineCore.Update;
var
  s, i: Integer;
  Sprite: TSprite;
  NPos: TPointF;
  HandledNewPos: Boolean;
begin
  //Коллизии
  for s := 0 to Sprites.Count-1 do
  begin
    if not Sprites[s].IsStatic then
    begin
      for i := 0 to Sprites.Count-1 do
        if CollisionFloatRect(Sprites[s], Sprites[i]) then
        begin
          Sprites[s].OnCollision(Sprites[i]);
          Sprites[i].OnCollision(Sprites[s]);
        end;
    end;
  end;
  //Движение
  for s := 0 to Sprites.Count-1 do
  begin
    if not Sprites[s].IsStatic then
    begin
      Sprite := Sprites[s];
      Sprite.Update;

      if FLoopedWorld then
      begin
        //Правый край
        if (Sprite.Position.X - Sprite.Size.Width / 2) > FBuffer.Width then
        begin
          NPos := Sprite.Position;
          NPos.X := -Sprite.Size.Width / 2;

          HandledNewPos := False;
          Sprite.OnOutOfWorld(wdRight, NPos, HandledNewPos);
          if not HandledNewPos then
            Sprite.Position := NPos;
        end;
        //Нижний край
        if (Sprite.Position.Y - Sprite.Size.Height / 2) > FBuffer.Height then
        begin
          NPos := Sprite.Position;
          NPos.Y := -Sprite.Size.Height / 2;

          HandledNewPos := False;
          Sprite.OnOutOfWorld(wdBottom, NPos, HandledNewPos);
          if not HandledNewPos then
            Sprite.Position := NPos;
        end;
        //Левый край
        if (Sprite.Position.X + Sprite.Size.Width / 2) < 0 then
        begin
          NPos := Sprite.Position;
          NPos.X := FBuffer.Width + Sprite.Size.Width / 2;

          HandledNewPos := False;
          Sprite.OnOutOfWorld(wdLeft, NPos, HandledNewPos);
          if not HandledNewPos then
            Sprite.Position := NPos;
        end;
        //Верхний край
        if (Sprite.Position.Y + Sprite.Size.Height / 2) < 0 then
        begin
          NPos := Sprite.Position;
          NPos.Y := FBuffer.Height + Sprite.Size.Height / 2;

          HandledNewPos := False;
          Sprite.OnOutOfWorld(wdTop, NPos, HandledNewPos);
          if not HandledNewPos then
            Sprite.Position := NPos;
        end;
      end;
    end;
  end;
  //Удаление спрайтов отмеченных "на удаление"
  //Нельзя удалять спрайты в любом другом месте!
  s := 0;
  while (Sprites.Count > 0) and (s < Sprites.Count) do
  begin
    if Sprites[s].ToDelete then
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          Sprites.Delete(s);
        end);
      Continue;
    end;
    Inc(s);
  end;
end;

{ TKeys }

constructor TKeys.Create(AOwner: TD2EngineCore);
begin

end;

function TKeys.KeyIsDown(Key: Word): Boolean;
begin
  Result := GetAsyncKeyState(Key) < 0;
end;

end.

