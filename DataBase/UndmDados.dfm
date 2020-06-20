object dmDados: TdmDados
  OldCreateOrder = False
  Height = 282
  Width = 405
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\BitBucket\Delphi\MinhaNota\DataBase\dbMinhaNota.db'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    BeforeCommit = FDConnection1BeforeCommit
    Left = 64
    Top = 72
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 64
    Top = 128
  end
end
