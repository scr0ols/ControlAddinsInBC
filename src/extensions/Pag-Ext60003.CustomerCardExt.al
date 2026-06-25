pageextension 60003 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addbefore(General)
        {
            usercontrol(BarGraphAddIn; "Bar Graph Add-In")
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    bool_ControlReady := true;
                    CurrPage.BarGraphAddIn.barGraph(GetSales());
                end;

                trigger OpenSalesQuotes()
                var
                    SalesHeader: Record "Sales Header";
                    SalesQuotesPage: Page "Sales Quotes";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    SalesQuotesPage.SetTableView(SalesHeader);
                    SalesQuotesPage.Run();
                end;

                trigger OpenSalesOrders()
                var
                    SalesHeader: Record "Sales Header";
                    SalesOrdersPage: Page "Sales Order List";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    SalesOrdersPage.SetTableView(SalesHeader);
                    SalesOrdersPage.Run();
                end;

                trigger OpenSalesInvoices()
                var
                    SalesHeader: Record "Sales Header";
                    SalesInvoicesPage: Page "Sales Invoice List";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    SalesInvoicesPage.SetTableView(SalesHeader);
                    SalesInvoicesPage.Run();
                end;

                trigger OpenPostedSalesInvoices()
                var
                    PostedSalesHeader: Record "Sales Invoice Header";
                    PostedSalesInvoicesPage: Page "Posted Sales Invoices";
                begin
                    PostedSalesHeader.Reset();
                    PostedSalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    PostedSalesInvoicesPage.SetTableView(PostedSalesHeader);
                    PostedSalesInvoicesPage.Run();
                end;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            //JOA006+ 
            group(Notes)
            {
                Visible = true;
                Image = Notes;
                Caption = 'Customer Notes';
                action("New Note")
                {
                    Caption = 'New Note';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    Image = Note;
                    Visible = true;
                    Scope = Repeater;
                    trigger OnAction()
                    var
                        CustomerNote: Record "Customer Notes";
                        SalesSetup: Record "Sales & Receivables Setup";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                    begin
                        CustomerNote.Reset();
                        CustomerNote.Init();

                        SalesSetup.Get();
                        CustomerNote."Note No." := NoSeriesMgt.GetNextNo(SalesSetup."Note Nos.", Today, true);
                        CustomerNote."Customer No." := Rec."No.";
                        CustomerNote."Modification Date" := CustomerNote."Creation Date";
                        CustomerNote.Insert();
                        Page.Run(60005, CustomerNote);
                    end;
                }
                action("Customer Notes")
                {
                    Caption = 'Customer Notes';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category9;
                    Image = Notes;
                    Visible = true;
                    Scope = Repeater;
                    trigger OnAction()
                    var
                        CustomerNotes: Record "Customer Notes";
                        CustomerNotesPage: page "Customer Notes List";
                    begin
                        CustomerNotes.SetRange("Customer No.", Rec."No.");
                        CustomerNotesPage.SetTableView(CustomerNotes);
                        CustomerNotesPage.Run();
                    end;
                }
            }
            //JOA006-
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if bool_ControlReady then
            CurrPage.BarGraphAddIn.barGraph(GetSales());
    end;

    procedure GetSales(): JsonArray
    var
        DataA: JsonArray;
        JsonA: JsonArray;
        SalesHeader: Record "Sales Header";
        QuoteCounter, OrderCounter, InvoiceCounter, PostedInvoicesCounter : integer;
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        QuoteCounter := 0;
        OrderCounter := 0;
        InvoiceCounter := 0;
        PostedInvoicesCounter := 0;
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        if SalesHeader.FindSet() then begin
            repeat
                case SalesHeader."Document Type" of
                    "Sales Document Type"::Quote:
                        QuoteCounter += 1;
                    "Sales Document Type"::"Order":
                        OrderCounter += 1;
                    "Sales Document Type"::Invoice:
                        InvoiceCounter += 1;

                end;
            until SalesHeader.Next() = 0;
        end;
        SalesInvHdr.SetRange("Sell-to Customer No.", Rec."No.");
        if SalesInvHdr.FindSet() then begin
            repeat
                PostedInvoicesCounter += 1;
            until SalesInvHdr.Next() = 0;
        end;
        Clear(DataA);
        Clear(JsonA);

        JsonA.Add('Sales Type');
        JsonA.Add('Quantity');
        DataA.Add(JsonA);
        Clear(JsonA);
        JsonA.Add('Quotes');
        JsonA.Add(QuoteCounter);
        DataA.Add(JsonA);
        Clear(JsonA);
        JsonA.Add('Orders');
        JsonA.Add(OrderCounter);
        DataA.Add(JsonA);
        Clear(JsonA);
        JsonA.Add('Invoices');
        JsonA.Add(InvoiceCounter);
        DataA.Add(JsonA);
        // Message(Format(DataA));
        Clear(JsonA);
        JsonA.Add('Posted Invoices');
        JsonA.Add(PostedInvoicesCounter);
        DataA.Add(JsonA);
        exit(DataA);
    end;

    var
        bool_ControlReady: Boolean;
}

