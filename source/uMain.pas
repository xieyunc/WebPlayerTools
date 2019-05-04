unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StrUtils,
  Dialogs, DB, ADODB, StdCtrls, ComCtrls, Buttons, RzTabs, ExtCtrls, EhLibADO, ComObj,
  Inifiles, ShellAPI, Menus, DBGridEhGrouping, GridsEh, DBGridEh, CnIISCtrl,
  StatusBarEx, CnButtonEdit, RzStatus, RzPanel, RzPrgres, ImgList, StdActns,
  ActnList;

type
  TMain = class(TForm)
    ADOConnection1: TADOConnection;
    qry_Temp: TADOQuery;
    RzPageControl1: TRzPageControl;
    TabSheet2: TRzTabSheet;
    mmo2: TMemo;
    qry_ProgInfo: TADOQuery;
    qry_Prog_Server: TADOQuery;
    pm1: TPopupMenu;
    mi_DeleteErrorMovie: TMenuItem;
    rztbshtTabSheet4: TRzTabSheet;
    DBGridEh1: TDBGridEh;
    qry_class: TADOQuery;
    ds_class: TDataSource;
    CnIISCtrl1: TCnIISCtrl;
    Panel1: TPanel;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    ProgressBar1: TRzProgressStatus;
    bvl2: TBevel;
    btn_InitLocalDir: TBitBtn;
    btn_InitUrl: TBitBtn;
    lbl_Srv: TLabel;
    lbl_Image: TLabel;
    lbl_SrvUrl: TLabel;
    cbb_Srv: TComboBox;
    edt_Image: TEdit;
    edt_SrvUrl: TEdit;
    btn_UpdateSrvUrl: TBitBtn;
    grp1: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl_db: TLabel;
    edt1: TEdit;
    edt2: TEdit;
    edt3: TEdit;
    btn_Test: TBitBtn;
    chk_Local: TCheckBox;
    edt_db: TEdit;
    btn_OK: TBitBtn;
    chk_Delete: TCheckBox;
    bvl1: TBevel;
    mi_UpdateMovie: TMenuItem;
    mi_CreateLocalDir: TMenuItem;
    mi_CreateVirualDir: TMenuItem;
    actlst1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    mi_AllowEdit: TMenuItem;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_TestClick(Sender: TObject);
    procedure chk_LocalClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure edt_ImageChange(Sender: TObject);
    procedure edt_PathChange(Sender: TObject);
    procedure mi_DeleteErrorMovieClick(Sender: TObject);
    procedure DBGridEh1Columns2UpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure edt_SrvUrlChange(Sender: TObject);
    procedure edt_SrvUrlExit(Sender: TObject);
    procedure btn_UpdateSrvUrlClick(Sender: TObject);
    procedure DBGridEh1Columns2EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure btn_InitLocalDirClick(Sender: TObject);
    procedure TabSheet3DblClick(Sender: TObject);
    procedure btn_InitUrlClick(Sender: TObject);
    procedure mi_CreateLocalDirClick(Sender: TObject);
    procedure DBGridEh1Columns2EditButtonClick(Sender: TObject;
      var Handled: Boolean);
    procedure mi_CreateVirualDirClick(Sender: TObject);
    procedure mi_UpdateMovieClick(Sender: TObject);
    procedure mi_AllowEditClick(Sender: TObject);
  private
    { Private declarations }
    Old_SrvUrl,DEF_IMAGE:string;
    function CreateVirDir(const sUrl,sDir,sName:string):Boolean;
    procedure ReadFromIni;
    procedure WriteIntoIni;
    procedure ReadImageFileFromDownLoad;
    procedure DeleteMovie(const IsHint:Boolean=False);
    procedure GetMovieClassList(var MovieClassList:TStrings);
    function GetConnStr:string;
    function IsImageFile(const fn:string):Boolean;
    function IsTxtFile(const fn:string):Boolean;
    function IsMovieFile(const fn:string):Boolean;
    function GetMovieIntro(const fn:string):string;
    function GetFileType(const fn:string):string;
    function GetMovieName(const fn:string):string;
    function GetImageName(const MovieName:string):string;
    function GetVodSrvID:Integer;
    procedure InitVodSrvID;
    procedure InitVodClass;
    function GetTypeID(const sDirName:string):Integer;//�õ�Ŀ¼���ڵ����ID �����Ӱ�����Ӿ��
    function GetMovieID(const sClassName:string):Integer;//�õ�Ŀ¼���ڵķ���ID ���綯��Ƭ���ƻ�Ƭ��
    function GetMovieUrl(const sFileName:string):string; //�õ���Ӱ��URL·��
    procedure UpdateMovieByMovieClass(var iResult:Integer);
    procedure UpdateMovie(const SrvID,ClassID:Integer;const aClassName,MovieName,MovieIntro,PhotoName,UrlStr:string);
    procedure CreateVirualDir(const ShowConfirmBox:Boolean=True);
  public
    { Public declarations }
  end;

const
  CONST_IMAGE_DIR = 'Upload\MoviePic\';

var
  Main: TMain;

implementation
uses ShlObj,ActiveX;
{$R *.dfm}

{ TForm1 }

function GetVirDirFromUrl(const sUrl:string):string;
var
  str,sTemp:string;
begin
  str := LowerCase(sUrl);
  if LeftStr(str,7)<>'http://' then
    Result := sUrl
  else
  begin
    str := ReplaceStr(str,'http://','');
    if Pos('/',str)=0 then
      str := '/'
    else
      str := Copy(str,Pos('/',str),Length(str));
    sTemp := ReverseString(str);
    if Pos('.',sTemp)>0 then
      sTemp := Copy(sTemp,Pos('/',sTemp),Length(sTemp));
    str := ReverseString(sTemp);
    Result := str;
  end;
end;

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

procedure  GetDir(const Path:string;MovieList:TStrings);
var
  SearchRec:TSearchRec;
  found:integer;
  sPath:String;
  subMovieList,fnList:TStringList;
  i: Integer;
begin
  MovieList.Clear;
  fnList := TStringList.Create;
  subMovieList := TStringList.Create;
  MovieList.BeginUpdate;
  fnList.BeginUpdate;
  subMovieList.BeginUpdate;
  try
    sPath := Path;
    if sPath[Length(sPath)]<>'\' then
      sPath := sPath+'\';
    found:=FindFirst(sPath+'*.*',faDirectory,SearchRec);
    while found=0 do
    begin
      if (SearchRec.Name<>'.') and (SearchRec.Name<>'..')
         and (SearchRec.Attr=faDirectory) then
         begin
             fnList.Add(IntToStr(SearchRec.Time)+'='+sPath+SearchRec.Name);
             GetDir(sPath+SearchRec.Name,subMovieList);
             fnList.AddStrings(subMovieList);
         end;
         Found:=FindNext(SearchRec);
    end;
    FindClose(SearchRec);

    fnList.Sort;
    fnList.Sorted := True;
    for i := 0 to fnList.Count - 1 do
      MovieList.Add(fnList.ValueFromIndex[i]);

  finally
    fnList.EndUpdate;
    subMovieList.EndUpdate;
    MovieList.EndUpdate;
    fnList.Free;
    subMovieList.Free;
  end;
end;

procedure TMain.GetMovieClassList(var MovieClassList: TStrings);
var
  SearchRec:TSearchRec;
  found:integer;
  sPath:String;
  subMovieList:TStrings;
  New_SrvUrl:string;
begin
  MovieClassList.Clear;
  qry_class.First;
  while not qry_class.Eof do
  begin
    sPath := qry_class.FieldByName('class_localdir').AsString;
    if DirectoryExists(sPath) then
      MovieClassList.Add(sPath);
    qry_class.Next;
  end;
end;

procedure GetFile(const Path:string;fnList:TStrings);
var
  SearchRec:TSearchRec;
  found:integer;
  sPath:String;
begin
  sPath := Path;
  if sPath[Length(sPath)]<>'\' then
    sPath := sPath+'\';
  found:=FindFirst(sPath+'*.*',faAnyFile,SearchRec);
  fnList.BeginUpdate;
  while found=0 do
  begin
    if (SearchRec.Name<>'.') and (SearchRec.name<>'..') and
     (SearchRec.Attr<>faDirectory) then
      fnList.Add(sPath+SearchRec.Name);
    found:=FindNext(SearchREc);
  end;
  fnList.EndUpdate;
  FindClose(SearchRec);
end;

procedure TMain.btn_InitLocalDirClick(Sender: TObject);
var
  sPath,sClassName,sDir:string;
begin
  if MessageBox(Handle, PChar('���Ҫ�������еĵ�Ӱ����Ŀ¼�𣿡���'),
    'ϵͳ��ʾ', MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDNO then
  begin
    Exit;
  end;
  qry_Class.First;
  while not qry_Class.Eof do
  begin
    mi_CreateLocalDirClick(Self);
    qry_Class.Next;
  end;
end;

procedure TMain.btn_InitUrlClick(Sender: TObject);
var
  sUrl,sDir,sName:string;
begin
  if MessageBox(Handle, '���Ҫ�������еĵ�Ӱ���������Ŀ¼�𣿡���', 'ϵͳ��ʾ', MB_YESNO +
    MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDNO then
  begin
    Exit;
  end;

  qry_class.First;
  while not qry_class.Eof do
  begin
    CreateVirualDir(False);
    qry_class.Next;
  end;
  MessageBox(Handle, '����Ŀ¼�����ɹ�������', 'ϵͳ��ʾ',
    MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
end;

procedure TMain.btn_OKClick(Sender: TObject);
var
  iResult: Integer;
begin
  if Application.MessageBox('��Ŀ�ʼ������ӵ�Ӱ�𣿡���', '������ʾ',
    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDNO then
  begin
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  btn_OK.Enabled := False;
  //DBGridEh1.SaveBookmark;
  //qry_class.DisableControls;
  DEF_IMAGE := edt_Image.Text;
  mmo2.Lines.Clear;
  iResult := 0;
  try
    qry_class.First;
    while not qry_class.Eof do
    begin
      UpdateMovieByMovieClass(iResult);
      qry_class.Next;
    end; //end while not eof do ...

    if chk_Delete.Checked then
    begin
       DeleteMovie;
       ReadImageFileFromDownLoad;
    end;
  finally
    //DBGridEh1.RestoreBookmark;
    //qry_class.EnableControls;
    Screen.Cursor := crDefault;
    Application.MessageBox(PChar('�����ɣ����ι����/������'+IntToStr(iResult)+'����Ӱ������'),
      '������ʾ', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
    btn_OK.Enabled := True;
  end;
end;

procedure TMain.btn_TestClick(Sender: TObject);
begin
  try
    ADOConnection1.Close;
    ADOConnection1.ConnectionString := GetConnStr;
    ADOConnection1.Connected := True;
    Application.MessageBox('���ݿ���������ӳɹ�������', '������ʾ', MB_OK + 
      MB_ICONINFORMATION + MB_TOPMOST);
    FormCreate(Self);
  Except
    Application.MessageBox('���ݿ�����ʧ�ܣ���������ԣ�����', '������ʾ',
      MB_OK + MB_ICONSTOP + MB_TOPMOST);
  end;
end;

procedure TMain.btn_UpdateSrvUrlClick(Sender: TObject);
var
  qry_Temp:TADOQuery;
  New_SrvUrl:string;
begin
  if Application.MessageBox('���Ҫ�����ݿ�������ص�ӰƬURL��Ϣ�𣿡���',
    '������ʾ', MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDNO then
  begin
    Exit;
  end;

  New_SrvUrl := edt_SrvUrl.Text;

  qry_Temp := TADOQuery.Create(nil);
  qry_Temp.Connection := ADOConnection1;
  try
    qry_Temp.Close;
    qry_Temp.sql.Text := 'Update adnim_url set url_intro=replace(url_intro,'+quotedstr(Old_SrvUrl)+','+quotedstr(New_SrvUrl)+')';
    qry_Temp.ExecSQL;

    qry_Temp.Close;
    qry_Temp.sql.Text := 'Update adnim_class set class_url=replace(class_url,'+quotedstr(Old_SrvUrl)+','+quotedstr(New_SrvUrl)+')';
    qry_Temp.ExecSQL;

    qry_class.Close;
    qry_class.Open;

    WriteIntoIni;
    Old_SrvUrl := edt_SrvUrl.Text;
  finally
    qry_Temp.Free;
  end;
end;

procedure TMain.chk_LocalClick(Sender: TObject);
begin
  //edt_db.Enabled := not chk_Local.Checked;
  Edt2.Enabled := not chk_Local.Checked;
  Edt3.Enabled := not chk_Local.Checked;
end;

function TMain.CreateVirDir(const sUrl, sDir, sName: string): Boolean;
begin
  if CnIISCtrl1.CheckVirtualDir(sUrl) then
  begin
    Result := CnIISCtrl1.DeleteVirtualDir(sUrl);
    if not Result then Exit;
  end;
  Result := CnIISCtrl1.CreateVirtualDir(sUrl,sDir,sName);
end;

procedure TMain.CreateVirualDir(const ShowConfirmBox: Boolean);
var
  sUrl,sDir,sName:string;
begin
  sUrl := qry_class.FieldByName('class_dir').AsString;
  sDir := qry_class.FieldByName('class_localdir').AsString;
  sName := qry_class.FieldByName('class_name').AsString;
  if ShowConfirmBox then
    if MessageBox(Handle, PChar('���Ҫ������Ӱ���ࡾ'+sName+'��������Ŀ¼�𣿡���'), 'ϵͳ��ʾ', MB_YESNO +
      MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDNO then
    begin
      Exit;
    end;

  if CnIISCtrl1.CheckVirtualDir(sUrl) then
  begin
    if ShowConfirmBox then
      if (MessageBox(Handle, '����Ŀ¼�Ѵ��ڣ�Ҫɾ����ǰ����Ŀ¼�𣿡���', 'ϵͳ��ʾ', MB_YESNO +
        MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDNO) then
      begin
        Exit;
      end;
    if not CnIISCtrl1.DeleteVirtualDir(sUrl) then
    begin
      MessageBox(Handle, '����Ŀ¼ɾ��ʧ�ܣ���������ԣ�����', 'ϵͳ��ʾ',
        MB_OK + MB_ICONSTOP + MB_DEFBUTTON2 + MB_TOPMOST);
      Exit;
    end;
  end;
  if not CnIISCtrl1.CreateVirtualDir(sUrl,sDir,sName) then
  begin
    MessageBox(Handle, '����Ŀ¼����ʧ�ܣ���������ԣ�����', 'ϵͳ��ʾ',
      MB_OK + MB_ICONSTOP + MB_DEFBUTTON2 + MB_TOPMOST);
  end
  else if ShowConfirmBox then
  begin
    MessageBox(Handle, '����Ŀ¼�����ɹ�������', 'ϵͳ��ʾ',
      MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
  end;
end;

procedure TMain.DBGridEh1Columns2EditButtonClick(Sender: TObject;
  var Handled: Boolean);
var
  root,dir:String;
begin
  dir := qry_class.FieldByName('class_localdir').AsString;
  if SelectFolder('��ѡ���Ӱ�������ڵ�Ŀ¼',root,dir) then
  begin
    qry_class.Edit;
    qry_class.FieldByName('class_localdir').AsString := dir;
    qry_class.Post;
  end;
  mi_CreateLocalDirClick(Self);
end;

procedure TMain.DBGridEh1Columns2EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
  CreateVirualDir(True);
end;

procedure TMain.DBGridEh1Columns2UpdateData(Sender: TObject; var Text: string;
  var Value: Variant; var UseText, Handled: Boolean);
begin
  if (qry_class.FieldByName('class_dir').AsString<>Text) then
  begin
    qry_class.FieldByName('class_url').AsString := edt_SrvUrl.Text+Text+'/';
  end;
end;

procedure TMain.DeleteMovie(const isHint:Boolean=False);
var
  qry_Temp,qry_Delete:TADOQuery;
  data_dir,data_id,sfn:string;
begin
  if isHint then
    if Application.MessageBox('���Ҫɾ����Ч��ӰƬ��Ϣ�𣿡���',
      '������ʾ', MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDNO then
    begin
      Exit;
    end;

  qry_Temp := TADOQuery.Create(nil);
  qry_Delete := TADOQuery.Create(nil);
  qry_Temp.Connection := ADOConnection1;
  qry_Delete.Connection := ADOConnection1;
  try
    qry_Temp.Close;
    qry_Temp.sql.Text := 'select data_id,data_dir from view_adnim_data';// where server_id='+inttostr(SrvId)+'|';
    qry_Temp.Open;
    qry_Temp.Last;
    while not qry_Temp.Bof do
    begin
      data_id := qry_Temp.fieldByname('data_id').Asstring;
      data_dir := qry_Temp.fieldByname('data_dir').Value; //��ӰĿ¼��������һ���ϳ��ֶ�
      data_dir := ReplaceText(data_dir,'\\','\');

      Application.ProcessMessages;
      if not DirectoryExists(data_dir) then
      begin
        qry_Delete.Close;
        qry_Delete.SQL.Text := 'delete from adnim_url where data_id='+data_id;
        qry_Delete.ExecSQL;

        qry_Temp.Delete;

      end else
        qry_Temp.Prior;
    end;
  finally
    qry_Temp.Free;
    qry_Delete.Free;
  end;
end;

procedure TMain.edt_ImageChange(Sender: TObject);
begin
  DEF_IMAGE := edt_Image.Text;
  WriteIntoIni;
end;

procedure TMain.edt_PathChange(Sender: TObject);
begin
  WriteIntoIni;
end;

procedure TMain.edt_SrvUrlChange(Sender: TObject);
begin
  //WriteIntoIni;
  if Self.Showing then
    btn_UpdateSrvUrl.Enabled := edt_SrvUrl.Text<>Old_SrvUrl;
end;

procedure TMain.edt_SrvUrlExit(Sender: TObject);
begin
  if RightStr(edt_SrvUrl.Text,1)<>'/' then
    edt_SrvUrl.Text := edt_SrvUrl.Text+'/';
end;

procedure TMain.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
  var Resize: Boolean);
begin
  Resize := False;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  ReadFromIni;
  Old_SrvUrl := edt_SrvUrl.Text;
  ADOConnection1.Close;
  ADOConnection1.ConnectionString := GetConnStr;
  InitVodSrvID;
  InitVodClass;
end;

function TMain.GetTypeID(const sDirName: string): Integer;
begin
end;

function TMain.GetConnStr: string;
begin
  //Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=webplayer9;Data Source=.
  if chk_Local.Checked then
    Result := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog='+edt_db.Text+';Data Source='+Edt1.Text
  else
    Result := 'Provider=SQLOLEDB.1;Password='+Edt3.Text+';Persist Security Info=False;User ID='+Edt2.Text+';Initial Catalog='+edt_db.Text+';Data Source='+Edt1.Text;
end;

function TMain.GetFileType(const fn: string): string;
var
  extfn:String;
begin
  extfn := LowerCase(ExtractFileExt(fn));
  if extfn[1]='.' then
     Result := Copy(extfn,2,Length(extfn)-1)
  else
    Result := extfn;
end;

function TMain.GetImageName(const MovieName: string): string;
var
  sUrl,ImageName,fn:string;
begin
  sUrl := LowerCase(edt_SrvUrl.Text);
  if sUrl[Length(sUrl)]<>'/' then
    sUrl := sUrl+'/';
  sUrl := sUrl+ReplaceText(CONST_IMAGE_DIR,'\','/');
  if Copy(sUrl,1,7)<>'http://' then
    sUrl := 'http://'+sUrl;
  //Result := sUrl+ExtractFileName(fn);
  fn := ExtractFilePath(ParamStr(0))+CONST_IMAGE_DIR+MovieName;
  if FileExists(fn+'.jpg') then
     ImageName := fn+'.jpg'
  else if FileExists(fn+'.gif') then
     ImageName := fn+'.gif'
  else if FileExists(fn+'.bmp') then
     ImageName := fn+'.bmp'
  else if FileExists(fn+'.png') then
     ImageName := fn+'.png';

  if ImageName='' then
    Result := DEF_IMAGE
  else
    Result := sUrl+ExtractFileName(ImageName);
end;

function TMain.GetMovieIntro(const fn: string): string;
var
  sl:TStrings;
begin
  sl := TStringList.Create;
  try
    if FileExists(fn) then
       sl.LoadFromFile(fn);
    Result := sl.Text;
    if Result<>'' then
      Result := '<span>'+Result+'</span>';
  finally
    sl.Free;
  end;
end;

function TMain.GetMovieID(const sClassName: string): Integer;
begin
  with qry_Temp do
  begin
    try
      Close;
      //sql.Text := 'select Type_ID from TypeInfo where (charindex(TypeName,'+quotedstr(sDirName)+')>0) and ParentID<>0';
      sql.Text := 'select class_id from adnim_class where TypeName='+quotedstr(sClassName);
      Open;
      if Fields[0].IsNull then
         Result := -1
      else
        Result := Fields[0].AsInteger;
    finally
      Close;
    end;
  end;
end;

function TMain.GetMovieName(const fn: string): string;
var
  i:Integer;
  s:string;
begin
  s := trim(fn);
  if s[Length(s)]='\' then
    s := Copy(s,1,Length(s)-1);

  while Pos('\',s)>0 do
  begin
    i := Pos('\',s);
    s := Copy(s,i+1,Length(s)-i);
  end;
  Result := s;
end;

function TMain.GetMovieUrl(const sFileName: string): string;
begin
end;

function TMain.GetVodSrvID: Integer;
var
  str:string;
begin
  str := cbb_Srv.Text;
  Result := StrtoIntDef(Copy(str,1,Pos('|',str)-1),14);
end;

procedure TMain.InitVodClass;
var
  sqlStr:String;
begin
  sqlStr := 'SELECT * from adnim_class order by class_orderid';
  try
    qry_class.Close;
    qry_class.sql.Text := sqlStr;
    qry_class.Open;
  except
  end;
end;

procedure TMain.InitVodSrvID;
var
  sqlStr:String;
  qry_Temp:TADOQuery;
begin
  sqlStr := 'SELECT server_id,server_name from adnim_server order by server_orderid';
  qry_Temp := TADOQuery.Create(nil);
  qry_Temp.Connection := ADOConnection1;
  try
    try
      qry_Temp.Close;
      qry_Temp.sql.Text := sqlStr;
      qry_Temp.Open;
      cbb_Srv.Items.Clear;
      while not qry_Temp.Eof do
      begin
        sqlStr := qry_Temp.FieldByName('Server_ID').AsString+'|'+qry_Temp.FieldByName('Server_Name').AsString;
        cbb_Srv.Items.Add(sqlStr);
        qry_Temp.Next;
      end;
      if cbb_Srv.Items.Count>0 then
         cbb_Srv.ItemIndex := cbb_Srv.Items.Count-1;
    except
    end;
  finally
    qry_Temp.Close;
    qry_Temp.Free;
  end;
end;

function TMain.IsImageFile(const fn: string): Boolean;
var
  extfn:String;
begin
  extfn := LowerCase(ExtractFileExt(fn));
  Result := (extfn = '.jpg') or
            (extfn = '.jpeg') or
            (extfn = '.gif') or
            (extfn = '.png') or
            (extfn = '.bmp');
end;

function TMain.IsMovieFile(const fn: string): Boolean;
var
  extfn:String;
begin
  extfn := LowerCase(ExtractFileExt(fn));
  Result := (extfn = '.rmvb') or
            (extfn = '.rm') or
            (extfn = '.mov') or
            (extfn = '.mkv') or
            (extfn = '.avi') or
            (extfn = '.flv');
end;

function TMain.IsTxtFile(const fn: string): Boolean;
var
  extfn:String;
begin
  extfn := LowerCase(ExtractFileExt(fn));
  Result := (extfn = '.txt') or
            (extfn = '.csv') or
            (extfn = '.cvs') or
            (extfn = '.scv');
end;

procedure TMain.mi_AllowEditClick(Sender: TObject);
begin
  mi_AllowEdit.Checked := not mi_AllowEdit.Checked;
  if mi_AllowEdit.Checked then
  begin
    DBGridEh1.ReadOnly := False;
    DBGridEh1.Options := DBGridEh1.Options+[dgEditing];
  end else
  begin
    DBGridEh1.ReadOnly := True;
    DBGridEh1.Options := DBGridEh1.Options-[dgEditing];
  end;
end;

procedure TMain.mi_CreateLocalDirClick(Sender: TObject);
var
  sDir:string;
begin
  sDir := qry_Class.FieldByName('class_localdir').AsString;
  if not DirectoryExists(sDir) then
    ForceDirectories(sDir);
end;

procedure TMain.mi_CreateVirualDirClick(Sender: TObject);
begin
  CreateVirualDir(True);
end;

procedure TMain.mi_DeleteErrorMovieClick(Sender: TObject);
begin
  DeleteMovie(True);
end;

procedure TMain.mi_UpdateMovieClick(Sender: TObject);
var
  iResult :Integer;
begin
  if Application.MessageBox('���Ҫ����/��ӵ�ǰ�����µĵ�Ӱ�𣿡���', '������ʾ',
    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDNO then
  begin
    Exit;
  end;
  UpdateMovieByMovieClass(iResult);
  Application.MessageBox(PChar('�����ɣ����ι����/������'+IntToStr(iResult)+'����Ӱ������'),
    '������ʾ', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
end;

procedure TMain.ReadFromIni;
var
  fn :string;
begin
  fn := ExtractFilePath(ParamStr(0))+'AppSet.INI';

  With TIniFile.Create(fn) do
  begin
    try
      //Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=webplayer9;Data Source=.
      Edt1.Text := ReadString('DBSET','DB_HOST',Edt1.Text);
      edt_db.Text := ReadString('DBSET','DB_NAME',edt_db.Text);
      Edt2.Text := ReadString('DBSET','DB_SA',Edt2.Text);
      Edt3.Text := ReadString('DBSET','DB_PWD',Edt3.Text);
      chk_Local.Checked := ReadString('DBSET','CONN_MODE','WIN') = 'WIN';
      edt_SrvUrl.Text := ReadString('OTHERSET','VOD_SRVURL',edt_SrvUrl.Text);
      edt_Image.Text := ReadString('OTHERSET','DEF_IMAGE',edt_Image.Text);
    finally
      Free;
    end;
  end;
end;

procedure TMain.ReadImageFileFromDownLoad;
var
  qry_Temp:TADOQuery;
  sfn,MovieName,ImageName,MovieDir:String;
begin
  qry_Temp := TADOQuery.Create(nil);
  qry_Temp.Connection := ADOConnection1;
  ProgressBar1.Percent := 0;
  try
    qry_Temp.Close;
    qry_Temp.sql.Text := 'select data_name,data_dir,data_picurl from view_adnim_data';
    qry_Temp.Open;
    while not qry_Temp.Eof do
    begin
      MovieName := qry_Temp.Fields[0].AsString;
      MovieDir := qry_Temp.Fields[1].AsString;
      ImageName := qry_Temp.Fields[2].AsString;
      ImageName := MovieName+ExtractFileExt(ImageName);
      sfn := MovieDir+'\'+ImageName;
      sfn := ReplaceText(sfn,'\\','\');
      ImageName := ExtractFilePath(ParamStr(0))+CONST_IMAGE_DIR+ImageName;
      if FileExists(ImageName) and (not FileExists(sfn)) then
        CopyFile(PChar(ImageName),PChar(sfn),False);
      ProgressBar1.Percent := Trunc((qry_Temp.RecNo*100.0)/qry_Temp.RecordCount);
      Application.ProcessMessages;
      qry_Temp.Next;
    end;
  finally
    qry_Temp.Free;
  end;
end;

function GetWebSitePath(const virDir:string):string;
const
  iWebSiteIndex:Integer=1;
var
  WebSite, WebServer, WebRoot: Variant;
  sVirDir:string;
begin
  try
    sVirDir := LowerCase(virDir);
    if LeftStr(sVirDir,1)='/' then
      sVirDir := Copy(sVirDir,2,Length(sVirDir)-1);
    if RightStr(sVirDir,1)='/' then
      sVirDir := Copy(sVirDir,1,Length(sVirDir)-1);

    if sVirDir='' then
      sVirDir := 'root';

    if (sVirDir<>'root') and (LeftStr(sVirDir,5)<>'root/') then
      sVirDir := 'Root/'+sVirDir;

    WebSite :=CreateOLEObject('IISNamespace');
    WebSite := WebSite.GetObject('IIsWebService', 'localhost/w3svc');
    WebServer := WebSite.GetObject('IIsWebServer', IntToStr(iWebSiteIndex));
    //WebRoot := WebServer.GetObject('IIsWebVirtualDir', 'Root');
    WebRoot := WebServer.GetObject('IIsWebVirtualDir', sVirDir);
    Result := WebRoot.Path; //����ǵ�ַ,C\Inetpub\wwwroot ��D:\Inetpub\wwwroot
  except
    Result := '';
  end;
end;

procedure TMain.TabSheet3DblClick(Sender: TObject);
begin
  Caption := GetWebSitePath('zy');
end;

procedure TMain.UpdateMovie(const SrvID,ClassID:Integer;const aClassName,MovieName,MovieIntro,PhotoName,UrlStr:string);
  function MovieIsExists:Integer;//��Ӱ�Ƿ���ڣ�
  var
    qry_Temp:TADOQuery;
  begin
    qry_Temp := TADOQuery.Create(nil);
    qry_Temp.Connection := ADOConnection1;
    try
      qry_Temp.Close;
      qry_Temp.sql.Text := 'select data_id from adnim_data where class_id='+IntTostr(ClassID)+
                  ' and data_name='+quotedstr(MovieName);
      qry_Temp.Open;
      if qry_Temp.Fields[0].IsNull then
         Result := -1
      else
        Result := qry_Temp.Fields[0].AsInteger;
    finally
      qry_Temp.Close;
      qry_Temp.Free;
    end;
  end;

  function GetNewMovieID:Integer;//ȡ���µ�Ӱ��ID��
  var
    qry_Temp:TADOQuery;
  begin
    qry_Temp := TADOQuery.Create(nil);
    qry_Temp.Connection := ADOConnection1;
    try
      qry_Temp.Close;
      qry_Temp.sql.Text := 'select max(data_id) from adnim_data';
      qry_Temp.Open;
        Result := qry_Temp.Fields[0].AsInteger+1;
    finally
      qry_Temp.Close;
      qry_Temp.Free;
    end;
  end;

  function GetNewMovieFileID:Integer;//ȡ���µ�Ӱ�ļ��е�ID��
  var
    qry_Temp:TADOQuery;
  begin
    qry_Temp := TADOQuery.Create(nil);
    qry_Temp.Connection := ADOConnection1;
    try
      qry_Temp.Close;
      qry_Temp.sql.Text := 'select max(url_id) from adnim_url';
      qry_Temp.Open;
      Result := qry_Temp.Fields[0].AsInteger+1;
    finally
      qry_Temp.Close;
      qry_Temp.Free;
    end;
  end;

  function MovieFileIsExists(const data_id:Integer):Integer;//ӰƬ�ļ��Ƿ����
  var
    qry_Temp:TADOQuery;
  begin
    qry_Temp := TADOQuery.Create(nil);
    qry_Temp.Connection := ADOConnection1;
    try
      qry_Temp.Close;
      qry_Temp.sql.Text := 'select url_id from adnim_url where data_id='+inttostr(data_id)+
                  ' and server_id='+Inttostr(SrvID);
      qry_Temp.Open;
      if qry_Temp.Fields[0].IsNull then
         Result := -1
      else
        Result := qry_Temp.Fields[0].AsInteger;
    finally
      qry_Temp.Close;
      qry_Temp.Free;
    end;
  end;

var
  sqlstr,language:string;
  i,data_id,IDN:Integer;
begin
  data_id := MovieIsExists;  //ӰƬ�Ƿ����
  if (aClassName='������') or (aClassName='��̨��') then
    language := '����'
  else
    language := 'Ӣ��';
  
  if (data_id=-1) then //��Ӱ������
  begin
    data_id := GetNewMovieID; //�õ���ӰƬid
    sqlstr := 'Insert into adnim_data (data_id,'+
                                    'server_id,'+
                                    'class_id,'+
                                    'data_name,'+
                                    'data_actor,'+
                                    'data_erea,'+
                                    'data_picurl,'+
                                    'data_intro,'+
                                    'data_lastdate,'+
                                    'data_hits,'+
                                    'data_elite,'+
                                    'data_status,'+
                                    'data_language)'+
                           ' values(:data_id,'+
                                   ':server_id,'+
                                   ':class_id,'+
                                   ':data_name,'+
                                   quotedstr('����ϸ����')+','+
                                   quotedstr('δ֪')+','+
                                   ':data_picurl,'+
                                   ':data_intro,'+
                                   'getdate(),'+
                                   '0,'+
                                   '0,'+
                                   '1,'+
                                   quotedStr(language)+')';
    with qry_ProgInfo do
    begin
      Close;
      sql.Text := sqlstr;
      Prepared := True;
      Parameters.ParamValues['data_id'] := data_id;
      Parameters.ParamValues['server_id'] := SrvID;
      Parameters.ParamValues['class_id'] := ClassID;
      Parameters.ParamValues['data_name'] := MovieName;
      //
      Parameters.ParamValues['data_picurl'] := PhotoName;
      Parameters.ParamValues['data_intro'] := MovieIntro;

      ExecSQL;
    end;
  end  // end if
  else begin
    sqlstr := 'update adnim_data set server_id=:server_id,'+
                                  'class_id=:class_id,'+
                                  'data_picurl=:data_picurl,'+
                                  'data_intro=:data_intro,'+
                                  'data_language='+quotedstr(language)+
              ' where data_id='+InttoStr(data_id);
    with qry_ProgInfo do
    begin
      Close;
      sql.Text := sqlstr;
      Prepared := True;
      Parameters.ParamValues['server_id'] := SrvID;
      Parameters.ParamValues['class_id'] := ClassID;
      //
      Parameters.ParamValues['data_picurl'] := PhotoName;
      Parameters.ParamValues['data_intro'] := MovieIntro;

      ExecSQL;
    end;
  end;

  IDN := MovieFileIsExists(data_id);

  if IDN=-1 then //��Ӱ������
  begin
    IDN := GetNewMovieFileID;
    sqlstr := 'Insert into adnim_url (url_id,data_id,server_id,url_intro) '+
              'Values('+Inttostr(IDN)+',:data_id,:server_id,:url_intro)';
  end else
  begin
    sqlstr := 'update adnim_url set data_id=:data_id,server_id=:server_id,url_intro=:url_intro '+
              ' where url_id='+IntToStr(IDN);
  end;
  with qry_Prog_Server do
  begin
    Close;
    sql.Text := sqlstr;
    Prepared := True;
    Parameters.ParamValues['data_id'] := data_id;
    Parameters.ParamValues['server_id'] := SrvID;
    Parameters.ParamValues['url_intro'] := Urlstr;
    ExecSQL;
  end;

end;

procedure TMain.UpdateMovieByMovieClass(var iResult:Integer); //�����ļ��У�����Ŀ¼��
var
  MovieList,MovieFileList,fnList:TStrings;
  i,ii,iCount:integer;
  fn,fnstr,MovieName,MovieIntro,ImageName:string;
  SrvID,ClassID:Integer;
  aClassName,
  ClassLocalDir,ClassVirualDir:String;
begin
  Screen.Cursor := crHourGlass;

  SrvID := GetVodSrvID;
  ClassID := qry_class.FieldByName('class_id').AsInteger; //�õ��磺�ƻ�Ƭ������Ƭ�ȵ�ID��
  aClassName := qry_class.FieldByName('class_name').AsString; //�õ��磺�ƻ�Ƭ������Ƭ��
  ClassLocalDir := qry_class.FieldByName('class_localdir').AsString;
  ClassVirualDir := qry_class.FieldByName('class_url').AsString;

  MovieList := TStringList.Create;
  MovieFileList := TStringList.Create;
  fnList := TStringList.Create;
  try
    GetDir(ClassLocalDir,MovieList); //�õ���ǰ��Ӱ�����µĵ�Ӱ�ļ��У�����Ӱ����

    ProgressBar1.Percent := 0;
    for i := 0 to MovieList.Count - 1 do
    begin
      fnList.Clear;
      GetFile(MovieList[i],fnList); //�õ�ĳһ��Ӱ�ļ����µ������ļ��б�

      MovieName := GetMovieName( MovieList[i]);  //�ֽ��ȡ��Ӱ����

      ImageName := '';
      MovieIntro := '';
      MovieFileList.Clear;
      for ii := 0 to fnList.Count - 1 do //��Ӱ�ļ����еĵ�Ӱ�ļ��������ļ���ͼƬ��
      begin
        fn := fnList.Strings[ii];
        if IsMovieFile(fn) then
           MovieFileList.Add(fn)
        else if IsImageFile(fn) and (ImageName='') then
        begin //�������������ͼƬ���ڴ˴�����Copy��һ������ͼƬ�ļ�����ȥ
           ImageName := ExtractFilePath(ParamStr(0))+CONST_IMAGE_DIR;
           if not DirectoryExists(ImageName) then
              ForceDirectories(ImageName);
           ImageName := ImageName+MovieName+ExtractFileExt(fn);//ExtractFileName(fn);
           if not FileExists(ImageName) then
              CopyFile(PChar(fn),PChar(ImageName),False);
        end
        else if IsTxtFile(fn) and (MovieIntro='') then
           MovieIntro := GetMovieIntro(fn);
      end;
      ImageName := GetImageName(MovieName);

      fnstr := '';
      for iCount := 0 to MovieFileList.Count - 1 do
      begin
        fn := ReplaceText(MovieFileList[iCount],MovieList[i],ClassVirualDir+MovieName+'/');
        fn := ReplaceText(fn,'/\','/');
        fn := ReplaceText(fn,'\','/');
        if fnstr<>'' then
          fnstr := fnstr+'$$$';
        if MovieFileList.Count=1 then
          fnstr := fn
        else
          fnstr := fnstr+Format('��%.2d��|%s',[iCount+1,fn]);
        Application.ProcessMessages;
        Inc(iResult);
      end;
      if fnstr<>'' then
        UpdateMovie(SrvID,ClassId,aClassName,MovieName,MovieIntro,ImageName,fnstr);

      ProgressBar1.Percent := Trunc((i+1)*100.0/MovieList.Count);
      ProgressBar1.Update;
      Application.ProcessMessages;

    end; //end for i=0 to ....
  finally
    MovieList.Free;
    MovieFileList.Free;
    fnList.Free;
    Screen.Cursor := crDefault;
  end;

end;

procedure TMain.WriteIntoIni;
var
  fn :string;
begin
  fn := ExtractFilePath(ParamStr(0))+'AppSet.INI';

  With TIniFile.Create(fn) do
  begin
    try
      //Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=webplayer9;Data Source=.
      WriteString('DBSET','DB_HOST',Edt1.Text);
      WriteString('DBSET','DB_NAME',edt_db.Text);
      WriteString('DBSET','DB_SA',Edt2.Text);
      WriteString('DBSET','DB_PWD',Edt3.Text);
      if chk_Local.Checked then
         WriteString('DBSET','CONN_MODE','WIN')
      else
         WriteString('DBSET','CONN_MODE','SQL');
      WriteString('OTHERSET','VOD_SrvUrl',edt_SrvUrl.Text);
      WriteString('OTHERSET','DEF_IMAGE',edt_Image.Text);
    finally
      Free;
    end;
  end;
end;

end.
