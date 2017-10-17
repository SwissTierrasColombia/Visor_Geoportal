/* global chroma, Holder, LocaleManager */

var themesPlugin = {
    panel: null,
    themesListPanel: null,
    button: null,
    chroma: null,
    themes: [
        {
            "name": "Tematica 1",
            "code": "",
            "position": 12
        },
        {
            "name": "Tematica 2",
            "code": "json_examples/config.json",
            "position": 12
        },
        {
            "name": "Tematica 3",
            "code": "json_examples/config2.json",
            "position": 12
        }
    ],
    init: function () {
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
        for (var i = 0; i < this.themes.length; i++) {
            var panel = $(
                    '<div class="col-xs-4">' +
                    '    <div class="base-maps-thumbnail">' +
                    '        <div class="caption">' +
                    '            <p><strong>' + this.themes[i].name + '</strong></p>' +
                    '        </div>' +
                    '        <div class="image view view-first">' +
                    '            <img style="width: 100%; display: block;" sytle="background-size: 100% 100%;" src="holder.js/100px100p?bg=' + this.chroma[i + 2] + '&text=theme preview" alt="image" />' +
                    '            <div class="mask">' +
                    '               <a href="' + window.location.pathname + '?config=' + this.themes[i].code + '">'+
                    '                   <p id="open-text" data-locale_key="Advanced_Panel_Themes_Label_Open_Theme" data-locale_ref="text" class="localizedElement"></p>' +
                    '                   <div class="tools tools-bottom">' +
                    '                       <i class="fa fa-share"></i>' +
                    '                   </div>'+
                    '               </a>' +
                    '            </div>' +
                    '        </div>' +
                    '    </div>' +
                    '    <hr style="margin:5px 0;">' +
                    '</div>');
            this.themesListPanel.append(panel);
            
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