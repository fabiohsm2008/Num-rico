unit abiertos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath;

type
  Tmabiertos = class
    ErrorAllowed: Real;
    par: TParseMath;
    Punto: Real;
    h: Real;
    Sequence,
    ErSequence: TStringList;
    Posible: String;
    function Newton(): Real;
    function Secante(): Real;
    function f_x(x: Real): Real;
    function f_xderivada(x: Real): Real;
    private
       Error: Real;
    public
       constructor Create;
       destructor Destroy; override;
end;

implementation
    const
      Top = 10000;
constructor Tmabiertos.Create;
begin
  Error:= Top;
  Sequence:= TStringList.Create;
  ErSequence:= TStringList.Create;
  par:= TParseMath.create();
  par.AddVariable('x', 0);
end;

destructor Tmabiertos.Destroy;
begin
  Sequence.Destroy;
  ErSequence.Destroy;
end;

function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

function Factorial( n: Integer ): Real;
begin

     if n > 1 then
        Result:= n * Factorial( n -1 )

     else if n >= 0 then
        Result:= 1

     else
        Result:= 0;

end;

function Tmabiertos.f_x(x: Real): Real;
begin
   par.NewValue('x', x);
   Result:= par.Evaluate();
end;

function Tmabiertos.f_xderivada(x: Real): Real;
var hi: Real;
begin
   hi:= ErrorAllowed/10;
   par.NewValue('x', x+hi);
   Result:= par.Evaluate();
   par.NewValue('x', x-hi);
   Result:= Result - par.Evaluate();
   Result:= Result/(2*hi);
end;

function Tmabiertos.Newton(): Real;
var Xn: Real;
    comp: Boolean;
    temp: Real;
begin
  Xn:= Punto;
  comp:= False;
  temp:= Error;
  Sequence.Add(FloatToStr(Xn));
  ErSequence.Add(' ');
  Posible:= 'Es Posible';
  if (f_x(Xn) = 0) then Result:= Xn
  else
  begin
    repeat
          if(f_xderivada(Xn) = 0) then begin
            comp:= True;
            Posible:= 'Pendiente en ' + FloatToStr(Xn) + ' es negativa';
          end
          else begin
            Result:= Xn - (f_x(Xn)/f_xderivada(Xn));
            Error:= abs(Xn - Result);
            Xn:= Result;
            Sequence.Add(FloatToStr(Xn));
            ErSequence.Add(FloatToStr(Error));
            if(temp <= Error) then begin
                  comp:= True;
                  Posible:= 'El error no decrece';
            end;
            temp:= Error;
          end;
    until (Error < ErrorAllowed) or (comp);
  end;
  Error:= Top;
end;

function Tmabiertos.Secante(): Real;
var Xn: Real;
    comp: Boolean;
    temp: Real;
begin
  h:= ErrorAllowed/10;
  Xn:= Punto;
  comp:= False;
  temp:= Error;
  Posible:= 'Es Posible';
  Sequence.Add(FloatToStr(Xn));
  ErSequence.Add(' ');
  if (f_x(Xn) = 0) then Result:= Xn
  else
  begin
      repeat
            if(f_xderivada(Xn) = 0) then begin
            comp:= True;
            Posible:= 'Pendiente en ' + FloatToStr(Xn) + ' es negativa';
            end
            else begin
              Result:= Xn - ((2*h*f_x(Xn))/( f_x(Xn+h) - f_x(Xn-h) ));
              Error:= abs(Xn - Result);
              Xn:= Result;
              Sequence.Add(FloatToStr(Xn));
              ErSequence.Add(FloatToStr(Error));
              if(temp <= Error) then begin
                  comp:= True;
                  Posible:= 'El error no decrece';
              end;
              temp:= Error;
            end;
      until (Error < ErrorAllowed) or (comp);
  end;
  Error:= Top;
end;

end.

