/* global themesPlugin, kmlupload, catalogCsw, coordinates, searchP, comments, redlines, controls, testPlugin */

/**
 * AdvancedPanel class
 */
function AdvancedPanel() {

}
;

/**
 * Toggle action on advanced panel buttons 
 * - redlines
 * - comments
 * - alert
 * - search
 * 
 * Enable/Disable the selected function 
 * 
 * @param toolRefButton
 */
AdvancedPanel.toggleAdvancedTools = function (toolRefButton) {
    var tool = toolRefButton.data("tool");

    /* ****************************
     * Deactivate ALL controls!!
     * *****************************
     
     /* except the case of print.
     * Print is not a real control and calling "print.deactivate" just
     * closes the panel!
     */
    if (tool !== "print") {
        /*
         * Deactivate ALL CONTROLS!!!!
         */
        controls.deactivate();
    }

    if (tool !== "uploadkml") {
        kmlupload.deactivate();
    }

    if (tool !== "redlines") {
        redlines.closePanel();
    }

    if (tool !== "comments") {
        comments.deactivate();
    }

    if (tool !== "searchwfs") {
        searchP.deactivate();
    }

//	if(tool != "alerts") {
//		if (tool === "print") {
//			alerts.closePanelGeneralForPrint();
//		}
//		else {
//			alerts.closePanelGeneral();	
//		}
//	}

    if (tool !== "print") {
        print.deactivate();
    }

    if (tool !== "coordinates") {
        coordinates.deactivate();
    }

    if (tool !== "catalogcsw") {
        catalogCsw.deactivate();
    }
    if (tool !== "themes") {
        themesPlugin.deactivate();
    }
    if (tool !== "test") {
        testPlugin.deactivate();
    }

    if (tool !== "xtfdownload") {
        xtfDownload.deactivate();
    }



    switch (tool) {
        case "redlines":
            redlines.toggle(toolRefButton);
            break;

        case "comments":
            comments.toggle(toolRefButton);
            break;

//	case "alerts":
//		alerts.toggle(toolRefButton);
//		break;

        case "searchwfs":
            searchP.toggle(toolRefButton);
            break;

        case "print":
            print.toggle(toolRefButton);
            break;

        case "coordinates":
            coordinates.toggle(toolRefButton);
            break;

        case "uploadkml":
            kmlupload.toggle();
            break;

        case "catalogcsw":
            catalogCsw.toggle(toolRefButton);
            break;

//	case "gisOverview":
//		gisOverview.toggle(toolRefButton);		
//		break;

        case "themes":
            themesPlugin.toggle(toolRefButton);
            break;
        case "test":
            testPlugin.toggle(toolRefButton);
            break;
        case "xtfdownload":
            xtfDownload.toggle(toolRefButton);
            break;
    }

};