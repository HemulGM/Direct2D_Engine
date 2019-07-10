unit D2Engine.Classes;

interface
  uses System.Types;

type
  TFloatRect = record
    LT: TPointF;
    LB: TPointF;
    RT: TPointF;
    RB: TPointF;
  public
    constructor Create(Rect: TRect); overload;
    constructor Create(ALT, ALB, ART, ARB: TPointF); overload;
    constructor Create(const Origin: TPointF; Width, Height: Double); overload;
    function FocusRect: TRect;

    class operator Implicit(const Rect: TRect): TFloatRect;
  end;

  TWorldDirection = (wdLeft, wdTop, wdRight, wdBottom);

  function Angle(Value: Double): Double;

implementation


function Angle(Value: Double): Double;
begin
  while Value < -360 do Value := Value + 360;
  while Value > 360 do Value := Value - 360;
  if Value = 360 then Value := 0;
  Result := Value;
end;

{ TFloatRect }

constructor TFloatRect.Create(Rect: TRect);
begin
  LT := TPointF.Create(Rect.Left, Rect.Top);
  LB := TPointF.Create(Rect.Left, Rect.Bottom);
  RT := TPointF.Create(Rect.Right, Rect.Top);
  RB := TPointF.Create(Rect.Right, Rect.Bottom);
end;

constructor TFloatRect.Create(ALT, ALB, ART, ARB: TPointF);
begin
  LT := ALT;
  LB := ALB;
  RT := ART;
  RB := ARB;
end;

constructor TFloatRect.Create(const Origin: TPointF; Width, Height: Double);
begin
  LT := Origin;
  LB := TPointF.Create(Origin.X, Origin.Y + Height);
  RT := TPointF.Create(Origin.X + Width, Origin.Y);
  RB := TPointF.Create(Origin.X + Width, Origin.Y + Height);
end;

function TFloatRect.FocusRect: TRect;
begin
  Result.Left := Round(LT.X);
  Result.Top := Round(LT.Y);
  Result.Right := Round(RB.X);
  Result.Bottom := Round(RB.Y);
end;

class operator TFloatRect.Implicit(const Rect: TRect): TFloatRect;
begin
  Result.LT := TPointF.Create(Rect.Left, Rect.Top);
  Result.LB := TPointF.Create(Rect.Left, Rect.Bottom);
  Result.RT := TPointF.Create(Rect.Right, Rect.Top);
  Result.RB := TPointF.Create(Rect.Right, Rect.Bottom);
end;

end.
