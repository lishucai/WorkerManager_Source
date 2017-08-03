function enableLayoutAutoSize(menuSelector, mainContentSelector) {

    var topbarHeight = $("#caption").height() + 2;
    var h = window.innerHeight - topbarHeight - 2;
    $(menuSelector).height(h);

    var w = window.innerWidth - $(menuSelector).width();
    $(mainContentSelector).height(h);
    $(mainContentSelector).width(w);

    $(window).resize(function () {
        var topbarHeight = $("#caption").height() + 2;
        var h = window.innerHeight - topbarHeight;
        $(menuSelector).height(h);
        var w = window.innerWidth - $(menuSelector).width();
        $(mainContentSelector).height(h);
        $(mainContentSelector).width(w);
    });
}

function loadMap() {
    require([
  "esri/Map",
  "esri/views/SceneView",
  "esri/layers/FeatureLayer",
  "esri/renderers/UniqueValueRenderer",
  "dojo/domReady!"
    ], function (Map, SceneView, FeatureLayer, UniqueValueRenderer) {

        var map = new Map({
            basemap: "satellite"
        });

        // Park and Open Space (Polygons)
        var featureLayer = new FeatureLayer({
            url: "https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Parks_and_Open_Space/FeatureServer",
            outFields: ["*"],
            popupTemplate: {
                title: "{Name}",
                content: "{*}"
            }
        });
        map.add(featureLayer);

        // Trails (Lines)
        var featureLayer2 = new FeatureLayer({
            url: "https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trails/FeatureServer",
            outFields: ["*"],
            popupTemplate: {
                title: "{TRL_NAME}",
                content: "{*}"
            },
            minScale: 0,
            maxScale: 0,
            definitionExpression: "ELEV_GAIN < 250"

        });

        var renderer = UniqueValueRenderer.fromJSON({
            "type": "uniqueValue",
            "field1": "USE_BIKE",
            "uniqueValueInfos": [
              {
                  "value": "Yes",
                  "label": "Yes",
                  "symbol": {
                      "color": [
                        0,
                        112,
                        255,
                        255
                      ],
                      "width": 1.5,
                      "type": "esriSLS",
                      "style": "esriSLSSolid"
                  }
              },
              {
                  "value": "No",
                  "label": "No",
                  "symbol": {
                      "color": [
                        20,
                        0,
                        0,
                        0
                      ],
                      "width": 1.5,
                      "type": "esriSLS",
                      "style": "esriSLSSolid"
                  }
              }
            ]
        });

        featureLayer2.renderer = renderer;
        map.add(featureLayer2);

        // Trail Heads (Points)
        var featureLayer3 = new FeatureLayer({
            url: "https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trailheads/FeatureServer",
            outFields: ["TRL_NAME", "CITY_JUR", "LAT", "LON"],
            popupTemplate: {
                title: "{TRL_NAME}",
                content: "This trail is in {CITY_JUR} and located at {LAT}, {LON}."
            }
        });
        map.add(featureLayer3);

        var view = new SceneView({
            container: "viewDiv",
            map: map
        });

        view.then(function () {
            view.goTo({
                center: [118.12844, 24.503379],
                tilt: 70,
                zoom: 15
            })
        });

    });
}