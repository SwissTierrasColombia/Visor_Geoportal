<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> --%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@ page
    import="it.gesp.geoportal.locale.LocaleUtils, it.gesp.geoportal.services.LoginService,it.gesp.geoportal.constants.Permissions,it.gesp.geoportal.dao.entities.User,it.gesp.geoportal.services.LogService"%>

    <!DOCTYPE html>
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

            <%@ include file="admin_config_common_js.jspf"%>

            <!-- Manager Map Settings scripts and CSS-->

            <link rel="stylesheet" href="css/admin/managerMapSettings.css"
                  type="text/css">
            <script type="text/javascript"
            src="scripts/admin/mapSettings/managerMapSettings.js"></script>

            <!-- Start script -->
            <script>
                var validator = null;

                $(document).ready(function () {
                    LocaleManager.refreshLocale();
                    AdminMenu.setMapSettingsConfigPageActive();

                    mMapSettings.init();
                    $.ajax({
                        url: './roles',
                        type: 'POST',
                        dataType: 'json',
                        data: {oper: 'roles'}
                    }).done(function (response) {
                        var cont = $("#mm_roles");
                        $.each(response.result.data, function (i, rol) {
                            var chk_cont = $("<tr>", {});
                            var chk_cont2 = $("<td>", {'class':'mm_role_name', 'html': rol.roleName});
                            var chk = $("<input>", {
                                type: "checkbox",
                                value: rol.idRole,
                                class: "mm_roles"
                            });
                            chk_cont2.append(chk);
                            chk_cont.append(chk_cont2);
                            cont.append(chk_cont);
                        });
                    });
                });
            </script>

            <style>
                #scales_buttons input, #scales_buttons div, #resolutions_buttons input,
                #resolutions_buttons div {
                    float: left;
                }

                #scales-add, #scales-delete, #resolutions-add, #resolutions-delete {
                    /* 	padding: 3px 3px 0px 3px !important; */
                    padding: 1px 2px 0px 2px !important;
                    font-size: 9px !important;
                    margin-top: 2px;
                }

                #scales-add, #resolution-add {
                    margin-right: 8px;
                }

                #scale-input, #resolution-input {
                    margin-right: 10px;
                }

                #list_scales, #list_resolutions {
                    width: 368px;
                    word-wrap: break-word;
                    list-style-type: none;
                    PADDING-LEFT: 0px;
                    margin-top: 0px;
                    padding-left: 300px;
                }

                #list_scales .ui-selecting, #list_resolutions .ui-selecting {
                    background: #b0bed9;
                }

                #list_scales .ui-selected, #list_resolutions .ui-selected {
                    background: #b0bed9;
                }

                #list_scales li, #list_resolutions li {
                    margin: 2px;
                    padding: 0.4em;
                    /*height: 18px;*/
                    width: 180px;
                }

                #radio_container {
                    padding-top: 0px;
                }
            </style>

            <style>
                table.dataTable, table.dataTable th, table.dataTable td {
                    white-space: normal !important;
                }
            </style>

            <style>
                .thumb {
                    height: 75px;
                    border: 1px solid #000;
                    margin: 10px 5px 0 0;
                }
            </style>

        </head>

        <body>
            <t:generic_admin_page>
                <jsp:attribute name="header">
                </jsp:attribute>
                <jsp:attribute name="footer">
                </jsp:attribute>

                <jsp:body>

                    <div id="m-maps">
                        <div id="m-panel-header">
                            <div data-locale_key="Manager_Map_TitlePanelMaps"
                                 data-locale_ref="text" class="localizedElement m-panel-title"></div>
                            <div class="m-toolbars manager-toolbar">
                                <div id="m-maps-add" data-locale_key="Manager_Map_Button_AddMap"
                                     data-locale_ref="title"
                                     class="localizedElement grid-toolbar-item"
                                     onclick="mMapSettings.openDialogAddMap();">
                                    <i class="fa fa-plus fa-2x"></i>
                                </div>

                                <div id="m-maps-update" data-locale_key="Manager_Map_Button_UpdateMap"
                                     data-locale_ref="title"
                                     class="localizedElement grid-toolbar-item"
                                     onclick="mMapSettings.openDialogUpdateMap();">
                                    <i class="fa fa-edit fa-2x"></i>
                                </div>

                                <div id="m-maps-delete" data-locale_key="Manager_Map_Button_DeleteMap"
                                     data-locale_ref="title"
                                     class="localizedElement grid-toolbar-item"
                                     onclick="mMapSettings.openDialogDeleteMap();">
                                    <i class="fa fa-minus fa-2x"></i>
                                </div>
                            </div>
                        </div>

                        <div id="m-maps-list">
                            <table id="maps-dt"></table>
                        </div>
                    </div>

                </jsp:body>

            </t:generic_admin_page>


            <form id="form-addmap-dialog" onSubmit="return false;" style="display:none;">
                <div id="form-dialog-header" data-locale_key="Manager_Maps_HeaderForm_Add"
                     data-locale_ref="text" class="localizedElement data-grid-form-header"></div>

                <div class="header">
                </div>
                <input type="hidden" id="map-input-id">
                <div class="form-items-container">
                    <div class="form-items-left">
                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Label_NameMap" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input type="text" id="name-input" required></div>
                        </div>
                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Label_MapThumbnail" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input type="file" name="map-thumbnail" id="map-thumbnail" accept=".png, .jpg, .jpeg"></div>
                            <output id="map-thumbnail-preview"></output>
                        </div>

                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Projection" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="projection-input" name="projection-input" required></div>
                        </div>

                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Units" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="units-input" name="units-input" required></div>
                        </div>

                        <!--  DEFAULT EXTENT -->
                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Default_Extent_MinX" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="minx-input" name="minx-input" required></div>
                        </div>
                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Default_Extent_MinY" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="miny-input" name="miny-input" required></div>
                        </div>

                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Default_Extent_MaxX" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="maxx-input" name="maxx-input" required></div>
                        </div>
                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Default_Extent_MaxY" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="maxy-input" name="maxy-input" required></div>
                        </div>


                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Default_MaxScale" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="default-maxscale-input" name="default-maxscale-input" ></div>
                        </div>


                        <div class="itemform">
                            <div data-locale_key=Manager_Map_Settings_Enable_CustomScalesResolutions data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div id="radio_container">
                                <div style="width:50px !important; padding: 3px 5px 0 0;">
                                    <div style="width:20px !important;" data-locale_key=Manager_Map_Settings_Enable_CustomScalesResolutions_None data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <input id="custom_sr_none" type="radio" value="none"  name="enable_custom_scales_resolutions" checked="checked">
                                </div>
                                <div style="margin-left: 10px;float: left;">
                                    <div style="width:50px !important; float: left !important;" data-locale_key=Manager_Map_Settings_Enable_CustomScalesResolutions_Scales data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <input id="custom_sr_scales" type="radio" value="scales"  name="enable_custom_scales_resolutions">
                                </div>
                                <div style="margin-left: 10px;float: left;">
                                    <div style="width:85px !important;" data-locale_key=Manager_Map_Settings_Enable_CustomScalesResolutions_Resolutions data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <input id="custom_sr_resolutions" type="radio" value="resolutions"  name="enable_custom_scales_resolutions">
                                </div> 
                            </div>
                        </div>

                        <div class="itemform" style="padding-top:7px">
                            <div data-locale_key="Manager_Map_Settings_List_CustomScales" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div id="scales_buttons">
                                <div style="width: 95px !important;" data-locale_key=Manager_Map_Settings_Add_CustomScale data-locale_ref="text" class="localizedElement form-label-title"></div>
                                <input id="scale-input" type="number" name="scale-input">
                                <div id="scales-add" data-locale_key="Manager_Alerts_Types_Button_Add" data-locale_ref="title" class="localizedElement grid-toolbar-item" onclick="mMapSettings.addScale();"><i class="fa fa-plus fa-2x"></i></div>
                                <div id="scales-delete" data-locale_key="Manager_Alerts_Types_Button_Delete" data-locale_ref="title" class="localizedElement grid-toolbar-item custom-hidden" onclick="mMapSettings.deleteScale();"><i class="fa fa-minus fa-2x"></i></div>
                            </div>
                        </div>

                        <div class="itemform">
                            <div class="form-label-title"></div>
                            <div>
                                <ol id="list_scales">
                                </ol>
                            </div>
                        </div>

                        <div class="itemform" style="padding-top:7px">
                            <div data-locale_key="Manager_Map_Settings_List_CustomResolutions" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div id="resolutions_buttons">
                                <div style="width: 95px !important;" data-locale_key=Manager_Map_Settings_Add_CustomResolution data-locale_ref="text" class="localizedElement form-label-title"></div>
                                <input id="resolution-input" type="number" name="resolution-input">
                                <div id="resolutions-add" data-locale_key="Manager_Alerts_Types_Button_Add" data-locale_ref="title" class="localizedElement grid-toolbar-item" onclick="mMapSettings.addResolution();"><i class="fa fa-plus fa-2x"></i></div>
                                <div id="resolutions-delete" data-locale_key="Manager_Alerts_Types_Button_Delete" data-locale_ref="title" class="localizedElement grid-toolbar-item custom-hidden" onclick="mMapSettings.deleteResolution();"><i class="fa fa-minus fa-2x"></i></div>
                            </div>
                        </div>

                        <div class="itemform">
                            <div class="form-label-title"></div>
                            <div>
                                <ol id="list_resolutions">
                                </ol>
                            </div>
                        </div>

                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Dots_Per_Inch_Override" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input id="dots-per-inch-input" type="number" name="dots-per-inch-input"></div>
                        </div>

                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Show_Overview" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <div><input type="checkbox" id="show_overview"  name="show_overview"></div>
                        </div>

                        <div class="itemform">
                            <div data-locale_key="Manager_Map_Settings_Roles" data-locale_ref="text" class="localizedElement form-label-title"></div>
                            <table id="mm_roles">

                            </table>
                        </div>

                    </div>
                </div>
            </form>


        </body>
    </html>
