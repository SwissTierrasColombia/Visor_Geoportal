(function ($) {
    var xtfid = 0;
    /**
     * Class XtfFileController
     */
    $.XtfFileController = function (parent, infile) {
        xtfid++;
        this.id = xtfid;
        this.ofile = infile;
        this.parent = (parent instanceof $) ? parent : $(parent);
        this.tr = $('<tr>');
        this.name = $('<td>', {'class': 'xtf-file-name'});
        this.tr.append(this.name);
        this.status = $('<td>', {'class': 'xtf-file-status'});
        this.tr.append(this.status);
        this.loading = $('<span>', {
            'class': 'badge badge-primary badge-pill',
            'style': 'background-color: white;'
        }).html('<img style="width: 17px; margin-top: 8px;" src="images/ajax-loader.gif"/>');
        this.status.append(this.loading);
        this.title = $('<div>', {'class': 'xtf-file-title'});

        this.container = $('<div>', {'class': '', 'id': 'xtflayers' + this.id});

        this.data = $('<ul>');
        this.cspdata = $('<li>', {'html': 'Informaci&oacute;n espacial', 'data-jstree': '{"icon":"images/map.png"}'});
        this.spdata = $('<ul>', {'class': 'xtf-table-layers'});
        this.data.append(this.cspdata);
        this.cspdata.append(this.spdata);

        this.caldata = $('<li>', {'html': 'Informaci&oacute;n alfanum&eacute;rica', 'data-jstree': '{"icon":"images/tables.png"}'});
        this.aldata = $('<ul>', {'class': 'xtf-table-layers'});
        this.data.append(this.caldata);
        this.caldata.append(this.aldata);

        this.container.append(this.data);

        this.name.append(this.title).append(this.container);
        this.title.html('<span class="icon-xtf xtf-file-icon"></span><span class="xtf-file-name">' + this.ofile.name + '</span>');
        this.parent.prepend(this.tr);
        this.nodes = {};
        this.InitEvents();
    };

    $.XtfFileController.prototype = {
        InitEvents: function () {
            this.data.hide();
            if (this.ofile.name.endsWith(".xtf") || this.ofile.name.endsWith(".itf")) {
                var data = new FormData();
                data.append('file[]', this.ofile);
                jQuery.ajax({
                    url: XTF_UPLOAD_URL,
                    data: data,
                    cache: false,
                    contentType: false,
                    processData: false,
                    useProxy: false,
                    type: 'POST',
                    method: 'POST',
                    context: this,
                    success: function (data) {
                        if (data && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                var proccessedFile = data[i];
                                if (proccessedFile.spatial_datasets) {
                                    for (var j = 0; j < proccessedFile.spatial_datasets.length; j++) {
                                        this.nodes['s' + i + 'e' + j] = new $.XtfDatasetController(this.spdata, proccessedFile.spatial_datasets[j], "spatial", proccessedFile.transfer.substring(0, proccessedFile.transfer.length - 4), 's' + i + 'e' + j, proccessedFile.result_id);
                                    }
                                }
                                if (proccessedFile.alphanumeric_datasets) {
                                    for (var j = 0; j < proccessedFile.alphanumeric_datasets.length; j++) {
                                        this.nodes['a' + i + 'e' + j] = new $.XtfDatasetController(this.aldata, proccessedFile.alphanumeric_datasets[j], "alphanumeric", proccessedFile.transfer.substring(0, proccessedFile.transfer.length - 4), 'a' + i + 'e' + j);
                                    }
                                }
                            }
                            this.data.show();
                            $('#xtflayers' + this.id).on('select_node.jstree', this.OnClick.bind(this)).jstree();
                            this.status.css('color', 'green').html('<img style="width: 17px; margin-top: 10px;" src="images/ok.png"/>');
                        } else {
                            this.status.css('color', 'red').html("Error, sin datos");
                            this.Destroy(3000);
                        }
                    }
                }).fail(function (jqXHR, textStatus, error) {
                    this.status.css('color', 'red').html("Error interno del servidor");
                    this.Destroy(3000);
                });
            } else {
                this.status.css('color', 'red').html("Formato invalido, se espera un XTF o ITF");
                this.Destroy(3000);
            }
        },
        OnClick: function (e, d) {
            try {
                this.nodes[d.node.data.id].OnClick();
            } catch (e) {
            }
        },
        Destroy: function (t) {
            t = typeof t !== 'undefined' ? t : 100;
            setTimeout(function () {
                this.tr.hide(1000, function () {
                    try {
                        this.tr.remove();
                    } catch (e) {
                    }
                });
            }.bind(this), t);
        }
    };
}(jQuery));