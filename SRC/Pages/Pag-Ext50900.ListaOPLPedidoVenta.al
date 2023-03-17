pageextension 50900 "Lista OPL + Pedido Venta" extends "Released Production Orders"
{
    layout
    {
        // Adding a new control field 'ShoeSize' in the group 'General'
        addafter("Source No.")
        {
            field("Pedido venta"; PedidoVenta)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Procedencia';
                Description = 'Pedido de venta u orden lanzada relacionada';
                ToolTip = 'Specifies the level of reward that the customer has at this point.';
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        OrderTrackingMgt: Codeunit OrderTrackingManagement;
        OrderTrackingEntry: Record "Order Tracking Entry";
        ProdOrderLine: Record "Prod. Order Line";
        SalesLine: Record "Sales Line";
        Item: Record Item;
    begin
        if not Item.Get() then
            Clear(Item);

        ProdOrderLine.SetFilter("Prod. Order No.", Rec."No.");
        ProdOrderLine.FindFirst();
        OrderTrackingMgt.SetProdOrderLine(ProdOrderLine);
        OrderTrackingMgt.FindRecordsWithoutMessage();
        OrderTrackingMgt.FindRecord('=>', OrderTrackingEntry);

        FromID := OrderTrackingEntry."From ID";
        PedidoVenta := format(FromID);
    end;

    var
        FromID: Code[20];
        PedidoVenta: Text;
}

