unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    img1: TImage;
    img2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure DrawAlpha(bmpBack, bmpFore : TBitmap; TransColor : TColor; OffX, OffY : Integer; Alpha : Integer);

type
  TRGBArray = array[0..32767] of TRGBTriple;
  PRGBArray = ^TRGBArray;

var
  X, Y     : Integer;
  rowFore,
  rowBack  : PRGBArray;

begin
  // check bitmaps
  if not Assigned(bmpBack) or
     not Assigned(bmpFore) then
   Exit;

  // check color depth
  if (bmpFore.PixelFormat <> pf24bit) or
     (bmpBack.PixelFormat <> pf24bit) then
   Exit;

  // check dimensions
  if (bmpFore.Height + OffY > bmpBack.Height) or
     (bmpFore.Width + OffX > bmpBack.Width) then
    Exit;

  // check alpha value
  if (Alpha > 10) or
     (Alpha < 1) then
    Alpha := 10;

  for y := 0 to bmpFore.Height - 1 do
  begin
    // scan bitmap rows
    rowBack := bmpBack.ScanLine[y + OffY];
    rowFore := bmpFore.ScanLine[y];
    for x := 0 to bmpFore.Width - 1 do
    // if not transparent color
    if not ((rowFore[x].rgbtRed   = GetRValue(TransColor)) and
            (rowFore[x].rgbtGreen = GetGValue(TransColor)) and
            (rowFore[x].rgbtBlue  = GetBValue(TransColor))) then
    // calculate new pixel value
    begin
      rowBack[x + OffX].rgbtRed   := ((rowBack[x + OffX].rgbtRed * (10 - Alpha))   + (rowFore[x].rgbtRed * Alpha))   div 10;
      rowBack[x + OffX].rgbtGreen := ((rowBack[x + OffX].rgbtGreen) * (10 - Alpha) + (rowFore[x].rgbtGreen * Alpha)) div 10;
      rowBack[x + OffX].rgbtBlue  := ((rowBack[x + OffX].rgbtBlue) * (10 - Alpha)  + (rowFore[x].rgbtBlue * Alpha))  div 10;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // set color depth to 16.7mio colors (24 bit)
  // because the loaded bitmaps are 8 bit
  img1.Picture.Bitmap.PixelFormat := pf24bit;
  img2.Picture.Bitmap.PixelFormat := pf24bit;

  DrawAlpha(img1.Picture.Bitmap, img2.Picture.Bitmap, clFuchsia, 10, 10, 5);

  // update image1 (result)
  img1.Invalidate;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
