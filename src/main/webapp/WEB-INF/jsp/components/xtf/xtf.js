/*

var xtfUploadIdleTime = 0;
var xtfUploadIdleLimit = 2;
var xtfUploadIdleInterval;
var xtfProcessingFiles = 0;

function xtfUploadStartInterval() {
    if (!xtfUploadIdleInterval) {
        xtfUploadIdleInterval = setInterval("xtfUploadTimerIncrement()", 100);
    }
}

function xtfUploadClearInterval() {
    clearInterval(xtfUploadIdleInterval);
    xtfUploadIdleInterval = null;
    xtfUploadIdleTime = 0;
}

function xtfUploadTimerIncrement() {
    xtfUploadIdleTime = xtfUploadIdleTime + 1;
    if (xtfUploadIdleTime >= xtfUploadIdleLimit) {
        xtfUploadClearInterval();
        $("#dragFileContent").hide();
    }
}

function dropHandler(files) {
    xtfUploadClearInterval();
    var hasValidFiles = false;

    $("#dragFileContent").find("#result_detail_list").empty();
    var flist = $("#xtfFileList");
    flist.html('');
    var validFiles = [];
    for (var i = 0, file; i < files.length; i++) {
        var file = files[i];
        if (file.name.endsWith(".xtf") || file.name.endsWith(".itf")) {
            xtfProcessingFiles++;
            validFiles.push(file);
            flist.append(xtfGetListItem(file.name));
        }
    }
    if (validFiles.length) {
        var data = new FormData();
        data.append('file[]', validFiles);

        //show filename
        $("#dragFileContent").find(".dragMarkup").collapse('hide');
        $("#processingFiles").collapse('show');
        $("#nameFileProcessing").text(file.name);


        //send file to ili2geojson service
        //
        jQuery.ajax({
            url: XTF_UPLOAD_URL,
            data: data,
            cache: false,
            contentType: false,
            processData: false,
            useProxy: false,
            type: 'POST',
            method: 'POST',
            context: file,
            success: function (data) {

                if (data && data.length > 0) {
                    $("#dragFileContent").find(".result_detail").collapse('show');
                    $("#resultDetail").collapse('show');
                    for (var i = 0; i < data.length; i++) {
                        var proccessedFile = data[i];
                        if (proccessedFile.datasets) {
                            for (var j = 0; j < proccessedFile.datasets.length; j++) {
                                var res = proccessedFile.datasets[j];
                                $("#dragFileContent").find("#result_detail_list").append(
                                        '<a style="display: block;height: 30px; padding:5px;" title="' + this.name + " - " + res.key + '"' +
                                        '       href="#"' +
                                        //'       href="' + XTF_DOWNLOAD_URL + '/' + proccessedFile.result_id + '/' + res.key + '/geojson"'+
                                        '       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"' +
                                        '       data-dataset-name="' + proccessedFile.result_id + '" data-json-id="' + res.key + '"><div style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" class="col-md-10">' + this.name + " - " + res.key + '</div>' +
                                        '   <span class="badge badge-primary badge-pill">' + res.count + '</span>' +
                                        '</a>');
                            }
                        }
                    }
                    $("#dragFileContent").find(".list-group-item").on('click', function () {
                        var dataset = $(this).data('datasetName');
                        var jsonId = $(this).data('jsonId');

                        var urlData = XTF_DOWNLOAD_URL + '/' + dataset + '/' + jsonId + '/geojson';

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
                            "title": "title",
                            "name": "name",
                            "position": 10,
                            "enabled": true
                        };

                        var geojsonLayerConfig = new LayerConfig(objectConfig);
                        
                        // Adds the layer to the LayerConfigCatalog
                        catalog.addLayerToConfig(geojsonLayerConfig);

                        LoadLayersUtils.loadStdLayerInSelectedLayerTreeFromOutside(geojsonLayerConfig);
                    });
                } else {
                    $("#dragFileContent").find(".dragMarkup > h3").text("No data");
                }
            }
        }).fail(function (jqXHR, textStatus, error) {
            if (Utils.isEmpty(error)) {
                error = LocaleManager.getKey("Ajax_General_Error");
            }
            AlertDialog.createOkDefaultDialog(LocaleManager.getKey("AlertDialog_Error_Title"), error, "error");
            resetDragZone();
        });
    }

    if (!hasValidFiles) {
        $("#dragFileContent").find(".dragMarkupErrorMsg").text("No valid files found, only .xtf and .itf files allowed");
    }
}

function resetDragZone() {
    $(".dragMarkupErrorMsg, .dragMarkupMsg").hide();
    $("#processingFiles").collapse('hide');
    $("#dragMarkup").collapse('show');
    $("input_uploadxtf").replaceWith($("input_uploadxtf").val('').clone(true));
}

function wait(ms) {
    var start = new Date().getTime();
    var end = start;
    while (end < start + ms) {
        end = new Date().getTime();
    }
}

function dragOverHandler(event) {
    xtfUploadClearInterval();
    if ($("#xtfdownload-panel:hidden").length > 0) {
        //$("#dragFileContent").show();
        showUploadComponent();
    }

    if ($("#dragFileContent").find(".dragMarkup:hidden").length > 0) {
        $("#dragFileContent").find(".dragMarkup > h3").text("Upload files");
        $("#dragFileContent").find(".dragMarkup").collapse('show');
        $("#dragFileContent").find(".result_detail").collapse('hide');
    }

}
function dragEndHandler(event) {
    //$("#dragFileContent").hide();
    xtfUploadStartInterval();
}

function resetXTFUploadDialog() {
    $("#dragFileContent").hide();
    $("#dragFileContent").find("#result_detail_list").empty();
    $("#dragFileContent").find(".dragMarkup > h3").text("Upload files");
    $("#dragFileContent").find(".dragMarkup").collapse('show');
    $("#dragFileContent").find(".result_detail").collapse('hide');
}

function showUploadComponent() {
    AdvancedPanel.toggleAdvancedTools($('#xtfdownload-btn'));
    $('#xtfTabsComponent a[href="#uploadXtf"]').tab('show');
}

jQuery(function ($) {
    $('#dragMarkup').on('click', function (e) {
        e.preventDefault();
        $("#input_uploadxtf").trigger('click');
    });

    $('#jstree').jstree();
});

function xtfGetListItem(msg) {
    var li = $("<li>", {
        'class': 'list-group-item text-left'
    }).html(msg);
    li.append($('<span>', {
        'class': 'badge badge-primary badge-pill',
        'style': 'background-color: white;'
    }).html('<img style="width: 17px;" src="images/ajax-loader.gif"/>'));
    return li;
}
//*/



