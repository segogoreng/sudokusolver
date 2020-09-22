unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  Tsml = record
    x,y   : integer;
    angka : integer;
  end;
  Tcell = record
    x,y      : integer;
    angka    : integer;
    warnatls : TColor;
    warnadrh : TColor;
    sml      : array[1..9] of Tsml;
  end;
  Tktk = record
    x,y : integer;
  end;
  TForm1 = class(TForm)
    Image: TImage;
    GroupBox1: TGroupBox;
    InitButton: TButton;
    StartButton: TButton;
    NextButton: TButton;
    StopButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    iteration: TLabel;
    solution: TLabel;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    LoadButton: TButton;
    SaveButton: TButton;
    ExitButton: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MiniMap: TImage;
    Timer1: TTimer;
    procedure Line(x1,y1,x2,y2 : integer);
    procedure GambarCell(cell : Tcell;angka : integer);
    procedure GambarSml(sml : Tsml;angka : integer;warna : TColor);
    procedure GambarKtk(ktk : Tktk; warna : tcolor);
    procedure IsiCell(y,x,index : integer);
    procedure IsiSml(y,x,index : integer);
    procedure HapusCell(y,x : integer);
    procedure KlikSml(y,x,index : integer);
    procedure KlikCell(y,x : integer);
    procedure CariGray(LV : integer);
    procedure HapusMap(LV : integer);
    procedure GambarPapan;
    procedure GambarMap;
    procedure InitPapan;
    procedure InitMap;
    procedure BackTracking(LV : integer;var sukses : boolean);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure InitButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  cellsize = 60;
  smlsize  = 20;
  ktksize  = 4;

var
  Form1   : TForm1;
  p       : array [1..9,1..9] of Tcell;
  map     : array [1..82,0..9] of Tktk;
  x,y,c   : integer;
  sukses  : Boolean;
  JumlLv  : integer;
  loncat  : boolean;
  itr,slt : integer;

implementation

{$R *.dfm}

procedure TForm1.Line(x1, y1, x2, y2: integer);
begin
  Image.Canvas.MoveTo(x1,y1);
  Image.Canvas.LineTo(x2,y2);
end;

procedure TForm1.GambarCell(cell: Tcell;angka : integer);
begin
  Image.Canvas.Font.Size  := 30;
  Image.Canvas.Brush.Style := bsClear;
  Image.Canvas.Rectangle(cell.x,cell.y,cell.x+cellsize,cell.y+cellsize);
  if angka<>0 then
  begin
    Image.Canvas.Brush.Style := bsSolid;
    Image.Canvas.Brush.Color := cell.warnadrh;
    Image.Canvas.Rectangle(cell.x,cell.y,cell.x+cellsize,cell.y+cellsize);
    Image.Canvas.Font.Color := cell.warnatls;
    Image.Canvas.TextOut(cell.x+17,cell.y+2,inttostr(angka));
    Image.Canvas.Font.Color := clBlack;
    Image.Canvas.Brush.Color := clWhite;
  end;
end;

procedure TForm1.GambarSml(sml: Tsml;angka : integer;warna : TColor);
begin
  Image.Canvas.Brush.Style := bsSolid;
  Image.Canvas.Brush.Color := warna;
  Image.Canvas.Rectangle(sml.x,sml.y,sml.x+smlsize+1,sml.y+smlsize+1);
  Image.Canvas.Font.Size:=8;
  if angka<>0 then
    Image.Canvas.TextOut(sml.x+7,sml.y+1,inttostr(angka));
  Image.Canvas.Brush.Color := clWhite;
end;

procedure TForm1.GambarKtk(ktk: Tktk; warna : TColor);
begin
  MiniMap.Canvas.Brush.Style := bsSolid;
  MiniMap.Canvas.Brush.Color := warna;
  MiniMap.Canvas.Rectangle(ktk.x,ktk.y,ktk.x+ktksize+1,ktk.y+ktksize+1);
end;

procedure TForm1.GambarPapan;
var
  i,j,k : integer;
begin
  for i:=1 to 9 do
    for j:=1 to 9 do
    begin
      for k:=1 to 9 do
        GambarSml(p[i,j].sml[k],p[i,j].sml[k].angka,p[i,j].warnadrh);
      GambarCell(p[i,j],p[i,j].angka);
    end;
end;

procedure TForm1.GambarMap;
var
  i,j : integer;
begin
  MiniMap.Canvas.Brush.Style := bsSolid;
  MiniMap.Canvas.Brush.Color := clWhite;
  MiniMap.Canvas.Rectangle(0,0,MiniMap.Width,MiniMap.Height);
  for i:=1 to JumlLv do
    for j:=0 to 9 do
    begin
      GambarKtk(map[i,j],clWhite);
    end;
end;

procedure TForm1.IsiCell(y, x, index: integer);
var
  i,j : integer;
begin
  p[y,x].angka := index;
  for i:=1 to 9 do
  begin
    p[y,i].sml[index].angka := 0;
    p[i,x].sml[index].angka := 0;
  end;
  for i:=1 to 9 do
    for j:=1 to 9 do
    begin
      if p[i,j].warnadrh=p[y,x].warnadrh then
        p[i,j].sml[index].angka := 0;
    end;
end;

procedure TForm1.IsiSml(y, x, index: integer);
var
  i,j   : integer;
  valid : boolean;
begin
  valid := true;
  for i:= 1 to 9 do
  begin
    if (p[y,i].angka=index) then valid:=false;
    if (p[i,x].angka=index) then valid:=false;
  end;
  for i:= 1 to 9 do
    for j := 1 to 9 do
    if  (p[i,j].warnadrh=p[y,x].warnadrh) and (p[i,j].angka=index) then
      valid:=false;
  if valid then p[y,x].sml[index].angka := index;
end;


procedure TForm1.HapusCell(y,x : integer);
var
  i,j,temp : integer;
begin
  temp := p[y,x].angka;
  p[y,x].angka :=0;
  for i:=1 to 9 do
  begin
    IsiSml(y,i,temp);
    IsiSml(i,x,temp);
  end;
  for i:=1 to 9 do
    for j:=1 to 9 do
    begin
      if p[i,j].warnadrh=p[y,x].warnadrh then
        IsiSml(i,j,temp);
    end;
end;

procedure TForm1.KlikSml(y, x, index : integer);
begin
  IsiCell(y,x,index);
  p[y,x].warnatls := clBlack;
  dec(JumlLv);
end;

procedure TForm1.KlikCell(y, x : integer);
begin
  HapusCell(y,x);
  p[y,x].warnatls :=clMaroon;
  inc(JumlLv);
end;

procedure TForm1.CariGray(LV : integer);
var
  i : integer;
begin
  for i:=1 to 9 do
    if p[y,x].sml[i].angka<>0 then
      GambarKtk(map[LV,i],clGray)
    else
      GambarKtk(map[LV,i],clWhite);
end;

procedure TForm1.InitPapan;
var
  i,j,k : integer;
begin
  JumlLv := 81;
  x := 1;
  y := 1;
  for i:=1 to 9 do
    for j:=1 to 9 do
    begin
      p[i,j].x := (j-1)*cellsize;
      p[i,j].y := (i-1)*cellsize;
      p[i,j].angka := 0;
      p[i,j].warnatls := clMaroon;
      if (i<4) and (j<4) then p[i,j].warnadrh := clBtnShadow else
      if (i<7) and (j<4) then p[i,j].warnadrh := clGradientActiveCaption else
      if j<4 then p[i,j].warnadrh := clOlive else
      if (i<4) and (j<7) then p[i,j].warnadrh := clDkGray else
      if (i<7) and (j<7) then p[i,j].warnadrh := clCream else
      if j<7 then p[i,j].warnadrh := clTeal else
      if i<4 then p[i,j].warnadrh := clSkyBlue else
      if i<7 then p[i,j].warnadrh := clMoneyGreen else
        p[i,j].warnadrh := clSilver;
      for k:=1 to 9 do
      begin
        p[i,j].sml[k].x := p[i,j].x+((k-1)mod 3)*smlsize;
        p[i,j].sml[k].y := p[i,j].y+((k-1)div 3)*smlsize;
        p[i,j].sml[k].angka:=k;
      end;
    end;
end;

procedure TForm1.InitMap;
var
  i,j : integer;
begin
  MiniMap.Canvas.Brush.Style := bsSolid;
  MiniMap.Canvas.Rectangle(0,0,MiniMap.Width,MiniMap.Height);
  for i:=1 to 81 do
    for j:=0 to 9 do
    begin
      if j=0 then
        map[i,j].x := j*ktksize+10
      else
        map[i,j].x := j*ktksize+20;
      map[i,j].y := i*ktksize+5;
    end;
end;

procedure TForm1.BackTracking(LV: integer;var sukses: boolean);
var
  prio      : integer;
  ctry,ctrx : integer;
begin
  if (LV>JumlLv) then
    sukses:=true
  else begin
    sukses:=false;
    if CheckBox1.Checked=true then
    begin
      Application.ProcessMessages;
      GambarPapan;
    end;
    GambarKtk(map[LV,0],clBlue);
    while p[y,x].warnatls<>clMaroon do
    begin
      inc(x);
      if x>9 then
      begin
        x:=1;
        inc(y);
      end;
    end;
    if loncat then
    begin
      prio:=p[y,x].angka+1;
      ctry := y; ctrx := x;
      while ctry<=9 do
      begin
        if p[ctry,ctrx].warnatls=clmaroon then
          HapusCell(ctry,ctrx);
        inc(ctrx);
        if ctrx>9 then
        begin
          ctrx :=1;
          inc(ctry);
        end;
      end;
      for ctrx:=LV+1 to JumlLv do
      begin
        HapusMap(ctrx);
      end;
      loncat := false;
    end else prio:=1;
    while (prio<=9) and (not sukses) do
    begin
      if p[y,x].sml[prio].angka<>0 then
      begin
        inc(itr);
        IsiCell(y,x,prio);
        CariGray(LV);
        GambarKtk(map[LV,prio],clRed);
        inc(x);
        if x>9 then
        begin
          x:=1;
          inc(y);
        end;
        BackTracking(LV+1,sukses);
        if (not sukses) then
        begin
          dec(x);
          if x<1 then
          begin
            x:=9;
            dec(y);
          end;
          while p[y,x].warnatls<>clMaroon do
          begin
            dec(x);
            if x<1 then
            begin
              x:=9;
              dec(y);
            end;
          end;
          HapusCell(y,x);
          GambarKtk(map[LV,prio],clWhite);
        end;
      end;
      inc(prio);
      if (prio>9) and (not sukses) then
        HapusMap(LV);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  x := 1;
  y := 1;
  Image.Canvas.Create;
  Image.Canvas.Font.Style := [fsbold];
  Image.Canvas.Font.Name := 'comic sans ms';
  InitPapan;
  GambarPapan;
  MiniMap.Canvas.Create;
  InitMap;
end;

procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,j,k : integer;
begin
  itr := 0;
  slt := 0;
  iteration.Caption := inttostr(itr);
  solution.Caption := inttostr(slt);
  for i:=1 to 9 do
    for j:=1 to 9 do
    begin
      if (p[i,j].x<x) and (p[i,j].x+cellsize>x) then
        if (p[i,j].y<y) and (p[i,j].y+cellsize>y) then
        begin
          if p[i,j].angka=0 then
          begin
            for k:=1 to 9 do
            if (p[i,j].sml[k].x<x) and (p[i,j].sml[k].x+smlsize>x) then
              if (p[i,j].sml[k].y<y) and (p[i,j].sml[k].y+smlsize>y) then
                if p[i,j].sml[k].angka<>0 then
                begin
                  KlikSml(i,j,k);
                end;
          end else
          begin
            if p[i,j].warnatls<>clred then
              KlikCell(i,j);
          end;
        end;
    end;
  Label2.Caption := '--';
  InitButton.Enabled := true;
  StartButton.Enabled := false;
  NextButton.Enabled := false;
  StopButton.Enabled := false;
  GambarPapan;
end;

procedure TForm1.InitButtonClick(Sender: TObject);
begin
  itr := 0;
  slt := 0;
  GambarMap;
  InitButton.Enabled := false;
  StartButton.Enabled := true;
  Label2.Caption := inttostr(JumlLv);
  iteration.Caption := inttostr(itr);
  solution.Caption := inttostr(slt);
end;

procedure TForm1.StartButtonClick(Sender: TObject);
begin
  itr := 1;
  slt := 0;
  LoadButton.Enabled := false;
  SaveButton.Enabled := false;
  ExitButton.Enabled := false;
  Image.Enabled:=false;
  StartButton.Enabled := false;
  BackTracking(1,sukses);
  NextButton.Enabled := true;
  StopButton.Enabled := true;
  inc(slt);
  iteration.Caption := inttostr(itr);
  solution.Caption := inttostr(slt);
  GambarPapan;
end;

procedure TForm1.NextButtonClick(Sender: TObject);
var
  ctr,st,gagal,i,j : integer;
begin
  sukses := false;
  x :=9 ;
  y :=9 ;
  ctr := 0;
  st := 0;
  gagal := 0;
  while (not sukses) and (gagal=0) do
  begin
    while p[y,x].warnatls<>clMaroon do
    begin
      inc(st);
      x := x-1;
      if x<1 then
      begin
        x := 9; dec(y);
      end;
    end;
    if y<1 then gagal := 1
    else begin
      loncat := true;
      BackTracking(JumlLv-ctr,sukses);
      inc(ctr);
      x := (81-ctr-1) mod 9+1-st;
      y := (81-ctr-1) div 9+1;
      while x<1 do
      begin
        x := x+9;
        dec(y);
      end;
    end;
  end;
  if gagal=1 then
  begin
    for i:=1 to 9 do
      for j:=1 to 9 do
        if (p[i,j].warnatls=clmaroon)and(p[i,j].angka<>0) then
          HapusCell(i,j);
    Image.Enabled:=true;
    x := 1;
    y := 1;
    StartButton.Enabled := true;
    NextButton.Enabled := false;
    StopButton.Enabled := false;
  end;
  inc(slt);
  iteration.Caption := inttostr(itr);
  solution.Caption := inttostr(slt);
  GambarPapan;
end;

procedure TForm1.StopButtonClick(Sender: TObject);
var
  i,j : integer;
begin
  if CheckBox1.Checked=false then
  begin
    for i:=1 to 9 do
      for j:=1 to 9 do
        if (p[i,j].warnatls=clmaroon)and(p[i,j].angka>0) then
          HapusCell(i,j);
    x := 1;
    y := 1;
    Image.Enabled:=true;
    LoadButton.Enabled := true;
    SaveButton.Enabled := true;
    ExitButton.Enabled := true;
    StartButton.Enabled := true;
    NextButton.Enabled := false;
    StopButton.Enabled := false;
    GambarPapan;
    GambarMap;
  end else
  begin
    x := 9;
    y := 9;
    c := 0;
    NextButton.Enabled := false;
    StopButton.Enabled := false;
    Timer1.Enabled := true;
  end;
end;

procedure TForm1.HapusMap(LV: integer);
var
  i : integer;
begin
  for i:=0 to 9 do
    GambarKtk(map[LV,i],clWhite);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (p[y,x].warnatls=clmaroon)and(p[y,x].angka>0) then
  begin
    HapusCell(y,x);
    HapusMap(JumlLv-c);
    inc(c);
  end;
  GambarPapan;
  dec(x);
  if x<1 then
  begin
    x := 9;
    dec(y);
  end;
  if y<1 then
  begin
    Timer1.Enabled := false;
    Image.Enabled:=true;
    LoadButton.Enabled := true;
    SaveButton.Enabled := true;
    ExitButton.Enabled := true;
    StartButton.Enabled := true;
  end;
end;

procedure TForm1.LoadButtonClick(Sender: TObject);
var
  i,j : integer;
begin
  if OpenDialog1.Execute then
  begin
    InitPapan;
    memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    for i:=1 to 9 do
      for j:=1 to 9 do
      begin
        if memo1.Lines[i-1][j]<>' ' then
        begin
          IsiCell(i,j,strtoint(memo1.Lines[i-1][j]));
          dec(JumlLv);
          p[i,j].warnatls := clRed;
        end;
      end;
    Label2.Caption := '--';
    InitButton.Enabled := true;
    StartButton.Enabled := false;
    NextButton.Enabled := false;
    StopButton.Enabled := false;
    GambarPapan;
  end;
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
var
  i,j   : integer;
  baris : string;
begin
  if SaveDialog1.Execute then
  begin
    memo1.lines.Clear;
    for i:=1 to 9 do
    begin
      baris := '';
      for j:=1 to 9 do
        if p[i,j].angka<>0 then
          baris := baris + inttostr(p[i,j].angka) else
          baris := baris + ' ';
      memo1.Lines.Add(baris);
    end;
    memo1.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm1.ExitButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
