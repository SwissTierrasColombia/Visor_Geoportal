(function ($) {

    /**
     * Class XtfFileController
     */
    $.XtfDatasetController = function (parent, indata, type, rpl, id, datasetName) {
        this.id = id;
        this.datasetName = datasetName;
        this.odata = indata;
        this.type = type;
        this.parent = (parent instanceof $) ? parent : $(parent);
        var logo = 'images/table.png';
        if (this.type === "spatial") {
            switch (this.odata.type) {
                case 'Point':
                    logo = 'images/point.png';
                    break;
                case 'Polygon':
                    logo = 'images/polygon.png';
                    break;
                case 'LineString':
                    logo = 'images/line.png';
                    break;
            }
        }
        this.li = $('<li>', {'class': 'row', 'data-jstree': '{"icon":"' + logo + '"}'});
        this.li.html(this.odata.key.replace(rpl + "_", "").replace(".json", ""));
        this.li.data('id', this.id);
        this.parent.append(this.li);
    };

    $.XtfDatasetController.prototype = {
        OnClick: function () {
            var dataset = this.datasetName;
            var jsonId = this.odata.key;
            var urlData = XTF_DOWNLOAD_URL + '/' + dataset + '/' + jsonId + '/json';
            console.log("Datos", this.odata);
            if (this.type === "spatial") {
                try {
                    var objectConfig = {
                        "id": "prueba",
                        "url": urlData,
                        "group": "345",
                        "description": "description",
                        "responsible": "load",
                        "external": false,
                        "downloadable": false,
                        "showInfoDialog": false,
                        "attributeNameForInfo": "",
                        "referenceDate": "",
                        "groupName": "Load XTF",
                        "source": "geojson",
                        "title": jsonId.replace(".json", ""),
                        "name": "name",
                        "position": 10,
                        "enabled": true
                    };
                    var geojsonLayerConfig = new LayerConfig(objectConfig);
                    console.log("geojsonLayerConfig", geojsonLayerConfig);
                    // Adds the layer to the LayerConfigCatalog
                    catalog.addLayerToConfig(geojsonLayerConfig);
                    LoadLayersUtils.loadStdLayerInSelectedLayerTreeFromOutside(geojsonLayerConfig);
                } catch (e) {
                    console.error(e);
                }
            } else {
                $.getJSON(urlData, function (jsondata) {
                    console.log("Data:", jsondata);
                    if (jsondata.hasOwnProperty("features")) {
                        var dialogOptions = {
                            closeFn: function () {
                                console.log("Close");
                                this.dialogDiv.dialog("close");
                            }.bind(this),
                            height: 350,
                            width: 1000,
                            resizable: false,
                            modal: false,
                            extensions: true,
                            collapsable: true
                        };
                        var html = "<table class='table xtf-data-table'>";
                        var header = {};
                        $.each(jsondata.features, function (k, v) {
                            $.each(v.properties, function (id, val) {
                                if (!header.hasOwnProperty(id)) {
                                    header[id] = true;
                                }
                            });
                        });
                        html += "<thead><tr>";
                        $.each(header, function (id, val) {
                            html += "<th>"+id+"</th>";
                        });
                        html += "</tr></thead><tbody>";
                        console.log(header);
                        $.each(jsondata.features, function (k, v) {
                            html += "<tr>";
                            console.log("array", v);
                            $.each(header, function (id, val) {
                                if (!v.properties.hasOwnProperty(id))
                                    html += "<td>NULL</td>";
                                else
                                    html += "<td>" + v.properties[id] + "</td>";
                            });
                            html += "</tr>";
                        });
                        html += "</tbody></table>";
                        var a = $('<div>').html(html);
                        this.dialogDiv = DialogUtils.createDialog(jsondata.name, {}, dialogOptions, a);
                        this.dialogDiv.dialog("open");
                    }
                }.bind(this));
            }
        }
    };
}(jQuery));