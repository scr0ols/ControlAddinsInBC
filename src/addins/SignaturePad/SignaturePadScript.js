//JOA007+
var padCanvas;
var signaturePad;
var clearButton;
//Set by LoadSignature(). Strokes drawn by the user live in signaturePad.toData(), but an
//image restored with fromDataURL() does not, so it has to be kept here to survive a resize.
var loadedDataUrl = "";
var lastWidth = 0;
var lastHeight = 0;

function Init() {
    var div = document.getElementById("controlAddIn");
    div.innerHTML = "";

    padCanvas = document.createElement("canvas");
    padCanvas.id = "signaturePadCanvas";
    padCanvas.style.display = "block";
    padCanvas.style.width = "100%";
    padCanvas.style.height = "200px";
    padCanvas.style.border = "1px solid #d6d6d6";
    padCanvas.style.borderRadius = "4px";
    padCanvas.style.boxSizing = "border-box";
    padCanvas.style.touchAction = "none";
    div.appendChild(padCanvas);

    //A modal Card page renders no action bar, so Clear cannot be a page action - it lives
    //here, right under the pad, where it is also closer to what the user just drew.
    clearButton = document.createElement("button");
    clearButton.type = "button";
    clearButton.textContent = "Clear";
    clearButton.style.marginTop = "6px";
    clearButton.style.padding = "4px 12px";
    clearButton.style.border = "1px solid #d6d6d6";
    clearButton.style.borderRadius = "4px";
    clearButton.style.background = "#ffffff";
    clearButton.style.cursor = "pointer";
    clearButton.addEventListener("click", function () {
        signaturePad.clear();
        loadedDataUrl = "";
        //Reuses the normal round-trip so AL drops the pending signature it is holding.
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("SignatureChanged", []);
    });
    div.appendChild(clearButton);

    signaturePad = new SignaturePad(padCanvas, {
        backgroundColor: "rgb(255, 255, 255)"
    });

    signaturePad.addEventListener("endStroke", function () {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("SignatureChanged", []);
    });

    //The add-in iframe is still being laid out while Init() runs, so offsetWidth can be 0
    //here. Sizing the canvas off a 0 width gives an empty bitmap and misplaced strokes, so
    //the container is observed instead and the canvas is fitted once it really has a size.
    if (window.ResizeObserver) {
        new ResizeObserver(resizeCanvas).observe(div);
    } else {
        window.addEventListener("resize", resizeCanvas);
    }
    resizeCanvas();

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnAfterInit", []);
}

//Keeps the canvas sharp on high-DPI screens and re-applies whatever was on it after a
//resize, so opening in a narrow dialog or resizing the BC window doesn't wipe the content.
function resizeCanvas() {
    if (!padCanvas) {
        return;
    }
    var rect = padCanvas.getBoundingClientRect();
    //Not laid out yet: the ResizeObserver will call back once it has a size.
    if (rect.width === 0 || rect.height === 0) {
        return;
    }
    //Resizing the canvas resizes the observed container, so bail out on no-op calls to
    //avoid a feedback loop.
    if (rect.width === lastWidth && rect.height === lastHeight) {
        return;
    }
    lastWidth = rect.width;
    lastHeight = rect.height;

    var ratio = Math.max(window.devicePixelRatio || 1, 1);
    var strokes = signaturePad ? signaturePad.toData() : null;

    padCanvas.width = rect.width * ratio;
    padCanvas.height = rect.height * ratio;
    padCanvas.getContext("2d").scale(ratio, ratio);

    if (!signaturePad) {
        return;
    }
    signaturePad.clear();
    if (loadedDataUrl !== "") {
        signaturePad.fromDataURL(loadedDataUrl);
    } else if (strokes && strokes.length > 0) {
        signaturePad.fromData(strokes);
    }
}

function Clear() {
    loadedDataUrl = "";
    signaturePad.clear();
}

function LoadSignature(data) {
    loadedDataUrl = data ? data : "";
    signaturePad.clear();
    if (loadedDataUrl !== "") {
        signaturePad.fromDataURL(loadedDataUrl);
    }
}

function SetReadOnly(readonly) {
    if (readonly) {
        signaturePad.off();
    } else {
        signaturePad.on();
    }
    if (clearButton) {
        clearButton.style.display = readonly ? "none" : "inline-block";
    }
}

function RequestSignature() {
    var data = signaturePad.isEmpty() ? "" : signaturePad.toDataURL("image/png");
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("SignatureCaptured", [data]);
}
//JOA007-
