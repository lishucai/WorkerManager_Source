<%@ Page Language="C#" AutoEventWireup="true" CodeFile="viewer.aspx.cs" Inherits="views_viewer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1, user-scalable=no" />
    <meta charset="utf-8" />
    <title></title>
    <!-- The Viewer CSS -->
    <link rel="stylesheet" href="https://developer.api.autodesk.com/viewingservice/v1/viewers/style.min.css" type="text/css" />
    <script src="/jquery/jquery-3.2.1.js"></script>
    <script src="/scripts/bimoun.core.js"></script>
    <!-- Developer CSS -->
    <style>
        * {
            margin: 0;
            padding: 0;
        }

        #MyViewerDiv {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            background-color: #F0F8FF;
        }

        #MyNextButton {
            position: absolute;
            top: 5px;
            left: 5px;
            z-index: 1;
            font-size: 40px;
            cursor: pointer;
        }
    </style>
    <script>
        /**
 * Callback function for "Next" button.
 * Attempts to load the next from the document. If there is only one model, then the
 * current model gets unloaded and then is loaded again.
 */
        function loadNextModel() {
            viewer.tearDown();
            viewer.setUp(viewer.config);

            // Next viewable index. Loop back to 0 when overflown.
            indexViewable = (indexViewable + 1) % viewables.length;
            loadModel();
        }

        function loadModel() {
            var initialViewable = viewables[indexViewable];
            var svfUrl = lmvDoc.getViewablePath(initialViewable);
            var modelOptions = {
                sharedPropertyDbPath: lmvDoc.getPropertyDbPath()
            };
            viewer.loadModel(svfUrl, modelOptions, onLoadModelSuccess, onLoadModelError);
        }
    </script>
</head>
<body>

    <!-- The Viewer will be instantiated here -->
    <div id="MyViewerDiv"></div>
   <%-- <button id="MyNextButton" onclick="loadNextModel()">Next!</button>--%>

    <!-- The Viewer JS -->
    <script src="https://developer.api.autodesk.com/viewingservice/v1/viewers/three.min.js"></script>
    <script src="https://developer.api.autodesk.com/viewingservice/v1/viewers/viewer3D.min.js"></script>

    <!-- Developer JS -->
    <script>
        var viewer;
        var lmvDoc;
        var viewables;
        var indexViewable;

        var options = {
            env: 'AutodeskProduction',
            getAccessToken: function (onGetAccessToken) {

                var url = "GetTokenHandler.ashx";
                var data = {

                };
                success = function (data, textStatus, jqXHR) {
                    var accessToken = data.access_token;
                    var expireTimeSeconds = 86400;
                    onGetAccessToken(accessToken, expireTimeSeconds);
                }
                $.post(url, data, success, "json");
            }
        };


        // var documentId = 'urn:dXJuOmFkc2sub2JqZWN0czpvcy5vYmplY3Q6Y2hpbmFpc3NfYnVja2V0LyVFRiVCRiVCRCVFRiVCRiVCRCVFRiVCRiVCRCVFRiVCRiVCRCVFRiVCRiVCRCVFRiVCRiVCRCVFRiVCRiVCRCVFRiVCRiVCRDEubndk';
        var documentId = 'urn:' + getQueryString('urn');
        Autodesk.Viewing.Initializer(options, function onInitialized() {
            Autodesk.Viewing.Document.load(documentId, onDocumentLoadSuccess, onDocumentLoadFailure);
        });

        /**
        * Autodesk.Viewing.Document.load() success callback.
        * Proceeds with model initialization.
        */
        function onDocumentLoadSuccess(doc) {

            // A document contains references to 3D and 2D viewables.
            viewables = Autodesk.Viewing.Document.getSubItemsWithProperties(doc.getRootItem(), { 'type': 'geometry' }, true);
            if (viewables.length === 0) {
                console.error('Document contains no viewables.');
                return;
            }

            // Create Viewer instance and load model.
            var viewerDiv = document.getElementById('MyViewerDiv');
            viewer = new Autodesk.Viewing.Private.GuiViewer3D(viewerDiv);
            var errorCode = viewer.start();

            // Check for initialization errors.
            if (errorCode) {
                console.error('viewer.start() error - errorCode:' + errorCode);
                return;
            }

            // Choose any of the available viewables.
            indexViewable = 0;
            lmvDoc = doc;

            // Everything is set up, load the model.
            loadModel();
        }

        /**
         * Autodesk.Viewing.Document.load() failuire callback.
         */
        function onDocumentLoadFailure(viewerErrorCode) {
            console.error('onDocumentLoadFailure() - errorCode:' + viewerErrorCode);
        }

        /**
         * viewer.loadModel() success callback.
         * Invoked after the model's SVF has been initially loaded.
         * It may trigger before any geometry has been downloaded and displayed on-screen.
         */
        function onLoadModelSuccess(model) {
            console.log('onLoadModelSuccess()!');
            console.log('Validate model loaded: ' + (viewer.model === model));
            console.log(model);
        }

        /**
         * viewer.loadModel() failure callback.
         * Invoked when there's an error fetching the SVF file.
         */
        function onLoadModelError(viewerErrorCode) {
            console.error('onLoadModelError() - errorCode:' + viewerErrorCode);
        }

    </script>
</body>
</html>
