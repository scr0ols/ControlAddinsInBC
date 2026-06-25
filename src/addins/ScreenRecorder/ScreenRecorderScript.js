//JOA005+ 
let completeBlob = null;
let recorder = null;
let chunks = [];
let stream = null;
let blobHref = null;
let video_attachment = null;

//write to console function
function writeToConsole(message){
    if (typeof console != 'undefined'){
        console.log(message);
    }
}


async function startRecord() {
    //Try to start media recorder, if not possible we will catch that 
    try {
        stream = await navigator.mediaDevices.getDisplayMedia({video: true, audio: false});
        recorder = new MediaRecorder(stream);
        recorder.ondataavailable = (e) => chunks.push(e.data);
        recorder.start();
        recorder.onstop = onstop;
        //call trigger ChangeButtonsStateStartClick() in "Screen Recorder" page
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ChangeButtonsStateStartClick", []);
    } catch (error) {
        //call trigger ChangeButtonsStateCancelClick() in "Screen Recorder" page
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ChangeButtonsStateCancelClick", []);
    }
}
async function stopScreen() {
    //stop media tracks recording
    recorder.stop()
    stream.getTracks().forEach(function (track) {
        track.stop();
    });
}     
function onstop() {
    //After stopping the media recorder lets store the tracks
    completeBlob = new Blob(chunks, {
        type: chunks[0].type
    });
    stream.getVideoTracks()[0].stop();
    let reader = new FileReader();
    reader.readAsDataURL(completeBlob);
    let base64String = reader.result;
    //call trigger ChangeButtonsStateStopClick() in "Screen Recorder" page
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ChangeButtonsStateStopClick", []);
    //Add the video to "Screen Recorder" page
    EmbedVideoToPage();
}
async function downloadVideo(){
    //Donwload the video in mp4 format
    let video = document.createElement('a');
    video.href = URL.createObjectURL(completeBlob);
    video.download = Date.now() + '.mp4';
    document.body.appendChild(video);
    video.click();
    video.remove();
    //call trigger ChangeButtonsStateDownloadClick() in "Screen Recorder" page
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ChangeButtonsStateDownloadClick", []);
}
function createFileFormCurrentRecordedData() {
    debugger;
    const blob = new Blob(chunks , {type: "video/ogg"});
    const file = new File( [ blob ], "yourfilename.ogg", { type: "video/ogg"} );
    /* then upload oder directly download your file / blob depending on your needs */
}

function EmbedVideoToPage() {
    debugger;
    let videoResult = document.getElementById('videoResult');
    if (videoResult) {
        videoResult.remove();
    } 
    //Get our control add-in iFrame 
    var controlAddIn = document.getElementById("controlAddIn");
    //Create element to append the video
    var videoDiv = document.createElement('div');

    videoDiv.innerHTML = `
                        <div style="border: 2px solid black">
                            <video controls="true" style="width: 810px; height: 455px; display:block;" id="videoResult" src="`
                            + URL.createObjectURL(completeBlob) + `"></video>
                        </div>
    `;
    //Lets add the element to our control add-in iFrame
    controlAddIn.appendChild(videoDiv);
}
//JOA005-
