unit FrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs;

type
  TFormMain = class(TForm)
    BtnStart: TButton;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    FileDialog: TOpenTextFileDialog;
    BtnOuvrir: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LbATraiter: TListBox;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOuvrirClick(Sender: TObject);
  private
    procedure DisableUI(flag: boolean);
    { Déclarations privées }
  protected
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  public
    { Déclarations publiques }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses ShellAPI, Threading, System.UITypes, uFixImageSquash;

const
  MESS_NO_FILE: string = 'Pas de fichier modifié.';
  MESS_INVALID_FILE1: string = 'Erreur : ';
  MESS_INVALID_FILE2: string = ' n''est pas un fichier';
  MESS_SUCCES: string = 'Document traité : ';
  MESS_NO_IMG: string = 'Aucune image à rétablir n''a été trouvé.';
  MESS_ERR_EXT_FICHIER1: string = 'Fichier ';
  MESS_ERR_EXT_FICHIER2: string = ' non valide. Extension .htm (Page Web) attendue.';
  EXTENSION_ATTENDUE: string = '.htm';
  EXTENSION_OLD: string = '.old';

procedure TFormMain.DisableUI(flag: boolean);
begin
  DragAcceptFiles(Handle, not flag);
  BtnOuvrir.Enabled := not flag;
  BtnStart.Enabled := not flag;
  if flag then
  begin
    ProgressBar1.State := TProgressBarState.pbsNormal;
  end
  else
  begin
    ProgressBar1.State := TProgressBarState.pbsPaused;
  end;
end;

procedure TFormMain.BtnOuvrirClick(Sender: TObject);
var
  I: Integer;
begin
  if FileDialog.Execute then
  begin
    for I := 0 to FileDialog.Files.Count - 1 do
      if ExtractFileExt(FileDialog.Files[I]) = EXTENSION_ATTENDUE then
      begin
        LbATraiter.Items[0] := ExtractFileName(FileDialog.Files[I]);
      end
      else
      begin
        MessageDlg(MESS_ERR_EXT_FICHIER1 + ExtractFileName(FileDialog.Files[I]) + MESS_ERR_EXT_FICHIER2, mtError, [mbOK], 0);
      end;
  end;
end;

procedure TFormMain.BtnStartClick(Sender: TObject);
begin

  if LbATraiter.Items.Count > 0 then
  begin
    TTask.Create(
      procedure
      var
        fileName: string;
        htmlData: string;
        sl: TStrings;
      begin
        DisableUI(true);
        sl := TStringList.Create();
        try
          // Read source html data
          fileName := LbATraiter.Items[0];
          if not FileExists(fileName) then
          begin
            MessageDlg(MESS_INVALID_FILE1 + fileName + MESS_INVALID_FILE2, mtError, [mbOK], 0);
            exit;
          end;

          sl.LoadFromFile(fileName);
          htmlData := sl.Text;

          // Fix it
          htmlData := FixImgAttributes(htmlData);
          htmlData := FixVShape(htmlData);

          // Rename old
          RenameFile(fileName, fileName + EXTENSION_OLD);

          // Save changes
          sl.Text := htmlData;
          sl.SaveToFile(fileName);
        finally
          sl.Free();
        end;

        // Fin traitement
        DisableUI(false);
        if anyImageFixed then
        begin
          MessageDlg(MESS_SUCCES + fileName, mtInformation, [mbOK], 0);
        end
        else
        begin
          MessageDlg(MESS_NO_FILE, mtWarning, [mbOK], 0);
        end;
        anyImageFixed := false;
      end).Start;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, true);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, false);
end;

procedure TFormMain.WMDropFiles(var Msg: TMessage);
var
  hDrop: THandle;
  fileCount: Integer;
  nameLen: Integer;
  I: Integer;
  fileName: string;
begin
  hDrop := Msg.wParam;
  fileCount := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);

  for I := 0 to fileCount - 1 do
  begin
    nameLen := DragQueryFile(hDrop, I, nil, 0) + 1;
    SetLength(fileName, nameLen);
    DragQueryFile(hDrop, I, Pointer(fileName), nameLen);
    fileName := fileName.Remove(fileName.Length - 1, 1);
    if ExtractFileExt(fileName) = EXTENSION_ATTENDUE then
    begin
      LbATraiter.Items[0] := fileName;
    end
    else
    begin
      MessageDlg(MESS_ERR_EXT_FICHIER1 + ExtractFileName(fileName) + MESS_ERR_EXT_FICHIER2, mtError, [mbOK], 0);
    end;
  end;
  DragFinish(hDrop);
end;

end.
