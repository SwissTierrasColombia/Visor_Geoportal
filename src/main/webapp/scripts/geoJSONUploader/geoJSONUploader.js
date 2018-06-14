/* global map, LocaleManager, Utils, AlertDialog */

var JsonUploader = function () {

    /*
     * This just retrieves the features from the JSON.
     */
    this.getFeaturesFromJSON = function (url, okFn, failFn) {

        var vector = new OpenLayers.Layer.Vector("GeoJSON", {
            projection: "EPSG:3116",
            strategies: [new OpenLayers.Strategy.Fixed()],
            protocol: new OpenLayers.Protocol.HTTP({
                url: url,
                format: new OpenLayers.Format.GeoJSON()
            })
        });

        map.addLayer(vector);
        //var bounds = vector.getDataExtent();
        //map.zoomToExtent(bounds);

    };
};

