object dmDados: TdmDados
  OldCreateOrder = False
  Height = 178
  Width = 184
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\BitBucket\Delphi\MinhaNota\DataBase\dbMinhaNota.db'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    BeforeConnect = FDConnection1BeforeConnect
    Left = 48
    Top = 22
  end
  object QSale: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from sale')
    Left = 40
    Top = 97
    object QSalecfeKey: TStringField
      FieldName = 'cfeKey'
      Origin = 'cfeKey'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 60
    end
    object QSalesubTotal: TFloatField
      FieldName = 'subTotal'
      Origin = 'subTotal'
    end
    object QSalediscount: TFloatField
      FieldName = 'discount'
      Origin = 'discount'
    end
    object QSaletotalTaxes: TFloatField
      FieldName = 'totalTaxes'
      Origin = 'totalTaxes'
    end
    object QSaleemissionDate: TDateTimeField
      FieldName = 'emissionDate'
      Origin = 'emissionDate'
    end
    object QSalefantasyname: TWideStringField
      FieldName = 'fantasyname'
      Origin = 'fantasyname'
      Size = 32767
    end
  end
  object QSaleItem: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from saleitem')
    Left = 118
    Top = 98
    object QSaleItemamount: TFloatField
      FieldName = 'amount'
      Origin = 'amount'
    end
    object QSaleItemprice: TFloatField
      FieldName = 'price'
      Origin = 'price'
    end
    object QSaleItemvalueOfTaxes: TFloatField
      FieldName = 'valueOfTaxes'
      Origin = 'valueOfTaxes'
    end
    object QSaleItemcode: TIntegerField
      FieldName = 'code'
      Origin = 'code'
    end
    object QSaleItemdescription: TWideStringField
      FieldName = 'description'
      Origin = 'description'
      Size = 32767
    end
    object QSaleItemun: TStringField
      FieldName = 'un'
      Origin = 'un'
      Size = 32767
    end
    object QSaleItemcfeKey: TWideStringField
      FieldName = 'cfeKey'
      Origin = 'cfeKey'
      Size = 60
    end
  end
end
