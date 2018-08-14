(function ($) {

    /**
     * Class XtfComponent
     */
    $.XtfComponent = function (element) {
        this.element = (element instanceof $) ? element : $(element);
        this.dragMarkup = $("#dragmarkup");
        this.xtfBtnUpload = $("#xtfbtnupload");
        this.dragMarkup.hide();
        this.xtfBodyTable = $("#xtfbodytable");
        this.xtfFooterTable = $("#xtffootertable");
        this.xtfInput = $("<input>", {'id': 'input_uploadxtf', 'type': 'file', 'multiple': ''});
        this.xtfFooterTable.append(this.xtfInput);
        this.dragMarkupTimeout = null;
        this.InitEvents();
    };

    $.XtfComponent.prototype = {
        InitEvents: function () {
            this.xtfInput.change(this.InputChange.bind(this));
            window.addEventListener("dragover", this.DragOver.bind(this), false);
            window.addEventListener("drop", this.Drop.bind(this), false);
            this.xtfBtnUpload.click(this.InputFileClick.bind(this))
        },
        setShowDragMarkup: function (show) {
            if (show) {
                this.dragMarkup.show();
            } else {
                this.dragMarkup.hide();
            }
        },
        DragOver: function (e) {
            e = e || event;
            e.preventDefault();
            if (e.dataTransfer && e.dataTransfer.types && e.dataTransfer.types.indexOf("Files") !== -1) {
                if (this.dragMarkupTimeout != null)
                    clearTimeout(this.dragMarkupTimeout);
                this.dragMarkupTimeout = setTimeout(this.HideMarkup.bind(this), 2000);
                if ($("#xtfdownload-panel:hidden").length > 0) {
                    AdvancedPanel.toggleAdvancedTools($('#xtfdownload-btn'));
                }
                $('#xtfTabsComponent a[href="#tabtwo"]').tab('show');
                this.setShowDragMarkup(true);
            }
        },
        HideMarkup: function (e) {
            this.dragMarkup.hide();
        },
        InputChange: function (e) {
            this.Drop(e);
        },
        InputFileClick: function(e){
            this.xtfInput.click();
        },
        Drop: function (e) {
            e = e || event;
            e.stopPropagation();
            e.preventDefault();
            this.setShowDragMarkup(false);
            let files = [];
            if (e.dataTransfer && e.dataTransfer.types && e.dataTransfer.types.indexOf("Files") !== -1) {
                files = e.dataTransfer.files;
            } else if (e.target && e.target.files) {
                files = e.target.files;
            }
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                new $.XtfFileController(this.xtfBodyTable, file);
            }
        }
    };
}(jQuery));