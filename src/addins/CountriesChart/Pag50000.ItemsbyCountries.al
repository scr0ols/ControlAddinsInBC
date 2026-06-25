//JOA001+ 
page 60000 "Items by Countries"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    Caption = 'Items by country';
    layout
    {
        area(Content)
        {
            repeater(rep)
            {
                Caption = 'Select item';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    TableRelation = Item;
                    Editable = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                    Editable = false;
                }
            }
            group(Charts2)
            {
                ShowCaption = false;
                //Adding control add-in to page
                usercontrol(Chart; "Countries Chart AddIn")
                {
                    ApplicationArea = all;
                    //When the current page is loaded the control add-in is also loaded, therefore the startup script will run wich will invoke this trigger
                    trigger ControlReady()
                    begin
                        ChartAddInInitialized := true;
                        //Procedure that handles the logic to send json data to our chart
                        CalculateItemsPerCountry(Rec."No.");
                    end;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {

            action(Refresh)
            {
                Caption = 'Refresh';
                Image = Refresh;
                ApplicationArea = All;
                ToolTip = 'Calculates number of sold items by country';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Clear(DataA);
                    Clear(JsonA);
                    CalculateItemsPerCountry(Rec."No.");
                end;
            }
        }
    }

    //In this procedure the intuit is to find where the selected item was sold across the world. So when we do a sales order and add items we can know wheres the country of the buyer.
    procedure CalculateItemsPerCountry(itemNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLn: Record "Sales Invoice Line";
        CountryCode: Code[2];
        NrOfItems: Integer;

        tempList: Dictionary of [Code[2], Integer];
        tempNrItems: Integer;
        keys: List of [code[2]];
        counter: Integer;
    begin
        SalesInvLn.Reset();
        SalesInvLn.Init();
        SalesInvLn.SetRange("No.", itemNo);
        if SalesInvLn.FindFirst() then begin
            repeat
                SalesInvHdr.Reset();
                SalesInvHdr.Init();
                if SalesInvHdr.Get(SalesInvLn."Document No.") then begin
                    CountryCode := SalesInvHdr."Sell-to Country/Region Code";
                    NrOfItems := SalesInvLn.Quantity;
                    if tempList.ContainsKey(CountryCode) then begin
                        tempNrItems := tempList.Get(CountryCode);
                        tempList.Set(CountryCode, tempNrItems + NrOfItems);
                    end else
                        tempList.Add(CountryCode, NrOfItems);
                end
            until SalesInvLn.Next() = 0;
        end;

        clear(JsonA);
        JsonA.Add('Country');
        JsonA.Add('Nº of items');
        DataA.Add(JsonA);

        keys := tempList.Keys;
        for counter := 1 to keys.Count do begin
            Clear(JsonA);
            JsonA.Add(keys.Get(counter));
            JsonA.Add(tempList.Get(keys.Get(counter)));
            DataA.Add(JsonA);
        end;
        //Lets send the json array to our javascript function so then we can draw the chart with the data
        if ChartAddInInitialized then //Not needed beacuse we call this function after the initialization of the Control Addd-In, but better safe than sorry
            CurrPage.Chart.GeographicGraph(DataA);
    end;

    var
        DataA: JsonArray;
        JsonA: JsonArray;
        ChartAddInInitialized: Boolean;
}

//JOA001-