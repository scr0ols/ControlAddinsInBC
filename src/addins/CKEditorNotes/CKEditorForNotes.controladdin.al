//JOA006+ 
controladdin "SCR CKEditor Notes"
{
    //Only need to specifie the width because the height is automaticcly added by the default editor
    RequestedWidth = 814;
    MaximumWidth = 814;
    //Script to include in the control add-in.  
    Scripts = 'https://cdn.ckeditor.com/ckeditor5/36.0.1/classic/ckeditor.js', 'src\addins\"SCR CKEditor Notes"\TextEditor.js';
    //This script is invoked when the webpage (in this case page 50101 "SCR Customer Notes" ) with the control add-in is loaded.
    StartupScript = 'src\shared\ControlReady_startup.js';

    //In the ControlReady_startup.js we call this event to initialize the control add-in. 
    event ControlReady();
    //Return the content of the editor to BC side
    event SaveRequested(data: Text);
    //Triggered when the content of editor has changed
    event ContentChanged();
    //Trigger after the editor is created
    event OnAfterInit();

    //Procedure responsible to create the Text Editor and append him to our page
    procedure Init();
    //Load the editor with data
    procedure Load(data: Text);
    //Save the current content in the editor
    procedure RequestSave();
    //Set the text editor to read only mode
    procedure SetReadOnly(readonly: boolean);
}
//JOA006-