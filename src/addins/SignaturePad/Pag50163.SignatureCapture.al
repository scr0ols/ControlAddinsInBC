//JOA007+
page 50163 "SCR Signature Capture"
{
    Caption = 'Capture Signature';
    //Card run modally: the dialog supplies its own OK/Cancel buttons, so the page carries no
    //actions at all. A modal dialog renders no action bar, which is why Clear lives inside
    //the add-in and Replace is the boolean field below rather than page actions.
    PageType = Card;
    //No UsageCategory on purpose: the page is meaningless without SetDocument(), so it must
    //not be reachable from Tell Me. It is only ever opened from a document or from the
    //signature list.

    layout
    {
        area(content)
        {
            group(Header)
            {
                Caption = 'Document';
                field(DocumentNoField; DocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the document this signature belongs to.';
                }
                field(SignedByField; SignedByInput)
                {
                    ApplicationArea = All;
                    Caption = 'Signed By';
                    Editable = not HasSignature;
                    NotBlank = true;
                    ToolTip = 'Specifies the name of the person signing this document.';
                }
                field(SignedDateField; SignedDate)
                {
                    ApplicationArea = All;
                    Caption = 'Signed Date';
                    Editable = false;
                    Visible = HasSignature;
                    ToolTip = 'Specifies when this document was signed.';
                }
                field(ReplaceField; ReplaceRequested)
                {
                    ApplicationArea = All;
                    Caption = 'Replace Signature';
                    Visible = HasSignature and not ViewOnly;
                    ToolTip = 'Specifies whether to unlock the pad so that the current signature can be erased and a new one captured.';

                    trigger OnValidate()
                    begin
                        if not ReplaceRequested then
                            exit;

                        //Dropping HasSignature both unlocks the pad and hides this field, so
                        //the page falls back to the plain capture state.
                        HasSignature := false;
                        PendingSignatureData := '';
                        CurrPage.SignaturePad.Clear();
                        CurrPage.SignaturePad.SetReadOnly(false);
                        CurrPage.Update(false);
                    end;
                }
            }
            group(SignatureArea)
            {
                Caption = 'Signature';
                //Adding the control add-in to the webpage.
                usercontrol(SignaturePad; "SCR Signature Pad")
                {
                    ApplicationArea = All;
                    //The control add-in is loaded on the page.
                    trigger ControlReady()
                    begin
                        CurrPage.SignaturePad.Init();
                    end;
                    //After the pad is created this trigger runs.
                    trigger OnAfterInit()
                    begin
                        if HasSignature then begin
                            CurrPage.SignaturePad.LoadSignature(ExistingSignatureDataUrl);
                            CurrPage.SignaturePad.SetReadOnly(true);
                        end;
                    end;
                    //The user finished a stroke; ask the pad to report its current content.
                    trigger SignatureChanged()
                    begin
                        CurrPage.SignaturePad.RequestSignature();
                    end;
                    //The pad reported its current content in response to RequestSignature().
                    trigger SignatureCaptured(data: Text)
                    begin
                        PendingSignatureData := data;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        DocSignature: Record "SCR Document Signature";
    begin
        HasSignature := DocSignatureMgt.Get(TableNo, DocumentNo, DocSignature);
        if HasSignature then begin
            SignedByInput := DocSignature."Signed By";
            SignedDate := DocSignature."Signed Date";
            ExistingSignatureDataUrl := GetSignatureDataUrl(DocSignature);
        end;
    end;

    //The dialog's OK button is what commits: Cancel or the X discards whatever was drawn.
    //Raising an error here keeps the dialog open so the user can fix the input.
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction <> Action::OK then
            exit(true);
        //Opened straight from the signature list: read-only, there is nothing to commit.
        if ViewOnly then
            exit(true);
        //Viewing an already-signed document, nothing was captured.
        if HasSignature then
            exit(true);

        if SignedByInput = '' then
            Error(SignedByRequiredErr);
        if PendingSignatureData = '' then
            Error(SignatureRequiredErr);

        DocSignatureMgt.Save(TableNo, DocumentNo, SignedByInput, PendingSignatureData);
        exit(true);
    end;

    //Called by the caller (a page action, typically) before RunModal() to say which
    //document this capture/view session is for.
    procedure SetDocument(NewTableNo: Integer; NewDocumentNo: Code[20])
    begin
        TableNo := NewTableNo;
        DocumentNo := NewDocumentNo;
    end;

    //Called by the signature list before RunModal(): the page becomes a pure viewer, with no
    //way to replace what is already stored. Callers that own the document leave it alone.
    procedure SetViewOnly()
    begin
        ViewOnly := true;
    end;

    //A Media field is a normal field: the content is fetched on demand, no CalcFields
    //involved. It is exported through a Temp Blob so it can be read back as base64.
    local procedure GetSignatureDataUrl(var DocSignature: Record "SCR Document Signature"): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
    begin
        if not DocSignature.Signature.HasValue() then
            exit('');

        TempBlob.CreateOutStream(OutStream);
        DocSignature.Signature.ExportStream(OutStream);
        TempBlob.CreateInStream(InStream);
        exit('data:image/png;base64,' + Base64Convert.ToBase64(InStream));
    end;

    var
        DocSignatureMgt: Codeunit "SCR Document Signature Mgt.";
        TableNo: Integer;
        DocumentNo: Code[20];
        SignedByInput: Text[80];
        SignedDate: DateTime;
        PendingSignatureData: Text;
        ExistingSignatureDataUrl: Text;
        HasSignature: Boolean;
        ReplaceRequested: Boolean;
        ViewOnly: Boolean;
        SignedByRequiredErr: Label 'Specify who is signing the document before saving.';
        SignatureRequiredErr: Label 'Draw a signature before saving.';
}
//JOA007-
