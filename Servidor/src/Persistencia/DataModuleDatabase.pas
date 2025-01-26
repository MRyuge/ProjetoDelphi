unit DataModuleDatabase;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Comp.Client,
  Data.DB,System.IniFiles;

type
  TdmDatabase = class(TDataModule)
    FDConnection: TFDConnection;
    FDTransaction: TFDTransaction;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConnectToDatabase;
    procedure DisconnectFromDatabase;
  end;

var
  dmDatabase: TdmDatabase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TdmDatabase }

procedure TdmDatabase.ConnectToDatabase;
var
  IniFile: TIniFile;
  ConfigPath: string;
begin
  ConfigPath := ExtractFilePath(ParamStr(0)) + 'Config\DatabaseConfig.ini';
  IniFile := TIniFile.Create(ConfigPath);
  try
    try
      FDConnection.Params.DriverID := IniFile.ReadString('Database', 'DriverID', '');
      FDConnection.Params.Database := IniFile.ReadString('Database', 'Database', '');
      FDConnection.Params.UserName := IniFile.ReadString('Database', 'UserName', '');
      FDConnection.Params.Password := IniFile.ReadString('Database', 'Password', '');
      FDConnection.Params.Add('Server=' + IniFile.ReadString('Database', 'Server', ''));
      FDConnection.Params.Add('Port=' + IniFile.ReadString('Database', 'Port', ''));
      FDConnection.Connected := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao carregar configurações ou conectar ao banco: ' + E.Message);
    end;
  finally
    IniFile.Free;
  end;
end;


procedure TdmDatabase.DisconnectFromDatabase;
begin
  if FDConnection.Connected then
    FDConnection.Connected := False;
end;

end.
