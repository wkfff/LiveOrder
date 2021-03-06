unit ufrmLogisticIn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmDBBasicPrn, PropFilerEh, ActnList, PrnDbgeh, ImgList, DB,
  ADODB, Menus, PropStorageEh, DBCtrls, ComCtrls, ToolWin, GridsEh,
  DBGridEh, PrViewEh, StdCtrls, ExtCtrls,
  uDMEntity, uDMManager;

type
  TfrmLogisticIn = class(TfrmDBBasicPrn)
    N2: TMenuItem;
    MenuBatchEdtLogisticIn: TMenuItem;
    tbtnRefresh: TToolButton;
    procedure tbtnRefreshClick(Sender: TObject);
    procedure MenuBatchEdtLogisticInClick(Sender: TObject);
  private
    { Private declarations }
    objMgrBasic: TMgrBasicData;
    slParam: TStringList;
    objMgrTO: TMgrTradingOrder;
  protected
    procedure InitializeForm; override;
    procedure DestoryForm; override;
    procedure SetData; override;
    procedure SetUI; override;
    procedure SetAccess; override;
  public
    { Public declarations }
  end;

implementation

uses DataModule, ufrmBatchEdtLogisticIn, ufrmDBBasic;

{$R *.dfm}

{ TfrmLogisticIn }

procedure TfrmLogisticIn.InitializeForm;
begin
  objMgrBasic := TMgrBasicData.Create;
  objMgrTO := TMgrTradingOrder.Create;
  slParam := TStringList.Create;
  inherited;
end;

procedure TfrmLogisticIn.DestoryForm;
begin
  inherited;
  slParam.Free;
  objMgrBasic.Free;
  objMgrTO.Free;
end;

procedure TfrmLogisticIn.SetData;
begin
  inherited;
  if objCurUser.AccessLevel = 16 then
  begin
    DM.DataSetQuery(adt_active, 'select * from ViewLogisticIn'
      + ' where TradingOrderStatusID in (1,2,3,4,5,6) And PlantID in (3,4,5)'
      + ' and CustomerOrderStatesID in (1,2,3,4,5)'
      + ' and Upper(left(ImportSheetNo,1))=''T'''
      + ' and ltrim(rtrim(SellerInvoiceNumber)) is null'
      + ' and ltrim(rtrim(SellerInvoiceDate)) is null'
      + ' order by TradingOrderID');
  end
  else
  begin
    slParam.Clear;
    slParam.Append('TradingOrderStatusID=1,2,3,4,5,6');
    slParam.Append('PlantID=3,4,5');
    slParam.Append('CustomerOrderStatesID=1,2,3,4,5');
    objMgrBasic.QueryBasicDataByParam(adt_active, 'ViewLogisticIn', 'TradingOrderID', slParam);
  end;
end;

procedure TfrmLogisticIn.SetUI;
begin
  inherited;

end;

procedure TfrmLogisticIn.SetAccess;
begin
  inherited;
  gridData.FieldColumns['Price'].Visible := false;
  gridData.FieldColumns['TotalAmount'].Visible := false;
  gridData.FieldColumns['DemandManagingSalesMonth'].Visible := false;
  gridData.FieldColumns['DemandManagingDMMMonth'].Visible := false;
  gridData.FieldColumns['DemandManagingDMMRemark'].Visible := false;
  if objCurUser.AccessLevel in [1, 15, 16, 17, 23] then
    MenuBatchEdtLogisticIn.Visible := true;
  if objCurUser.AccessLevel in [17, 23] then
    gridData.FieldColumns['DemandManagingDMMRemark'].Visible := true;

  if objCurUser.AccessLevel in [1, 15] then
  begin
    gridData.FieldColumns['Price'].Visible := true;
    gridData.FieldColumns['TotalAmount'].Visible := true;
    gridData.FieldColumns['DemandManagingSalesMonth'].Visible := true;
    gridData.FieldColumns['DemandManagingDMMMonth'].Visible := true;
    gridData.FieldColumns['DemandManagingDMMRemark'].Visible := true;
  end;
end;

procedure TfrmLogisticIn.tbtnRefreshClick(Sender: TObject);
begin
  inherited;
  adt_active.Active := false;
  adt_active.Active := true;
end;

procedure TfrmLogisticIn.MenuBatchEdtLogisticInClick(Sender: TObject);
var
  BatchTOID, ReceivingScheduleID: string;
begin
  if not CheckIfSelectRows(gridData) then exit;
  BatchTOID := GetBatchFieldValueFromGrid(gridData, 'TradingOrderID');
  ReceivingScheduleID := GetBatchFieldValueFromGrid(gridData, 'ReceivingScheduleID');
  if ReceivingScheduleID = '' then
  begin
    ShowMessage('No receving schedule exsits. Please add receving schedule first.');
    exit;
  end;
  TfrmBatchEdtLogisticIn.EdtFromList(BatchTOID, ReceivingScheduleID);
  RefreshGrid(gridData, ds_active);
end;

end.

