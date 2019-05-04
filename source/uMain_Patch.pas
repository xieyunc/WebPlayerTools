unit uMain_Patch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StrUtils,
  Dialogs, DB, ADODB, StdCtrls, ComCtrls, Buttons, RzTabs, ExtCtrls, EhLibADO,
  Inifiles, ShellAPI, Menus, DBGridEhGrouping, GridsEh, DBGridEh, CnIISCtrl, CnProgressFrm;

type
  TMain_Patch = class(TForm)
    ADOConnection1: TADOConnection;
    qry_Temp: TADOQuery;
    RzPageControl2: TRzPageControl;
    TabSheet3: TRzTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    btn_Test: TBitBtn;
    chk_Local: TCheckBox;
    Bevel1: TBevel;
    lbl_db: TLabel;
    edt_db: TEdit;
    btn_Patch: TBitBtn;
    btn_Exit: TBitBtn;
    edt_Source: TLabeledEdit;
    edt_Desc: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_TestClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure edt_SourceChange(Sender: TObject);
    procedure btn_PatchClick(Sender: TObject);
    procedure chk_LocalClick(Sender: TObject);
    procedure btn_ExitClick(Sender: TObject);
  private
    { Private declarations }
    procedure ReadFromIni;
    procedure WriteIntoIni;
    function GetConnStr:string;
  public
    { Public declarations }
  end;

var
  Main_Patch: TMain_Patch;

implementation
uses ShlObj,ActiveX;
{$R *.dfm}

{ TForm1 }
function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
    if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
    result := 0;
end;

function SelectFolder(const Caption: string; const Root: String;
    var Directory: string): boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  OldErrorMode: Cardinal;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
        POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        hwndOwner := Application.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        if Directory <> '' then
        begin
          lpfn := SelectDirCB;
          lParam := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        SetErrorMode(OldErrorMode);
        EnableTaskWindows(WindowList);
      end;
      Result := ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
        ShellMalloc.Free(Buffer);
    end;
  end;
end;

procedure TMain_Patch.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMain_Patch.btn_PatchClick(Sender: TObject);
var
  sqlstr,sTemp:string;
  ii : Integer;

  procedure OpenTable;
  begin
    qry_Temp.Close;
    qry_Temp.SQL.Text := sqlstr;
    qry_Temp.Open;
  end;
  procedure ReplaceUrl;
  begin
    qry_Temp.First;
    ShowProgress('正在处理，请稍候....',qry_Temp.RecordCount);
    while not qry_Temp.Eof do
    begin
      UpdateProgress(qry_Temp.RecNo);
      sTemp := qry_Temp.Fields[1].AsString;
      if Pos(edt_Source.Text,sTemp)>0 then
      begin
        sTemp := ReplaceStr(sTemp,edt_Source.Text,edt_Desc.Text);
        qry_Temp.Edit;
        qry_Temp.Fields[1].AsString := sTemp;
        qry_Temp.Post;
        ii := ii+1
      end;
      qry_Temp.Next;
    end;
    HideProgress;
    qry_Temp.Close;
  end;
begin
  ii := 0;
  sqlstr := 'select url_id,url_intro from adnim_url';
  OpenTable;
  ReplaceUrl;

  sqlstr := 'select data_id,data_picurl from adnim_data';
  OpenTable;
  ReplaceUrl;

  MessageBox(Handle, PChar('数据处理完成，共替换'+IntTostr(ii)+'条记录！　　'), '系统提示', MB_OK +
    MB_ICONINFORMATION + MB_TOPMOST);
end;

procedure TMain_Patch.btn_TestClick(Sender: TObject);
begin
  try
    ADOConnection1.Close;
    ADOConnection1.ConnectionString := GetConnStr;
    ADOConnection1.Connected := True;
    Application.MessageBox('数据库服务器连接成功！　　', '操作提示', MB_OK + 
      MB_ICONINFORMATION);
    WriteIntoIni;
  Except
    Application.MessageBox('数据库连接失败！请检查后重试！　　', '操作提示',
      MB_OK + MB_ICONSTOP);
  end;
end;

procedure TMain_Patch.chk_LocalClick(Sender: TObject);
begin
  Edit2.Enabled := not chk_Local.Checked;
  Edit3.Enabled := not chk_Local.Checked;
end;

procedure TMain_Patch.edt_SourceChange(Sender: TObject);
begin
  WriteIntoIni;
end;

procedure TMain_Patch.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
  var Resize: Boolean);
begin
  Resize := False;
end;

procedure TMain_Patch.FormCreate(Sender: TObject);
begin
  ReadFromIni;
  ADOConnection1.Close;
  ADOConnection1.ConnectionString := GetConnStr;
end;

function TMain_Patch.GetConnStr: string;
begin
  //Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=webplayer9;Data Source=.
  if chk_Local.Checked then
    Result := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog='+edt_db.Text+';Data Source='+Edit1.Text
  else
    Result := 'Provider=SQLOLEDB.1;Password='+Edit3.Text+';Persist Security Info=False;User ID='+Edit2.Text+';Initial Catalog='+edt_db.Text+';Data Source='+Edit1.Text;
end;

procedure TMain_Patch.ReadFromIni;
var
  fn :string;
begin
  fn := ExtractFilePath(ParamStr(0))+'AppSet.INI';

  With TIniFile.Create(fn) do
  begin
    try
      //Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=webplayer9;Data Source=.
      Edit1.Text := ReadString('DBSET','DB_HOST',Edit1.Text);
      edt_db.Text := ReadString('DBSET','DB_NAME',edt_db.Text);
      Edit2.Text := ReadString('DBSET','DB_SA',Edit2.Text);
      Edit3.Text := ReadString('DBSET','DB_PWD',Edit3.Text);
      chk_Local.Checked := ReadString('DBSET','CONN_MODE','WIN') = 'WIN';
      edt_Source.Text := ReadString('OTHERSET','SOURCE_STR',edt_Source.Text);
      edt_Desc.Text := ReadString('OTHERSET','DESC_STR',edt_Desc.Text);
    finally
      Free;
    end;
  end;
end;

procedure TMain_Patch.WriteIntoIni;
var
  fn :string;
begin
  fn := ExtractFilePath(ParamStr(0))+'AppSet.INI';

  With TIniFile.Create(fn) do
  begin
    try
      //Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=webplayer9;Data Source=.
      WriteString('DBSET','DB_HOST',Edit1.Text);
      WriteString('DBSET','DB_NAME',edt_db.Text);
      WriteString('DBSET','DB_SA',Edit2.Text);
      WriteString('DBSET','DB_PWD',Edit3.Text);
      if chk_Local.Checked then
         WriteString('DBSET','CONN_MODE','WIN')
      else
         WriteString('DBSET','CONN_MODE','SQL');
      WriteString('OTHERSET','SOURCE_STR',edt_Source.Text);
      WriteString('OTHERSET','DESC_STR',edt_Desc.Text);
    finally
      Free;
    end;
  end;
end;

end.
