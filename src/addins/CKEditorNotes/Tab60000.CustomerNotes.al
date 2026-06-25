//JOA006+ 
table 60001 "Customer Notes"
{
    Caption = 'Customer Notes';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Note No."; Code[10])
        {
            Caption = 'Note No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Note No." <> xRec."Note No." then begin
                    SalesSetup.Get();
                    NoSeriesMgt.TestManual(SalesSetup."Note Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(3; Title; Text[100])
        {
            Caption = 'Title';
            DataClassification = CustomerContent;
        }
        field(4; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(5; "Modification Date"; DateTime)
        {
            Caption = 'Modification Date';
            DataClassification = CustomerContent;
        }
        field(6; "Note Content"; Text[2048])
        {
            Caption = 'Note Content';
            DataClassification = CustomerContent;
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; "Note created"; Boolean)
        {
            Caption = 'Note created';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Note No.")
        {
            Clustered = true;
        }
        key("Customer No."; "Customer No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Note No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Note Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."Note Nos.", xRec."No. Series", 0D, "Note No.", "No. Series");
            Rec."Creation Date" := CurrentDateTime();
        end;
    end;

    trigger OnModify()
    begin
        if (Rec.Title <> xRec.Title) or (Rec."Note Content" <> xRec."Note Content") then begin
            Rec."Modification Date" := CurrentDateTime();
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
//JOA006-