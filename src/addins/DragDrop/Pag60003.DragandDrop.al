//JOA004+
page 60003 "Drag and Drop"
{
    PageType = CardPart;
    Caption = 'Create items from json';
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            //Adding control add-in to page
            usercontrol(DragAndDropSection; "Drag and Drop AddIn")
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    CurrPage.DragAndDropSection.embedDragDropBox();
                end;

                trigger GetFileContent(curr_file: Text)
                var
                    DragDropMgt: Codeunit "Drag & Drop Mgt";
                    JObject: JsonObject;
                    JArray: JsonArray;
                    JToken: JsonToken;
                    index: Integer;
                begin
                    if JArray.ReadFrom(curr_file) then begin
                        for index := 0 to JArray.Count - 1 do begin
                            JArray.Get(index, JToken);
                            JObject := JToken.AsObject();
                            Message(Format(JObject));
                            DragDropMgt.CreateItemFromJson(JObject);
                        end;
                    end else
                        Error('UPS! Invalid json file');

                end;
            }
        }
    }
}


//JOA004-