//JOA007+
table 50161 "SCR Document Signature"
{
    Caption = 'Document Signature';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
            DataClassification = SystemMetadata;
            //ID of the source document table, e.g. Database::"Sales Invoice Header".
            //Kept generic on purpose, so the same table can back signatures on other
            //document types later (Sales Shipment, ...) without a schema change.
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; Signature; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(5; "Signed By"; Text[80])
        {
            Caption = 'Signed By';
            DataClassification = CustomerContent;
            //Free text: whoever physically signs (customer, driver, ...) is not necessarily
            //a Business Central user.
        }
        field(6; "Signed By User ID"; Code[50])
        {
            Caption = 'Signed By User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //The BC user that captured the signature, for audit purposes.
        }
        field(7; "Signed Date"; DateTime)
        {
            Caption = 'Signed Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Document; "Table No.", "Document No.")
        {
        }
    }
}
//JOA007-
