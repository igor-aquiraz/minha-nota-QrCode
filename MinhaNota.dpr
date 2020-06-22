program MinhaNota;

uses
  System.StartUpCopy,
  FMX.Forms,
  view.main in 'View\view.main.pas' {fmMain},
  undados in 'DataBase\undados.pas' {dmDados: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
