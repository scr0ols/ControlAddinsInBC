//JOA004+ 
codeunit 60000 "Drag & Drop Mgt"
{
    procedure CreateItemFromJson(JObject: JsonObject)
    var
        Item: Record Item;
        tempJToken: JsonToken;
        JValue: JsonValue;
        chaves: list of [Text];
    begin
        //Description - if an item doesnt have a description(name) we will not create that item
        if not JObject.Get('Description', tempJToken) then
            Error('Something went wrong!\You need a description to create an Item!')
        else begin
            Item.Reset();
            Item.Init();

            JValue := tempJToken.AsValue();
            Item.Description := Format(JValue.AsText());

            //Unit Cost
            if JObject.Get('Unit Cost', tempJToken) then begin
                JValue := tempJToken.AsValue();
                Item."Unit Cost" := JValue.AsDecimal();
            end;
            //Unit Price
            if JObject.Get('Unit Price', tempJToken) then begin
                JValue := tempJToken.AsValue();
                Item."Unit Price" := JValue.AsDecimal();
            end;
            //No.
            if JObject.Get('No', tempJToken) then begin
                JValue := tempJToken.AsValue();
                if Item.Get(JValue.AsCode()) then begin
                    Message('Theres already a item with No %1.\Couldn´t create requested item.', JValue.AsCode());
                    exit;
                end;
                Item."No." := JValue.AsCode();
            end;
            //Base Unit of Measure
            if JObject.Get('Base Unit Of Measure', tempJToken) then begin
                JValue := tempJToken.AsValue();
                Item."Base Unit of Measure" := JValue.AsCode();
            end;
            //Gen Prod Posting Group
            if JObject.Get('Gen Prod Posting Group', tempJToken) then begin
                JValue := tempJToken.AsValue();
                Item."Gen. Prod. Posting Group" := JValue.AsCode();
            end;
            //VAT Prod Posting Group
            if JObject.Get('VAT Prod Posting Group', tempJToken) then begin
                JValue := tempJToken.AsValue();
                Item."VAT Prod. Posting Group" := JValue.AsCode();
            end;
            //Inventory Posting Group
            if JObject.Get('Inventory Posting Group', tempJToken) then begin
                JValue := tempJToken.AsValue();
                Item."Inventory Posting Group" := JValue.AsCode();
            end;
            //Create new item
            Item.Insert(true);
        end;
    end;
}

//JOA004-