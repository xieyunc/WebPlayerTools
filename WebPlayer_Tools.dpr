program WebPlayer_Tools;

uses
  Forms,
  uMain in 'source\uMain.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'WebPlayer9ӰƬ������ӹ���';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
