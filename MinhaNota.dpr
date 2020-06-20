program MinhaNota;

uses
  System.StartUpCopy,
  FMX.Forms,
  view.main in 'View\view.main.pas' {fmMain},
  UndmDados in 'DataBase\UndmDados.pas' {dmDatabase: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.Run;
end.
