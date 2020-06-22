unit undados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, System.IOUtils;

type
  TdmDados = class(TDataModule)
    FDConnection1: TFDConnection;
    QSale: TFDQuery;
    QSaleItem: TFDQuery;
    QSalecfeKey: TStringField;
    QSalesubTotal: TFloatField;
    QSalediscount: TFloatField;
    QSaletotalTaxes: TFloatField;
    QSaleemissionDate: TDateTimeField;
    QSalefantasyname: TWideStringField;
    QSaleItemamount: TFloatField;
    QSaleItemprice: TFloatField;
    QSaleItemvalueOfTaxes: TFloatField;
    QSaleItemcode: TIntegerField;
    QSaleItemdescription: TWideStringField;
    QSaleItemun: TStringField;
    QSaleItemcfeKey: TWideStringField;
    procedure FDConnection1BeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmDados.FDConnection1BeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
    FDConnection1.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'dbMinhaNota.db');
  {$ENDIF}
end;

end.
