pageextension 50152 "SCR Customer List Ext" extends "Customer List"
{

    layout
    {
        //JOA003+ 
        addbefore(Control1)
        {
            //Adding control add-in to page
            usercontrol(Carousel; "SCR Carousel AddIn")
            {
                //When the current page is loaded the control add-in is also loaded, therefore the startup script will run wich will invoke this trigger
                trigger ControlReady()
                var
                    JObject: JsonObject;
                    Slides: JsonArray;
                begin
                    CarouselAddInInitialized := true;
                    //Lets add to an array informations about the image title, decription and the link for the image
                    Slides.Add(AddSlide('Keep your promises', 'check before you make a promise', '//unsplash.it/1024/200'));
                    Slides.Add(AddSlide('Never forget', 'always register your conversations to ensure you follow-up promptly', '//unsplash.it/1025/200'));
                    Slides.Add(AddSlide('Qualify', 'be picky about which opportunities to spend time on', '//unsplash.it/1024/201'));
                    JObject.Add('slides', Slides);
                    CurrPage.Carousel.SetCarouselData(JObject);
                end;
            }
        }
        //JOA003-
    }

    actions
    {
        addfirst(processing)
        {
            //JOA006+ 
            group(Notes)
            {
                Visible = true;
                Image = Notes;
                Caption = 'Customer Notes';
                action("New Note")
                {
                    Caption = 'New Note';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    Image = Note;
                    Visible = true;
                    Scope = Repeater;
                    trigger OnAction()
                    var
                        CustomerNote: Record "SCR Customer Notes";
                    begin
                        CustomerNote.Init();
                        CustomerNote."Customer No." := Rec."No.";
                        CustomerNote.Insert(true);
                        Page.Run(50101, CustomerNote);
                    end;
                }
                action("SCR Customer Notes")
                {
                    Caption = 'Customer Notes';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category9;
                    Image = Notes;
                    Visible = true;
                    Scope = Repeater;
                    trigger OnAction()
                    var
                        CustomerNotes: Record "SCR Customer Notes";
                        CustomerNotesPage: page "SCR Customer Notes List";
                    begin
                        CustomerNotes.SetRange("Customer No.", Rec."No.");
                        CustomerNotesPage.SetTableView(CustomerNotes);
                        CustomerNotesPage.Run();
                    end;
                }
            }
            //JOA006-
        }
    }


    //JOA003+ 
    local procedure AddSlide(Title: Text; Description: Text; Image: Text): JsonObject
    var
        Slide: JsonObject;
    begin
        Slide.Add('title', Title);
        Slide.Add('description', Description);
        Slide.Add('image', Image);
        exit(Slide);
    end;

    var
        CarouselAddInInitialized: Boolean;
    //JOA003-
}