object dmDatabase: TdmDatabase
  OldCreateOrder = False
  Height = 219
  Width = 321
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=teste'
      'User_Name=postgres'
      'Password=postgres'
      'Server=localhost'
      'DriverID=PG')
    LoginPrompt = False
    Transaction = FDTransaction
    Left = 136
    Top = 40
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 40
    Top = 32
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 64
    Top = 96
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 
      'C:\TesteDelphi\MaikRyuge\ArquiteturaDataSnap\Servidor\Win32\Debu' +
      'g\libpq.dll'
    Left = 224
    Top = 96
  end
end
