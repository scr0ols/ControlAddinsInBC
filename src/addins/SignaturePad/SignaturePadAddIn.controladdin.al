//JOA007+
controladdin "SCR Signature Pad"
{
    //200px canvas + the Clear button below it.
    RequestedHeight = 250;
    HorizontalStretch = true;
    VerticalStretch = false;

    //Small vendored script that wraps signature_pad.js; the library itself is loaded from CDN.
    Scripts = 'https://cdn.jsdelivr.net/npm/signature_pad@4.1.7/dist/signature_pad.umd.min.js',
    'src\addins\SignaturePad\SignaturePadScript.js';
    //This script is invoked when the webpage with the control add-in is loaded.
    StartupScript = 'src\shared\ControlReady_startup.js';

    //In the ControlReady_startup.js we call this event to initialize the control add-in.
    event ControlReady();
    //Fired once the canvas/signature pad has been created and is ready to use.
    event OnAfterInit();
    //Fired every time the user finishes a stroke on the pad; carries no data, mirrors the
    //ContentChanged/RequestSave pattern used by "SCR CKEditor Notes".
    event SignatureChanged();
    //Fired with the signature as a base64 PNG data URL, in response to RequestSignature().
    //Empty text means the pad is currently empty.
    event SignatureCaptured(data: Text);

    //Creates the canvas and the underlying SignaturePad instance.
    procedure Init();
    //Clears whatever is currently drawn on the pad.
    procedure Clear();
    //Loads a previously captured signature (base64 PNG data URL) into the pad for display.
    procedure LoadSignature(data: Text);
    //Locks/unlocks drawing on the pad (used to show an already-captured signature read-only).
    procedure SetReadOnly(readonly: Boolean);
    //Asks the pad to report its current content; results arrive via the SignatureCaptured event.
    procedure RequestSignature();
}
//JOA007-
