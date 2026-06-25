page 60007 "Testting Microsoft AddIn"
{
    Caption = 'Testting Microsoft AddIn';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            usercontrol(WPVColor; "Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = All;
                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    CurrPage.WPVColor.SetContent('<div class="myDiv" style="width:flex;height:25px;border:1px solid black;background-color:#92b0b3">If you click on the action you will be able to play a game;)</div>');
                end;
            }
        }

    }
    actions
    {
        area(Navigation)
        {
            action("Add game")
            {
                ApplicationArea = All;
                Visible = true;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    contentHtml: Label '<iframe src="https://chromedino.com/" frameborder="0" scrolling="no" width="100%" height="100%" loading="lazy" text-align="center"></iframe>';
                begin
                    CurrPage.WPVColor.SetContent(content + contentHtml);
                end;
            }
            action("Gun Master")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    CurrPage.WPVColor.SetContent(gunMasteriFrame);
                end;
            }
        }
    }
    var
        content: Label '<div class="myDiv" style="width:flex;height:25px;border:1px solid black;background-color:#92b0b3">If you click on the action you will be able to play a game;)</div><hr width="flex" color="red" size="1">';
        gunMasteriFrame: Label '<iframe seamless="seamless" allowtransparency="true" allowfullscreen="true" frameborder="0" style="width: 100%;height: 100%;border: 0px;" src="https://zv1y2i8p.play.gamezop.com/g/REwFeKcoN"> </iframe>';
}