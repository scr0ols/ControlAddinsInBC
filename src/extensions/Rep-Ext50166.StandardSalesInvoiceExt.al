//JOA007+
reportextension 50166 "SCR Standard Sales Invoice Ext" extends "Standard Sales - Invoice"
{
    RDLCLayout = 'src\extensions\StandardSalesInvoice.rdlc';

    dataset
    {
        add(Header)
        {
            //Drives the visibility of the whole signature block in the layout, so an unsigned
            //invoice prints exactly as it did before this extension existed.
            column(SCRHasSignature; SCRHasSignature)
            {
            }
            //Bare base64 PNG, no "data:image/png;base64," prefix: an RDL Image control with
            //Source = Database and MIMEType = image/png expects the base64 on its own.
            column(SCRSignatureBase64; SCRSignatureBase64)
            {
            }
            column(SCRSignedBy; SCRSignedBy)
            {
            }
            column(SCRSignedDate; Format(SCRSignedDate, 0, '<Day,2>-<Month,2>-<Year4>'))
            {
            }
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                DocSignature: Record "SCR Document Signature";
                DocSignatureMgt: Codeunit "SCR Document Signature Mgt.";
            begin
                //The report prints several invoices in one run; without clearing, a signed
                //document would leak its signature onto the next unsigned one.
                Clear(SCRSignatureBase64);
                Clear(SCRSignedBy);
                Clear(SCRSignedDate);

                SCRHasSignature := DocSignatureMgt.Get(Database::"Sales Invoice Header", Header."No.", DocSignature);
                if not SCRHasSignature then
                    exit;

                SCRSignatureBase64 := DocSignatureMgt.GetBase64(DocSignature);
                SCRSignedBy := DocSignature."Signed By";
                SCRSignedDate := DocSignature."Signed Date";
                //A signature row whose Media is empty is not worth a block on the printout.
                SCRHasSignature := SCRSignatureBase64 <> '';
            end;
        }
    }
    labels
    {
        SignedBy = 'Issued By, signature:';
        SignedDate = 'Signed Date';
    }

    var
        SCRSignatureBase64: Text;
        SCRSignedBy: Text[80];
        SCRSignedDate: DateTime;
        SCRHasSignature: Boolean;
}
//JOA007-
