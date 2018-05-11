unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Grids, ExtCtrls, ComCtrls, abiertos, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnGraph: TButton;
    btnNewton: TButton;
    btnSecante: TButton;
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsFuncSeries2: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    ediEr: TEdit;
    edifuncion: TEdit;
    ediX: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblposible: TLabel;
    lbler: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    trbMax: TTrackBar;
    trbMin: TTrackBar;
    procedure btnGraphClick(Sender: TObject);
    procedure btnNewtonClick(Sender: TObject);
    procedure btnSecanteClick(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure FormCreate(Sender: TObject);
    procedure trbMaxChange(Sender: TObject);
    procedure trbMinChange(Sender: TObject);
  private
    Abiertos : Tmabiertos;
    Parse: TParseMath;
  public

  end;

var
  Form1: TForm1;

implementation
const
     ColN = 0;
     ColSequence = 1;
     ColError = 2;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
  Abiertos:= Tmabiertos.Create;
  Abiertos.ErrorAllowed:= StrToFloat(ediEr.Text);
  Parse:= TParseMath.create();
  Parse.AddVariable('x', 0);
end;

procedure TForm1.btnGraphClick(Sender: TObject);
begin
  Parse.Expression:= edifuncion.Text;
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries1.Active:= True;
end;

procedure TForm1.btnNewtonClick(Sender: TObject);
  procedure FillStringGrid;
      var i: Integer;
      begin

        with StringGrid1 do
        for i:= 1 to RowCount - 1 do begin
            Cells[ ColN, i ]:= IntToStr( i );
        end;

      end;

var res: Real;

begin
    Parse.Expression:= edifuncion.Text;
    chartGraphicsLineSeries1.Clear;
    Abiertos.par:= Parse;
    Abiertos.Punto:= StrToFloat(ediX.text);
    res:= Abiertos.Newton();
    Memo1.Lines.Add('Usando Newton: ' + FloatToStr(res));
    with StringGrid1 do begin
      RowCount:= Abiertos.Sequence.Count;
      Cols[ ColSequence ].Assign( Abiertos.Sequence );
      Cols[ ColError ].Assign(Abiertos.ErSequence);
  end;
  FillStringGrid;
  Abiertos.Sequence.Clear;
  Abiertos.ErSequence.Clear;
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  chartGraphicsLineSeries1.AddXY( res, 0 );
  lblposible.Caption:= Abiertos.Posible;

end;

procedure TForm1.btnSecanteClick(Sender: TObject);
  procedure FillStringGrid;
        var i: Integer;
        begin

          with StringGrid1 do
          for i:= 1 to RowCount - 1 do begin
              Cells[ ColN, i ]:= IntToStr( i );
          end;

        end;

var res: Real;

begin
    Parse.Expression:= edifuncion.Text;
    chartGraphicsLineSeries1.Clear;
    Abiertos.par:= Parse;
    Abiertos.Punto:= StrToFloat(ediX.text);
    res:= Abiertos.Secante();
    Memo1.Lines.Add('Usando Secante: ' + FloatToStr(res));
    with StringGrid1 do begin
      RowCount:= Abiertos.Sequence.Count;
      Cols[ ColSequence ].Assign( Abiertos.Sequence );
      Cols[ ColError ].Assign(Abiertos.ErSequence);
  end;
  FillStringGrid;
  Abiertos.Sequence.Clear;
  Abiertos.ErSequence.Clear;
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  chartGraphicsLineSeries1.AddXY( res, 0 );
  lblposible.Caption:= Abiertos.Posible;
end;

procedure TForm1.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  Parse.NewValue('x',AX);
  AY:= Parse.Evaluate();
end;

procedure TForm1.trbMaxChange(Sender: TObject);
begin
  chartGraphics.Extent.XMax:= trbMax.Position;
end;

procedure TForm1.trbMinChange(Sender: TObject);
begin
  chartGraphics.Extent.XMin:= trbMin.Position;
end;

end.

