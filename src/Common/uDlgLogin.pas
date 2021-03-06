unit uDlgLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ADODB, DB, uDMManager, uDMEntity;

type
  TLoginDlg = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    BtnLogin: TButton;
    BtnExit: TButton;
    adt_active: TADODataSet;
    adt_active2: TADODataSet;
    lblVersion: TLabel;
    Button1: TButton;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdtUsernameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginDlg: TLoginDlg;

implementation

uses uMJ;

{$R *.dfm}

procedure TLoginDlg.FormCreate(Sender: TObject);
begin
  caption := 'Login';
  Label1.Caption := Application.Title;
  lblVersion.Caption := 'Version: ' + mjGetBuildInfo;
end;

procedure TLoginDlg.FormShow(Sender: TObject);
begin
  EdtUsername.Text := '';
  EdtPassword.Text := '';
end;

procedure TLoginDlg.BtnExitClick(Sender: TObject);
begin
  close;
end;

procedure TLoginDlg.BtnLoginClick(Sender: TObject);
var
  objMgrCurUser: TMgrCurUser;
begin
  objMgrCurUser := TMgrCurUser.Create;
  try
    if not objMgrCurUser.LoginByDBAuth(trim(EdtUsername.Text), trim(EdtPassword.Text)) then
      exit
    else
      Close;
  finally
    objMgrCurUser.Free;
  end;
end;

procedure TLoginDlg.EdtUsernameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_down) or (key = 13) then
  begin
    self.EdtPassword.SetFocus;
  end;
end;

procedure TLoginDlg.EdtPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_down) or (key = 13) then
  begin
    self.BtnLoginClick(self);
  end;
end;

procedure TLoginDlg.Button1Click(Sender: TObject);
var
  List: TStringList;
  index: integer;
begin
  List := TStringList.Create;
  List.Add('aaa=111');
  List.Add('bbb=222');
  List.Add('ccc=333');
  List.Add('ddd=444');
  List.Add('dcdd');
  List.Sort;
  ShowMessage(IntToStr(List.IndexOf('dcdd'))); //3
  List.Find('ddd=444', index);
  ShowMessage(IntToStr(index)); //4
  ShowMessage(List.CommaText); //aaa=111,bbb=222,ccc=333,dcdd,ddd=444
  ShowMessage(List.Text);
  ShowMessage(List.Names[1]); //bbb
  ShowMessage(List.ValueFromIndex[1]); //222
  ShowMessage(List.Values['bbb']); //222
  //ValueFromIndex 可以赋值:
  List.ValueFromIndex[1] := '2';
  ShowMessage(List[1]); //bbb=2
  //可以通过 Values 赋值:
  List.Values['bbb'] := '22';
  ShowMessage(List[1]); //bbb=22
  ShowMessage(List.ValueFromIndex[3]); //cdd
  List.Free;
end;

end.

