//JOA006+ 
var InputArea
var Editor

function Init() {
    var div = document.getElementById("controlAddIn");
    div.innerHTML = "";
    InputArea = document.createElement("textarea");
    InputArea.id = "Comment";
    InputArea.name = "Comment";
    
    div.appendChild(InputArea);
    debugger;
    ClassicEditor
        .create(document.querySelector('#Comment'), {
          toolbar: {
            items: [
                'heading', '|',
                'alignment', '|',
                'bold', 'italic', 'strikethrough', 'underline', 'subscript', 'superscript', '|',
                'link', '|',
                'bulletedList', 'numberedList', 'todoList',
                // '-', // break point
                'fontfamily', 'fontsize', 'fontColor', 'fontBackgroundColor', '|',
                'code', 'codeBlock', '|',
                'insertTable', '|',
                'outdent', 'indent', '|',
                'uploadImage', 'blockQuote', '|',
                'undo', 'redo', '|'
            ],
            shouldNotGroupWhenFull: true
        }})
        .then(editor => {
            Editor = editor;
            editor.model.document.on( 'change:data', () => {
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ContentChanged",[]);    
            } );
        })
        .catch(error => {
            console.error(error);
        });
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnAfterInit",[]);
    
}

function Load(data) {
    Editor.setData(data);
}

function RequestSave() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("SaveRequested",[Editor.getData()]);
}

function SetReadOnly(readonly)
{
    Editor.isReadOnly = readonly;
}
//JOA006-