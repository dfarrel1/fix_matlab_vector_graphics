#target Illustrator
// script.name = fixMatlabPDFOutput.jsx
// script.description = deletes all PageItems being used as clipping masks, unites all paths with the same fill color.
// script.parent = Dene Farrell // 12/14/2016
// script.elegant = true?

// Check Java Script Version


$.writeln('running fixMatlabPDFOutputOnlyCroppingPaths');


//Doing Everything Here
function main()
{
    clipScan();
    saveAndQuit();
}

main();

//Defining functions below here

//loops through all pageItems, removing those that are clipping masks
function clipScan () {
    var clippingCount = 0;
    if ( app.documents.length == 0 ) {
        return;
    }
    var docRef = app.activeDocument;
    try {
        for (i = docRef.pageItems.length - 1; i >= 0; i--) {
            if (docRef.pageItems[i].clipping == true) {
                docRef.pageItems[i].remove();
                clippingCount++;
            }
        }
        //alert ("All "+clippingCount+" Clipping Masks Removed")
    }
    catch(err) {
        $.writeln('clipping removal code did not work.');
    }
};







function saveAndQuit () {

    // save as (new file)
    var originalInteractionLevel = userInteractionLevel;
    app.UserInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;

    var dest = "~/SRC/extras/modifying-pdfs/test.pdf";
    if (false) {
        saveFileToPDF(dest);
    }
    function saveFileToPDF(dest) {
        var doc = app.activeDocument;
        if (app.documents.length > 0) {
            var saveName = new File(dest);
            saveOpts = new PDFSaveOptions();
            saveOpts.compatibility = PDFCompatibility.ACROBAT5;
            saveOpts.generateThumbnails = true;
            saveOpts.preserveEditability = true;
            alert(saveName);
            doc.saveAs(saveName, saveOpts);
        }
    }

    // save and close
    if (app.documents.length > 0) {
        var docRef = app.activeDocument;
        docRef.close(SaveOptions.SAVECHANGES);
    }


    userInteractionLevel = originalInteractionLevel;
    //app.quit();
}