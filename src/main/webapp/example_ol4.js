
var exampleColombia = function() {

   	/*
	 * Map
	 */
	var map = new ol.Map({
      //layers: layers,
      target: 'map',
      view: new ol.View({
    	center: [-10997148, 4569099],
        zoom: 4
      }),
//      interactions: ol.interaction.defaults().extend([
//	    new ol.interaction.DragRotateAndZoom()
//	  ])
      controls: ol.control.defaults({
          attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
            collapsible: false
          })
        }),
    });
	
	
	//OSM
	var osmLayer = new ol.layer.Tile({
        source: new ol.source.OSM()
    });
	
	map.addLayer(osmLayer);
	
	/*
	 * Tiled
	 * Note: 'version' param necessary as it seems GWC supports 1.1 version (?)
	 */
	var layerMallaTiled = new ol.layer.Tile({
		  source: new ol.source.TileWMS({
		    url: 'http://geo.proadmintierra.info/geoserver/wms',
		    params: {
		    	'LAYERS': 'interlis:mvi',
		    	'FORMAT': 'image/png',
		    	'TILED': true
		    },
		    serverType: 'geoserver'
		  })
	});
	//map.addLayer(layerMallaTiled);
	
	/*
	 * Tiled (GWC)
	 * Note: 'version' param necessary as it seems GWC supports 1.1 version (?)
	 */
	var layerMallaTiledGWC = new ol.layer.Tile({
		  source: new ol.source.TileWMS({
		    url: 'http://geo.proadmintierra.info/geoserver/gwc/service/wms',
		    params: {
		    	'LAYERS': 'interlis:mvi',
		    	'FORMAT': 'image/png',
		    	'TILED': true,
		    	'VERSION' : '1.1.1'
		    }
		  })
	});
	map.addLayer(layerMallaTiledGWC);
	
	/*
	 * No tiled
	 */
	var mallaNoTiled = new ol.layer.Image({
	  //extent: [-13884991, 2870341, -7455066, 6338219],
	  source: new ol.source.ImageWMS({
	    url: 'http://geo.proadmintierra.info/geoserver/wms',
	    params: {
	    	'LAYERS': 'interlis:mvi',
	    	'FORMAT': 'image/png'
	    },
	    ratio: 1,
	    serverType: 'geoserver'
	  })
	});
	//map.addLayer(mallaNoTiled);
};




var startExample = function() {
	var layers = [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      }),
      
      /*
       * Example with WMS tiled
       */
      new ol.layer.Tile({
         extent: [-13884991, 2870341, -7455066, 6338219],
         source: new ol.source.TileWMS({
           url: 'https://ahocevar.com/geoserver/wms',
           params: {'LAYERS': 'topp:states', 'TILED': true},
           serverType: 'geoserver'
         })
      })
     
      /*
       * Example with WMS single tile
       */
//      new ol.layer.Image({
//        extent: [-13884991, 2870341, -7455066, 6338219],
//        source: new ol.source.ImageWMS({
//          url: 'https://ahocevar.com/geoserver/wms',
//          params: {
//          	'LAYERS': 'topp:states',
//          	'FORMAT': 'image/png'
//          },
//          ratio: 1,
//          serverType: 'geoserver'
//        })
//      })
    ];
    var map = new ol.Map({
      layers: layers,
      target: 'map',
      view: new ol.View({
        center: [-10997148, 4569099],
        zoom: 4
      })
    });
    
};



