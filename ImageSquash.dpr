program ImageSquash;

uses
  Vcl.Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  uFixImageSquash in 'uFixImageSquash.pas';

{$R *.res}

begin
  Application.Initialize;
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ImageSquash';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
