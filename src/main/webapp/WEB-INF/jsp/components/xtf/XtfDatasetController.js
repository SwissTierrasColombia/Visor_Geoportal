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
                    "enabled": true,
                    "getBbox": function (layerName) {
                        console.log(this.getLayerConfigById);
                        return {
                            "minx": 0,
                            "miny": 0,
                            "maxx": 0,
                            "maxy": 0
                        };
                    }
                };
                var geojsonLayerConfig = new LayerConfig(objectConfig);
                // Adds the layer to the LayerConfigCatalog
                catalog.addLayerToConfig(geojsonLayerConfig);
                LoadLayersUtils.loadStdLayerInSelectedLayerTreeFromOutside(geojsonLayerConfig);
            } catch (e) {
                console.error(e);
            }
        }
    };
}(jQuery));