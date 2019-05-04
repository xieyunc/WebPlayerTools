program WebPlayer_Tools;

uses
  Forms,
  uMain in 'source\uMain.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'WebPlayer9影片批量添加工具';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
