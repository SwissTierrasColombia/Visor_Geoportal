var ContextMenuController = {

    init: function () {
        $.contextMenu({
            selector: '.context-menu-one',
            callback: function (key, options) {
                switch (key) {
                    case "zoomToLayer":
                        redlines.zoomToLayer();
                        break;
                    case "reloadData":
                        redlines.reloadData(true);
                        break;
                    case "selectGeomType1":
                        redlines.selectGeomType($(this));
                        break;
                    case "selectGeomType2":
                        redlines.selectGeomType($(this));
                        break;
                    case "selectGeomType3":
                        redlines.selectGeomType($(this));
                        break;
                }
            },
            items: {
                "draw": {
                    "name": "Dibujo",
                    "items": {
                        "zoomToLayer": {name: "Zoom to layer", icon: "fa-arrows-alt"},
                        "reloadData": {name: "Reload data", icon: "fa-refresh"},
                        "sep1": "---------",
                        "selectGeomType1": {name: "Punto", icon: "fa-circle"},
                        "selectGeomType2": {name: "Línea", icon: "fa-share-alt"},
                        "selectGeomType3": {name: "Plígono", icon: "fa-square"},
                        //"sep2": "---------",
                    },
                    "draw": {
                        "name": "Medir",
                        "items": {
                            "selectGeomType1": {name: "Punto", icon: "fa-circle"},
                        }
                    }
                }
            }
        });
    }
};

$(document).ready(function () {
    //ContextMenuController.init();
});

/*
 $('.context-menu-one').on('click', function (e) {
 
 });
 */

