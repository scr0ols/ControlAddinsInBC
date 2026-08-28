//JOA007+
codeunit 50162 "SCR Document Signature Mgt."
{
    //Looks up the signature (if any) captured for a given document. Returns false and an
    //empty record when none exists yet.
    procedure Get(TableNo: Integer; DocumentNo: Code[20]; var DocSignature: Record "SCR Document Signature"): Boolean
    begin
        DocSignature.SetRange("Table No.", TableNo);
        DocSignature.SetRange("Document No.", DocumentNo);
        exit(DocSignature.FindFirst());
    end;

    //Persists a signature captured on the control add-in (a base64 PNG data URL) for a
    //given document, creating or overwriting the entry as needed.
    procedure Save(TableNo: Integer; DocumentNo: Code[20]; SignedBy: Text[80]; SignatureDataUrl: Text)
    var
        DocSignature: Record "SCR Document Signature";
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        InStream: InStream;
        OutStream: OutStream;
    begin
        if not Get(TableNo, DocumentNo, DocSignature) then begin
            DocSignature.Init();
            DocSignature."Table No." := TableNo;
            DocSignature."Document No." := DocumentNo;
            DocSignature.Insert();
        end;

        TempBlob.CreateOutStream(OutStream);
        Base64Convert.FromBase64(RemoveDataUrlPrefix(SignatureDataUrl), OutStream);
        TempBlob.CreateInStream(InStream);
        DocSignature.Signature.ImportStream(InStream, 'Signature');

        DocSignature."Signed By" := SignedBy;
        DocSignature."Signed By User ID" := UserId();
        DocSignature."Signed Date" := CurrentDateTime();
        DocSignature.Modify();
    end;

    //A data URL looks like "data:image/png;base64,iVBORw0KG...". Base64 Convert only wants
    //the part after the comma.
    local procedure RemoveDataUrlPrefix(DataUrl: Text): Text
    var
        CommaPos: Integer;
    begin
        CommaPos := StrPos(DataUrl, ',');
        if CommaPos > 0 then
            exit(CopyStr(DataUrl, CommaPos + 1));
        exit(DataUrl);
    end;
}
//JOA007-
