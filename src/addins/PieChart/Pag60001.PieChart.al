//JOA002+ 
page 60001 "Pie Chart"
{
    Caption = ' ';
    PageType = CardPart;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            //Adding control add-in to page
            usercontrol(PieChart; "Pie Charts AddIn")
            {
                //Important to add ApplicationArea, otherwise the add in will not load
                ApplicationArea = All;
                //When the current page is loaded the control add-in is also loaded, therefore the startup script will run wich will invoke this trigger
                trigger ControlReady()
                begin
                    PieChartInitialized := true;
                    //Procedure that will count Open/Released status from all sales orders
                    CalculateSalesOrderStates();
                end;
                //When this trigger is invoked (by user click on the chart) we will open a page with Open sales orders
                trigger FilterByOpenStatus()
                var
                    SalesHeader: Record "Sales Header";
                    SalesDocumentStatusEnum: Enum "Sales Document Status";
                    SalesDocumentTypeEnum: Enum "Sales Document Type";
                begin
                    SalesHeader.SetFilter(Status, Format(SalesDocumentStatusEnum::Open));
                    SalesHeader.SetFilter("Document Type", Format(SalesDocumentTypeEnum::Order));
                    SalesHeader.SetCurrentKey(Status);
                    SalesHeader.SetAscending(Status, true);
                    Page.RunModal(9305, SalesHeader);
                end;
                //When this trigger is invoked (by user click on the chart) we will open a page with Released sales orders
                trigger FilterByReleasedStatus()
                var
                    SalesHeader: Record "Sales Header";
                    SalesDocumentStatusEnum: Enum "Sales Document Status";
                    SalesDocumentTypeEnum: Enum "Sales Document Type";
                begin
                    SalesHeader.SetFilter(Status, Format(SalesDocumentStatusEnum::Released));
                    SalesHeader.SetFilter("Document Type", Format(SalesDocumentTypeEnum::Order));
                    SalesHeader.SetCurrentKey(Status);
                    SalesHeader.SetAscending(Status, true);
                    Page.RunModal(9305, SalesHeader);
                end;
            }
        }
    }
    procedure CalculateSalesOrderStates()
    var
        SalesHeader: Record "Sales Header";
        SalesDocumentStatusEnum: Enum "Sales Document Status";
        SalesDocumentTypeEnum: Enum "Sales Document Type";
        ReleaseCounter, OpenCounter : Integer;
        JsonA: JsonArray;
        DataA: JsonArray;
    begin
        OpenCounter := 0;
        ReleaseCounter := 0;
        SalesHeader.Reset();

        SalesHeader.SetRange("Document Type", SalesDocumentTypeEnum::Order);
        if SalesHeader.FindSet() then begin
            repeat
                if SalesHeader.Status = SalesDocumentStatusEnum::Open then begin
                    OpenCounter := OpenCounter + 1;
                end;
                if SalesHeader.Status = SalesDocumentStatusEnum::Released then begin
                    ReleaseCounter := ReleaseCounter + 1;
                end;
            until SalesHeader.Next() = 0;
        end;

        Clear(JsonA);
        JsonA.Add('Status');
        JsonA.Add('Status Value');
        DataA.Add(JsonA);
        Clear(JsonA);
        JsonA.Add('Open');
        JsonA.Add(OpenCounter);
        DataA.Add(JsonA);
        Clear(JsonA);
        JsonA.Add('Released');
        JsonA.Add(ReleaseCounter);
        DataA.Add(JsonA);
        //Lets send the json array to our javascript function so then we can draw the chart with the data
        if PieChartInitialized then
            CurrPage.PieChart.PieChart(DataA);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if PieChartInitialized then
            CalculateSalesOrderStates();    //We can do this because the control add in is already loaded before we get the current record
    end;

    var
        PieChartInitialized: Boolean;

}

//JOA002-