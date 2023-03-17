report 50902 "Lista Carencias"
{
    DefaultLayout = Excel;
    ExcelLayout = './ProdOrderShortageList2.xlsx';
    ApplicationArea = Manufacturing;
    Caption = 'Lista Carencias 2';
    UsageCategory = ReportsAndAnalysis;
    Permissions =
        tabledata Item = R,
        tabledata "Prod. Order Component" = R,
        tabledata "Prod. Order Line" = R,
        tabledata "Production Order" = R;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.", "Date Filter";
            column(Today; Today)
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(Status_ProdOrder; Status)
            {
                IncludeCaption = false;
            }
            column(No_ProdOrder; "No.")
            {
                IncludeCaption = true;
            }
            column(Desc_ProdOrder; Description)
            {
                IncludeCaption = true;
            }
            column(DueDate_ProdOrder; "Due Date")
            {
            }
            column(ShortageListCaption; ShortageListCaptionLbl)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(NeededQtyCaption; NeededQtyCaptionLbl)
            {
            }
            column(MargenCaption; MargenCaptionLbl)
            {
            }
            column(FechaPedidoCaption; FechaPedidoCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(CompItemScheduledNeedQtyCaption; CompItemScheduledNeedQtyCaptionLbl)
            {
            }
            column(CompItemInventoryCaption; CompItemInventoryCaptionLbl)
            {
            }
            column(RemainingQtyBaseCaption; RemainingQtyBaseCaptionLbl)
            {
            }
            column(RemQtyBaseCaption; RemQtyBaseCaptionLbl)
            {
            }
            column(ReceiptQtyCaption; ReceiptQtyCaptionLbl)
            {
            }
            column(QtyonPurchOrderCaption; QtyonPurchOrderCaptionLbl)
            {
            }
            column(QtyonSalesOrderCaption; QtyonSalesOrderCaptionLbl)
            {
            }
            column(CodClienteCaption; CodClienteCaptionLbl)
            {

            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                PrintOnlyIfDetail = true;
                column(LineNo_ProdOrderLine; "Line No.")
                {
                }
                column(Item_No_; "Item No.")
                {

                }
                column(Description; Description)
                {

                }


                column(FromID; FromID)
                {

                }

                column(AmountSale; AmountSale)
                {

                }
                column(CodCliente; CodCliente)
                {

                }

                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
                    column(CompItemInventory; CompItem.Inventory)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(CompItemSchdldNeedQty; CompItem."Qty. on Component Lines")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(NeededQuantity; NeededQty)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(ItemNo_ProdOrderComp; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(CompItemInvRemQtyBase; QtyOnHandAfterProd)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(Desc_ProdOrderComp; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(CompItemSchdldRcptQty; CompItem."Scheduled Receipt (Qty.)")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(CompItemQtyonPurchOrder; CompItem."Qty. on Purch. Order")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(CompItemQtyonSalesOrder; CompItem."Qty. on Sales Order")
                    {

                        DecimalPlaces = 0 : 5;
                    }
                    column(RemQtyBase_ProdOrderComp; RemainingQty)
                    {
                        DecimalPlaces = 0 : 5;
                    }


                    dataitem(Item; "Item")
                    {
                        DataItemLink = "No." = FIELD("Item No.");
                        column(lead_time_calculation; "Lead Time Calculation")
                        {
                        }
                        column(Margen; Margen)
                        {
                        }

                        column(FechaPedido; FechaPedido)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            TempProdOrder: Record "Production Order" temporary;
                            TempProdOrderLine: Record "Prod. Order Line" temporary;
                            TempProdOrderComp: Record "Prod. Order Component" temporary;
                            TempItem: Record "Item" temporary;
                            LeadTime: Text;
                            Tipo: Integer;
                            Dias: Integer;
                        begin
                            LeadTime := Format(Item."Lead Time Calculation");
                            if LeadTime = '' then LeadTime := '4S';
                            if LeadTime.Contains('S') then begin
                                Tipo := 7;
                                Evaluate(Dias, LeadTime.Replace('S', ''));
                            end;
                            if LeadTime.Contains('M') then begin
                                Tipo := 30;
                                Evaluate(Dias, LeadTime.Replace('M', ''));
                            end;
                            if LeadTime.Contains('D') then begin
                                Tipo := 1;
                                Evaluate(Dias, LeadTime.Replace('D', ''));
                            end;
                            Margen := Tipo * Dias + 15;
                            FechaPedido := "Production Order"."Due Date" - Margen;

                        end;

                    }
                    trigger OnAfterGetRecord()
                    var
                        TempProdOrder: Record "Production Order" temporary;
                        TempProdOrderLine: Record "Prod. Order Line" temporary;
                        TempProdOrderComp: Record "Prod. Order Component" temporary;
                        TempItem: Record "Item" temporary;
                        LeadTime: Text;
                        Tipo: Integer;
                        Dias: Integer;

                    begin

                        // Se eliminan los filtros de almacén para evitar stock erroneos

                        SetRange("Item No.", "Item No.");
                        SetRange("Variant Code", "Variant Code");
                        //SetRange("Location Code", "Location Code");
                        FindLast();
                        SetRange("Item No.");
                        SetRange("Variant Code");
                        //SetRange("Location Code");

                        CompItem.Get("Item No.");
                        if CompItem.IsNonInventoriableType() then
                            CurrReport.Skip();

                        CompItem.SetRange("Variant Filter", "Variant Code");
                        //CompItem.SetRange("Location Filter", "Location Code");
                        //CompItem.SetRange(
                        //  "Date Filter", 0D, "Due Date" - 1);
                        CompItem.SetRange(
                         "Date Filter", 0D, "Due Date" - 1);
                        CompItem.CalcFields(
                          Inventory, "Reserved Qty. on Inventory",
                          "Scheduled Receipt (Qty.)", "Reserved Qty. on Prod. Order",
                          "Qty. on Component Lines", "Res. Qty. on Prod. Order Comp.");

                        CompItem.Inventory :=
                          CompItem.Inventory -
                          CompItem."Reserved Qty. on Inventory";
                        CompItem."Scheduled Receipt (Qty.)" :=
                          CompItem."Scheduled Receipt (Qty.)" -
                          CompItem."Reserved Qty. on Prod. Order";
                        CompItem."Qty. on Component Lines" :=
                          CompItem."Qty. on Component Lines" -
                          CompItem."Res. Qty. on Prod. Order Comp.";

                        // Se pone 1000 adicionales para que coja los pedidos posteriores a la fecha de vto. de la orden.
                        CompItem.SetRange(
                          "Date Filter", 0D, "Due Date" + 1000);
                        CompItem.CalcFields(
                          "Qty. on Sales Order", "Reserved Qty. on Sales Orders",
                          "Qty. on Purch. Order", "Reserved Qty. on Purch. Orders");
                        CompItem."Qty. on Sales Order" :=
                          CompItem."Qty. on Sales Order" -
                          CompItem."Reserved Qty. on Sales Orders";
                        CompItem."Qty. on Purch. Order" :=
                          CompItem."Qty. on Purch. Order" -
                          CompItem."Reserved Qty. on Purch. Orders";

                        TempProdOrderLine.SetCurrentKey(
                          "Item No.", "Variant Code", "Location Code", Status, "Ending Date");

                        TempProdOrderLine.SetRange(Status, TempProdOrderLine.Status::Planned, Status.AsInteger() - 1);
                        TempProdOrderLine.SetRange("Item No.", "Item No.");
                        TempProdOrderLine.SetRange("Variant Code", "Variant Code");
                        TempProdOrderLine.SetRange("Location Code", "Location Code");
                        TempProdOrderLine.SetRange("Due Date", "Due Date");
                        CalcProdOrderLineFields(TempProdOrderLine);
                        CompItem."Scheduled Receipt (Qty.)" :=
                          CompItem."Scheduled Receipt (Qty.)" +
                          TempProdOrderLine."Remaining Qty. (Base)" -
                          TempProdOrderLine."Reserved Qty. (Base)";

                        TempProdOrderLine.SetRange(Status, Status);
                        TempProdOrderLine.SetRange("Prod. Order No.", "Prod. Order No.");
                        CalcProdOrderLineFields(TempProdOrderLine);
                        CompItem."Scheduled Receipt (Qty.)" :=
                          CompItem."Scheduled Receipt (Qty.)" +
                          TempProdOrderLine."Remaining Qty. (Base)" -
                          TempProdOrderLine."Reserved Qty. (Base)";

                        TempProdOrderComp.SetCurrentKey(
                          "Item No.", "Variant Code", "Location Code", Status, "Due Date");

                        TempProdOrderComp.SetRange(Status, TempProdOrderComp.Status::Planned, Status.AsInteger() - 1);
                        TempProdOrderComp.SetRange("Item No.", "Item No.");
                        TempProdOrderComp.SetRange("Variant Code", "Variant Code");
                        TempProdOrderComp.SetRange("Location Code", "Location Code");
                        TempProdOrderComp.SetRange("Due Date", "Due Date");
                        CalcProdOrderCompFields(TempProdOrderComp);
                        CompItem."Qty. on Component Lines" :=
                          CompItem."Qty. on Component Lines" +
                          TempProdOrderComp."Remaining Qty. (Base)" -
                          TempProdOrderComp."Reserved Qty. (Base)";

                        TempProdOrderComp.SetRange(Status, Status);
                        TempProdOrderComp.SetFilter("Prod. Order No.", '<%1', "Prod. Order No.");
                        CalcProdOrderCompFields(TempProdOrderComp);
                        CompItem."Qty. on Component Lines" :=
                          CompItem."Qty. on Component Lines" +
                          TempProdOrderComp."Remaining Qty. (Base)" -
                          TempProdOrderComp."Reserved Qty. (Base)";

                        TempProdOrderComp.SetRange("Prod. Order No.", "Prod. Order No.");
                        TempProdOrderComp.SetRange("Prod. Order Line No.", 0, "Prod. Order Line No." - 1);
                        CalcProdOrderCompFields(TempProdOrderComp);
                        CompItem."Qty. on Component Lines" :=
                          CompItem."Qty. on Component Lines" +
                          TempProdOrderComp."Remaining Qty. (Base)" -
                          TempProdOrderComp."Reserved Qty. (Base)";

                        TempProdOrderComp.SetRange("Prod. Order Line No.", "Prod. Order Line No.");
                        TempProdOrderComp.SetRange("Item No.", "Item No.");
                        TempProdOrderComp.SetRange("Variant Code", "Variant Code");
                        TempProdOrderComp.SetRange("Location Code", "Location Code");
                        CalcProdOrderCompFields(TempProdOrderComp);
                        CompItem."Qty. on Component Lines" :=
                          CompItem."Qty. on Component Lines" +
                          TempProdOrderComp."Remaining Qty. (Base)" -
                          TempProdOrderComp."Reserved Qty. (Base)";

                        RemainingQty :=
                          TempProdOrderComp."Remaining Qty. (Base)" -
                          TempProdOrderComp."Reserved Qty. (Base)";

                        QtyOnHandAfterProd :=
                          CompItem.Inventory -
                          TempProdOrderComp."Remaining Qty. (Base)" +
                          TempProdOrderComp."Reserved Qty. (Base)";

                        NeededQty :=
                          CompItem."Qty. on Component Lines" +
                          CompItem."Qty. on Sales Order" -
                          CompItem."Qty. on Purch. Order" -
                          CompItem."Scheduled Receipt (Qty.)" -
                          CompItem.Inventory;

                        if NeededQty < 0 then
                            NeededQty := 0;

                        if (NeededQty = 0) and (QtyOnHandAfterProd >= 0) or
                           (RemainingQty = 0)
                        then
                            CurrReport.Skip();
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Due Date", "Production Order".GetFilter("Date Filter"));
                        SetFilter("Remaining Qty. (Base)", '>0');
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    OrderTrackingMgt: Codeunit OrderTrackingManagement;
                    OrderTrackingEntry: Record "Order Tracking Entry";
                    SalesLine: Record "Sales Line";
                    Customer: Record "Customer";
                    Item: Record Item;
                    documento: Text;
                begin
                    if not Item.Get("Item No.") then
                        Clear(Item);

                    OrderTrackingMgt.SetProdOrderLine("Prod. Order Line");
                    //OrderTrackingMgt.FindRecords();
                    OrderTrackingMgt.FindRecordsWithoutMessage();
                    OrderTrackingMgt.FindRecord('=>', OrderTrackingEntry);

                    FromID := OrderTrackingEntry."From ID";

                    documento := Format(FromID);
                    if documento.Contains('VP') then begin
                        SalesLine.SetRange("Document No.", FromID);
                        SalesLine.SetRange("No.", "Item No.");
                        if SalesLine.FindFirst() then begin
                            AmountSale := SalesLine.Amount;
                            CodCliente := SalesLine."Sell-to Customer No.";
                            Customer.SetRange("No.", CodCliente);
                        end else begin
                            AmountSale := 0;
                            CodCliente := '';
                        end
                    end else begin
                        AmountSale := 0;
                        CodCliente := '';
                    end;


                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        Status_ProdOrderCaption = 'Status';
    }

    var

        CompProdOrder: Record "Production Order";
        CompOrdLine: Record "Prod. Order Line";
        CompOrdComp: Record "Prod. Order Component";
        CompItem: Record Item;
        RemainingQty: Decimal;
        NeededQty: Decimal;
        Margen: Integer;
        FechaPedido: Date;
        FromID: Code[20];
        CodCliente: Code[20];
        AmountSale: Decimal;
        QtyOnHandAfterProd: Decimal;
        ShortageListCaptionLbl: Label 'Shortage List';
        PageNoCaptionLbl: Label 'Page';
        DueDateCaptionLbl: Label 'Due Date';
        CodClienteCaptionLbl: Label 'Código cliente';
        NeededQtyCaptionLbl: Label 'Needed Quantity';
        CompItemScheduledNeedQtyCaptionLbl: Label 'Scheduled Need';
        CompItemInventoryCaptionLbl: Label 'Quantity on Hand';
        RemainingQtyBaseCaptionLbl: Label 'Qty. on Hand after Production';
        RemQtyBaseCaptionLbl: Label 'Remaining Qty. (Base)';
        ReceiptQtyCaptionLbl: Label 'Scheduled Receipt';
        QtyonPurchOrderCaptionLbl: Label 'Qty. on Purch. Order';
        QtyonSalesOrderCaptionLbl: Label 'Qty. on Sales Order';
        MargenCaptionLbl: Label 'Margen';
        FechaPedidoCaptionLbl: Label 'Fecha Pedido';
        AmountCaptionLbl: Label 'Cantidad';
        Tipo: Label 'Tipo';
        Numero: Label 'Numero';
        Dias: Label 'Dias';
        ProdAprox: Label 'ProdAprox';
        Total: Label 'Total';


    local procedure CalcProdOrderLineFields(var ProdOrderLineFields: Record "Prod. Order Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        ProdOrderLine.Copy(ProdOrderLineFields);

        if ProdOrderLine.FindSet() then
            repeat
                ProdOrderLine.CalcFields("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderLine."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderLine."Reserved Qty. (Base)";
            until ProdOrderLine.Next() = 0;

        ProdOrderLineFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderLineFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;

    local procedure CalcProdOrderCompFields(var ProdOrderCompFields: Record "Prod. Order Component")
    var
        ProdOrderComp: Record "Prod. Order Component";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        ProdOrderComp.Copy(ProdOrderCompFields);

        if ProdOrderComp.FindSet() then
            repeat
                ProdOrderComp.CalcFields("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderComp."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderComp."Reserved Qty. (Base)";
            until ProdOrderComp.Next() = 0;

        ProdOrderCompFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderCompFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;
}

