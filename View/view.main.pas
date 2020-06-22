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
  FireDAC.Comp.Client, FMX.Objects, FMX.Media, FMX.TMSZBarReader,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, FMX.WebBrowser, System.IOUtils, IdSSLOpenSSLHeaders,
  DataPak.Android.BarcodeScanner ;

type
  TfmMain = class(TForm)
    ToolBar1: TToolBar;
    btnHome: TSpeedButton;
    btnClose: TSpeedButton;
    btnQrCode: TSpeedButton;
    tabMain: TTabControl;
    tabHome: TTabItem;
    ListView1: TListView;
    tabSale: TTabItem;
    lvSale: TListView;
    ToolBar5: TToolBar;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    ActionList1: TActionList;
    ChangeTabAction1: TChangeTabAction;
    Image1: TImage;
    lbSupermarket: TLabel;
    Image2: TImage;
    lbDate: TLabel;
    Image3: TImage;
    lbMoney: TLabel;
    Panel1: TPanel;
    IdHTTP1: TIdHTTP;
    BarcodeScanner1: TBarcodeScanner;
    pnlHome: TPanel;
    ToolBar3: TToolBar;
    Label3: TLabel;
    ToolBar2: TToolBar;
    Label1: TLabel;
    Image4: TImage;
    procedure btnHomeClick(Sender: TObject);
    procedure btnQrCodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TMSFMXZBarReader1GetResult(Sender: TObject; AResult: string);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure BarcodeScanner1ScanResult(Sender: TObject; AResult: string);
  private
    { Private declarations }
    FValorQrCode: String;
    Procedure PopulaListView;
    procedure PopulaDetalhesCompra(AListViewItem: TListViewItem);
    procedure PopupaInformacoes(ACfe: String);
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation
uses undados, system.json;

{$R *.fmx}

procedure TfmMain.BarcodeScanner1ScanResult(Sender: TObject; AResult: string);
begin
  FValorQrCode := Copy(AResult, (Pos('e', AResult)+1), 44);
  if FValorQrCode <> EmptyStr then
  begin
    PopupaInformacoes(FValorQrCode);
    PopulaListView;
    tabMain.TabIndex := 0;
  end;
end;

procedure TfmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.btnHomeClick(Sender: TObject);
begin
  tabMain.TabIndex := 0;
end;

procedure TfmMain.btnQrCodeClick(Sender: TObject);
begin
  BarcodeScanner1.Scan;
end;

procedure TfmMain.FormShow(Sender: TObject);
var
  ListViewItem: TListViewItem;
begin
  IdOpenSSLSetLibPath(TPath.GetDocumentsPath);
  PopulaListView;
  tabMain.TabIndex := 0;
end;

procedure TfmMain.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  PopulaDetalhesCompra(AItem);
  tabMain.TabIndex := 1;
end;

procedure TfmMain.PopulaDetalhesCompra(AListViewItem: TListViewItem);
var
  ListViewItem: TListViewItem;
begin
  lvSale.Items.Clear;
  dmDados.QSale.Close;
  dmDados.QSaleItem.Close;
  if ListView1.Items.Count > 0 then
  begin
  //Populada dados Compra
    dmDados.QSale.Open(Concat('SELECT * FROM SALE WHERE CFEKEY = ', QuotedStr(AListViewItem.Text)));
    if dmDados.QSale.RecordCount > 0 then
    begin
      lbSupermarket.Text := dmDados.QSalefantasyname.AsString;
      lbDate.Text  := dmDados.QSaleemissionDate.AsString;
      lbMoney.Text := Concat('R$ ', dmDados.QSalesubTotal.AsString);

      //Popula dados Itens da Compra
      dmDados.QSaleItem.Open(Concat('SELECT * FROM SALEITEM WHERE CFEKEY = ', QuotedStr(dmDados.QSalecfeKey.AsString)));
      if dmDados.QSaleItem.RecordCount > 0 then
      begin
        dmDados.QSaleItem.First;
        while not dmDados.QSaleItem.Eof do
        begin
          ListViewItem := lvSale.Items.Add;
          ListViewItem.Text   := dmDados.QSaleItemdescription.AsString;
          ListViewItem.Detail := Concat(dmDados.QSaleItemun.AsString, ' ',
                                        dmDados.QSaleItemamount.AsString, ' - Total: ',
                                        dmDados.QSaleItemprice.AsString);
          dmDados.QSaleItem.Next;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.PopulaListView;
var
  ListViewItem: TListViewItem;
begin
  ListView1.Items.Clear;
  dmDados.QSale.Close;
  dmDados.QSale.Open('SELECT * FROM SALE');
  if dmDados.QSale.RecordCount > 0 then
  begin
    dmDados.QSale.First;
    while not dmDados.QSale.Eof do
    begin
      ListViewItem := ListView1.Items.Add;
      ListViewItem.Text   := dmDados.QSalecfeKey.AsString;
      ListViewItem.Detail := Concat(dmDados.QSalefantasyname.AsString, ' - ',
                                    dmDados.QSaleemissionDate.AsString);
      dmDados.QSale.Next;
    end;
  end;
end;

procedure TfmMain.PopupaInformacoes(ACfe: String);
var
  Resp: String;
  JsonCoupon: TJSONObject;
  JsonItems: TJSONArray;
  JsonItem: TJSONObject;
  I: Integer;
begin
  dmDados.QSale.Open(Concat('SELECT * FROM SALE WHERE CFEKEY = ', QuotedStr(FValorQrCode)));
  if dmDados.QSale.RecordCount = 0 then
  begin
   IdHTTP1.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
   Resp := IdHTTP1.Get(Concat('https://cfe.sefaz.ce.gov.br:8443/portalcfews/mfe/fiscal-coupons/extract/', ACfe));

   if IdHTTP1.ResponseCode = 200 then
   begin
    JsonCoupon := (TJSONObject.ParseJSONValue(Resp) as TJSONObject).GetValue('coupon') as TJSONObject;

    {Grava Venda}
    dmDados.QSale.Insert;
    dmDados.QSalecfeKey.AsString := JsonCoupon.GetValue<string>('cfeKey');
    dmDados.QSalefantasyname.AsString := JsonCoupon.GetValue<string>('fantasyName');
    dmDados.QSalesubTotal.AsFloat := JsonCoupon.GetValue<Double>('subTotal');
    dmDados.QSalediscount.AsFloat := JsonCoupon.GetValue<Double>('discount');
    dmDados.QSaletotalTaxes.AsFloat := JsonCoupon.GetValue<Double>('totalTaxes');
    dmDados.QSaleemissionDate.AsDateTime := StrToDateTime(copy(JsonCoupon.GetValue<string>('emissionDate'),0,Pos(' ', JsonCoupon.GetValue<string>('emissionDate'))));
    dmDados.QSale.Post;

    {Grava Items}
    JsonItems := JsonCoupon.GetValue<TJSONArray>('items') as TJSONArray;
    if JsonItems.Count > 0 then
    begin
      dmDados.QSaleItem.Close;
      dmDados.QSaleItem.Open;
      for I := 0 to JsonItems.Count-1 do
      begin
        JsonItem := JsonItems.Items[I] as TJSONObject;
        dmDados.QSaleItem.Insert;
        dmDados.QSaleItemamount.AsFloat := JsonItem.GetValue<Double>('amount');
        dmDados.QSaleItemprice.AsFloat  := JsonItem.GetValue<Double>('price');
        dmDados.QSaleItemvalueOfTaxes.AsFloat := JsonItem.GetValue<Double>('valueOfTaxes');
        dmDados.QSaleItemcfeKey.AsString := JsonCoupon.GetValue<string>('cfeKey');
        dmDados.QSaleItemcode.AsInteger  := JsonItem.GetValue<Integer>('code');
        dmDados.QSaleItemdescription.AsString := JsonItem.GetValue<string>('description');
        dmDados.QSaleItemun.AsString := JsonItem.GetValue<string>('un');
        dmDados.QSaleItem.Post;
      end;
    end;
   end;
  end
  else
  begin
    ShowMessage('Cupom já cadastrado!');
  end;
end;

procedure TfmMain.SpeedButton1Click(Sender: TObject);
begin
  PopulaListView;
  ChangeTabAction1.ExecuteTarget(Self);
end;

procedure TfmMain.TMSFMXZBarReader1GetResult(Sender: TObject; AResult: string);
begin
 FValorQrCode := AResult;
end;

end.
