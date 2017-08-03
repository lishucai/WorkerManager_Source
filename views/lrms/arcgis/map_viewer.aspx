﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="map_viewer.aspx.cs" Inherits="views_lrms_arcgis_map_viewer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no" />
    <title>DevLabs - Create a 3D map with a layer</title>
    <style>
        html, body, #viewDiv {
            padding: 0;
            margin: 0;
            height: 100%;
            width: 100%;
        }
    </style>
    <link rel="stylesheet" href="https://js.arcgis.com/4.3/esri/css/main.css"/>
    <script src="https://js.arcgis.com/4.3/"></script>

    <script>
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

        });</script>
</head>
<body>
    <div id="viewDiv"></div>
</body>
</html>
