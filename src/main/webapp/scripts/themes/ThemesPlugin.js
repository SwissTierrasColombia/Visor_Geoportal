/* global chroma, Holder, LocaleManager, map */

var themesPlugin = {
    panel: null,
    themesListPanel: null,
    button: null,
    chroma: null,
    themes: [
        {
            "name": "Tematica 1",
            "id": "",
            "position": 12
        },
        {
            "name": "Tematica 2",
            "id": "json_examples/config.json",
            "position": 12
        },
        {
            "name": "Tematica 3",
            "id": "json_examples/config2.json",
            "position": 12
        }
    ],
    init: function (mapsList) {
        console.log("Themes:", mapsList);
        if (mapsList !== null) {
            this.themes = mapsList;
        }

        if (this.panel === null) {
            this.panel = $("#advance-themes-panel");
        }

        if (this.button === null) {
            this.button = $("#gis_themesBtn");
        }

        if (this.themesListPanel === null) {
            this.themesListPanel = this.panel.find("#advance-themes-panel-list");
        }

        if (this.chroma === null) {
            this.chroma = chroma.scale('YlGn').padding(0.15).colors(this.themes.length + 4);
        }

        //add themes to list
        this.themesListPanel.empty();
        var size = 4;
        if (this.themes.length === 2) {
            size = 6;
        } else if (this.themes.length === 1) {
            size = 12;
        }
        for (var i = 0; i < this.themes.length; i++) {
            var panel = $(
                    '<div class="col-xs-' + size + '">' +
                    '    <div class="base-maps-thumbnail">' +
                    '        <div class="caption">' +
                    '            <p><strong>' + this.themes[i].name + '</strong></p>' +
                    '        </div>' +
                    '        <div class="image view view-first">' +
                    (
                            this.themes[i].thumbnail ?
                            '   <img style="width: 100%; display: block;" sytle="background-size: 100% 100%;" src="' + this.themes[i].thumbnail + '" alt="image" />'
                            :
                            '   <img style="width: 100%; display: block;" sytle="background-size: 100% 100%;" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKUAAABaCAIAAABWjQFBAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gkODSINq0yspQAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAAo0lEQVR42u3RAQEAMAQAwVlOPcQngQTuI/xFdj2d6VvAW7zFW7zFW7zFW7zFW7zFW7x5i7d4i7d4i7d4i7d4i7d4i7d48xZv8RZv8RZv8RZv8RZv8RZv8eYt3uIt3uIt3uIt3uIt3uIt3uLNW7zFW7zFW7zFW7zFW7zFW7zFm7d4i7d4i7d4i7d4i7d4i7d4izdv8RZv8RZv8RZv8RZv8RZvrQ15VgKGWu72VQAAAABJRU5ErkJggg==" alt="image" />'
                            //'   <img style="width: 100%; display: block;" sytle="background-size: 100% 100%;" src="holder.js/100px100p?bg=' + this.chroma[i + 2] + '&text=theme preview" alt="image" />'
                            ) +
                    '            <div class="mask">' +
//                    '               <a href="' + window.location.pathname + '?config=' + this.themes[i].id + '">'+
                    '               <a href="#" data-theme-id="' + this.themes[i].id + '" id="theme_' + this.themes[i].id + '_anchor">' +
                    '                   <p id="open-text" data-locale_key="Advanced_Panel_Themes_Label_Open_Theme" data-locale_ref="text" class="localizedElement"></p>' +
                    '                   <div class="tools tools-bottom">' +
                    '                       <i class="fa fa-share"></i>' +
                    '                   </div>' +
                    '               </a>' +
                    '            </div>' +
                    '        </div>' +
                    '    </div>' +
                    '    <hr style="margin:5px 0;">' +
                    '</div>');
            this.themesListPanel.append(panel);

            var anchor = $(panel).find('#theme_' + this.themes[i].id + '_anchor');
            $(anchor).on('click', function () {
                var lat = map.getCenter().lat;
                var lon = map.getCenter().lon;
                var zoom = map.getZoom();

                window.location = window.location.pathname + '?config=' + $(this).data('theme-id') + '&lat=' + lat + '&lon=' + lon + '&zoom=' + zoom;
            });

            LocaleManager.refreshLocalizedElement($(panel).find("#open-text"));

            Holder.run({
                images: panel.find('img')[0]
            });
        }

    },
    /** ****************************************
     *  Enable/Disable search panel
     *  *****************************************/
    toggle: function () {
        if (!this.button.hasClass("btn-active")) {
            this.activate();
        } else {

            /*
             * If I want to deactivate but the featureGridPanel is open,
             * leave it open!
             */
            this.deactivateGeneral(true);
        }
    },
    activate: function () {
        this.button.addClass("btn-active");

        this.open();
    },
    deactivateGeneral: function (leaveFeatureGridPanelOpen) {
        this.button.removeClass("btn-active");

        this.close();
    },
    deactivate: function () {
        this.deactivateGeneral(false);
    },
    open: function () {

        this.panel.show();
    },
    close: function () {
        if (this.panel !== null)
            this.panel.hide();
    }
};