unit view.main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.TabControl, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Actions, FMX.ActnList, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FMX.Objects, FMX.Media, FMX.TMSZBarReader;

type
  TfmMain = class(TForm)
    ToolBar1: TToolBar;
    btnHome: TSpeedButton;
    btnClose: TSpeedButton;
    btnQrCode: TSpeedButton;
    tabMain: TTabControl;
    tabHome: TTabItem;
    tabQrCode: TTabItem;
    ListView1: TListView;
    ToolBar2: TToolBar;
    Label1: TLabel;
    ToolBar3: TToolBar;
    Label3: TLabel;
    tabSale: TTabItem;
    lvSale: TListView;
    ToolBar5: TToolBar;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    ActionList1: TActionList;
    ChangeTabAction1: TChangeTabAction;
    CameraComponent: TCameraComponent;
    imgQrCode: TImage;
    TMSFMXZBarReader1: TTMSFMXZBarReader;
    Image1: TImage;
    lbSupermarket: TLabel;
    Image2: TImage;
    lbDate: TLabel;
    Image3: TImage;
    lbMoney: TLabel;
    procedure btnHomeClick(Sender: TObject);
    procedure btnQrCodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure tabMainChange(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CameraComponentSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure TMSFMXZBarReader1GetResult(Sender: TObject; AResult: string);
  private
    { Private declarations }
    FValorQrCode: String;
    Procedure PopulaListView;
    procedure PopulaDetalhesCompra;
    procedure GetImage;
    procedure LerQrCode;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation
uses UndmDados;

{$R *.fmx}

procedure TfmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.btnHomeClick(Sender: TObject);
begin
  tabMain.TabIndex := 1;
end;

procedure TfmMain.btnQrCodeClick(Sender: TObject);
begin
  //Popula no banco
  tabMain.TabIndex := 0;
  TMSFMXZBarReader1.Show;
end;

procedure TfmMain.CameraComponentSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(TThread.CurrentThread, GetImage);
end;

procedure TfmMain.FormShow(Sender: TObject);
var
  ListViewItem: TListViewItem;
begin
  PopulaListView;
  tabMain.TabIndex := 0;
end;

procedure TfmMain.GetImage;
begin
  CameraComponent.SampleBufferToBitmap(imgQrCode.Bitmap, True);
end;

procedure TfmMain.LerQrCode;
begin

end;

procedure TfmMain.ListView1DblClick(Sender: TObject);
begin
  PopulaDetalhesCompra;
  tabMain.TabIndex := 2;
end;

procedure TfmMain.PopulaDetalhesCompra;
var
  ListViewItem: TListViewItem;
begin
  if ListView1.Items.Count > 0 then
  begin
    //Populada dados Compra
    dmDados.FDQuery1.SQL.Clear;
    dmDados.FDQuery1.SQL.Text := Concat('SELECT SA.SUBTOTAL, SA.EMISSIONDATE, SU.FANTASYNAME FROM SALE SA ',
                                  'JOIN SUPERMARKET SU ON (SU.TAXIDNUMBER = SA.TAXIDNUMBER) ',
                                  'WHERE SA.CFEKEY = ', QuotedStr(ListView1.Items[ListView1.ItemIndex].Text));
    dmDados.FDQuery1.Open;
    if dmDados.FDQuery1.RecordCount > 0 then
    begin
      lbSupermarket.Text := dmDados.FDQuery1.FieldByName('FANTASYNAME').AsString;
      lbDate.Text := dmDados.FDQuery1.FieldByName('EMISSIONDATE').AsString;
      lbMoney.Text := Concat('R$ ', dmDados.FDQuery1.FieldByName('SUBTOTAL').AsString);

      //Popula dados Itens da Compra
      lvSale.Items.Clear;
      dmDados.FDQuery1.SQL.Clear;
      dmDados.FDQuery1.SQL.Text := Concat('SELECT I.DESCRIPTION, I.CODE, I.UN, SI.AMOUNT, SI.PRICE FROM SALEITEM SI ',
                                    'JOIN ITEMS I ON (I.CODE = SI.CODE) ',
                                    'WHERE SI.CFEKEY = ', QuotedStr(ListView1.Items[ListView1.ItemIndex].Text));
      dmDados.FDQuery1.Open;
      while not dmDados.FDQuery1.Eof do
      begin
        ListViewItem := lvSale.Items.Add;
        ListViewItem.Text   := Concat(dmDados.FDQuery1.FieldByName('CODE').AsString, ' - ',
                                      dmDados.FDQuery1.FieldByName('DESCRIPTION').AsString);
        ListViewItem.Detail := Concat('QTD: ', dmDados.FDQuery1.FieldByName('UN').AsString, ' ',
                                      dmDados.FDQuery1.FieldByName('AMOUNT').AsString, ' - Total: ',
                                      dmDados.FDQuery1.FieldByName('PRICE').AsString);
        dmDados.FDQuery1.Next;
      end;
    end;
  end;
end;

procedure TfmMain.PopulaListView;
var
  ListViewItem: TListViewItem;
begin
  ListView1.Items.Clear;
  dmDados.FDQuery1.SQL.Clear;
  dmDados.FDQuery1.SQL.Text := Concat('SELECT SA.CFEKEY, SA.SUBTOTAL, SA.EMISSIONDATE, SU.FANTASYNAME FROM SALE SA ',
                                'JOIN SUPERMARKET SU ON (SU.TAXIDNUMBER = SA.TAXIDNUMBER)');
  dmDados.FDQuery1.Open;
  if dmDados.FDQuery1.RecordCount > 0 then
  begin
    while not dmDados.FDQuery1.Eof do
    begin
      ListViewItem := ListView1.Items.Add;
      ListViewItem.Text   := dmDados.FDQuery1.FieldByName('CFEKEY').AsString;
      ListViewItem.Detail := Concat(dmDados.FDQuery1.FieldByName('FANTASYNAME').AsString, ' - ',
                                    dmDados.FDQuery1.FieldByName('EMISSIONDATE').AsString, ' - ',
                                    dmDados.FDQuery1.FieldByName('SUBTOTAL').AsString);
      dmDados.FDQuery1.Next;
    end;
  end;
end;

procedure TfmMain.SpeedButton1Click(Sender: TObject);
begin
  ChangeTabAction1.ExecuteTarget(Self);
end;

procedure TfmMain.tabMainChange(Sender: TObject);
begin
  if tabMain.ActiveTab = tabHome then
    PopulaListView;
end;

procedure TfmMain.TMSFMXZBarReader1GetResult(Sender: TObject; AResult: string);
begin
 FValorQrCode := AResult;
end;

end.
