<%@page import="it.gesp.geoportal.utils.ConfigUtils"%>
<%@page import="it.gesp.geoportal.dao.dto.SystemSettingDTO"%>
<%@page import="it.gesp.geoportal.services.SystemSettingService"%>
<%@page import="it.gesp.geoportal.locale.LocaleUtils, it.gesp.geoportal.services.LoginService,it.gesp.geoportal.constants.Permissions, it.gesp.geoportal.dao.entities.User, it.gesp.geoportal.services.SystemSettingService" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Geoportal</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width">
        <%-- 	<%@ include file="geoportal_import_js_min.jspf" %> --%>
        <%@ include file="geoportal_import.jspf" %>
    </head>
    <body class="nav-justified footer_fixed">
        <div id="mainContainer" class="container body">
            <div class="main_container">

                <!-- MENU -->
                <%@ include file="components/menu.jspf" %>
                <!-- END MENU -->
                
                <!-- SEARCH -->
                <%--@ include file="components/search.jspf" --%>
                <!-- END SEARCH -->
                
                <!-- page content -->
                <div class="right_col p_main_content" role="main">

                    <!-- WEBGIS CONTAINER (map and footer) -->
                    <div id="webgis" >
                        <div id="mapContainer">

                            <div id="input-label-panel" data-locale_key="Save_Label_Panel" data-locale_ref="title" class="localizedElement custom-hidden">
                                <div id="input-label-header" data-locale_key="Save_Label_Header" data-locale_ref="text" class="localizedElement"></div>
                                <textarea id="input-label"></textarea>
                                <div id="save-label-button" data-locale_key="Save_Label_Button" data-locale_ref="title" class="localizedElement" onclick="saveLabel();"><i class="fa fa-save fa-2x"></i></div>
                            </div>

                            <!-- BASE TOOLS PANEL -->
                            <div id="base-tools-panel" class="tools-panel">

                                <!-- BASE MAPS -->
                                <%@ include file="components/topics.jspf" %>
                                <!-- BASE MAPS -->

                                <div id="gis_getFeatureInfoBtn" data-locale_key="Base_Panel_FeatureInfo" data-locale_ref="title" class="icon-menu icon-container icon-info ctrlButtons shadow1 localizedElement"></div>

                                <!-- PRINT TOOL -->
                                <%@ include file="components/printer.jspf" %>
                                <!-- PRINT TOOL -->

                                <!-- DOWNLOAD XTF -->
                                <%@ include file="components/xtfdownload.jspf" %>
                                <!-- END DOWNLOAD XTF -->


                                <div class="icon-container-all" style="margin-top: 59px">
                                    <div id="gis_gisBaseLayerBtn" data-locale_key="Base_Panel_SelectBaseMap" data-locale_ref="title" class="icon-menu icon-container icon-map ctrlButtons shadow1 localizedElement" onclick="baseMapLayerIcon.onclick();"></div>
                                    <div id="baselayers-select" class="no-display"></div>
                                </div>
                            </div>

                            <!-- ******************** -->
                            <!-- ADVANCED TOOLS PANEL -->
                            <!-- ******************** -->
                            <div id="advance-tools-panel" class="tools-panel-master horizontal-panel">

                                <!-- SEARCH WFS -->
                                <%--@ include file="components/searchwfs.jspf" %-->
                                <!-- END SEARCH WFS -->

                                <!--  CSW -->
                                <!--div class="icon-container-all"-->
                                    <!-- Icon -->
                                    <!--div id="gis_cswClientBtn" data-tool="catalogcsw"  data-locale_key="Metadata_Panel_Csw_Search" data-locale_ref="title" class="localizedElement icon-container" onclick="AdvancedPanel.toggleAdvancedTools($(this));"><i class="fa fa-binoculars fa-2x"></i></div-->
                                <!--/div-->
                                <!-- END CSW -->

                                

                                <!-- COMMENTS -->
                                <%--@ include file="components/comments.jspf" --%>
                                <!-- END COMMENTS -->
                                <div class="ologoagencia">
                                    <div class="icon-visor icon-menu" style="color:white; font-size: 50px; text-shadow: 1px 1px 3px rgb(0, 0, 0); font-weight: bold;"></div>
                                </div>

                            </div>

                            <!-- ************* -->
                            <!-- Map Container -->
                            <!-- ************* -->
                            <div id="map" class="context-menu-one"></div>

                            <!-- Right Panel -->
                            <%@ include file="components/layers.jspf" %>
                            <!-- END Right Panel -->

                            <!-- UPLOAD KML TOOL -->
                            <%@ include file="components/kmlupload.jspf" %>
                            <!-- END UPLOAD KML TOOL -->

                            <!-- ************************ -->
                            <!-- PANEL ALERTS DIALOG 	  -->
                            <!-- ************************ -->
                            <%
                                // ALERTS READ PERMISSION
                                /*
                             * Simple Alert Panel is available to all user that are not Alerts Admin, 
                             * (ie dont have the ALERTS_READ permission)
                                 */
                                if (LoginService.currentUserHasPermission(session, Permissions.ALERTS_READ)) {
                            %>
                            <div id="full-advance-alerts-panel" class="custom-hidden">

                                <div class="data-grid-container">
                                    <div class="data-grid-actions">

                                        <% // ALERTS DOWNLOAD PERMISSION
                                            if (LoginService.currentUserHasPermission(session, Permissions.ALERTS_DOWNLOAD)) {%>
                                        <div id="alerts-download" 
                                             data-layer_name="<%=LoginService.getAlertsDownloadGeoserverLayerName(session)%>" 
                                             data-username="<%=LoginService.getAlertsDownloadGeoserverUsername(session)%>"
                                             data-password="<%=LoginService.getAlertsDownloadGeoserverPassword(session)%>"
                                             data-locale_key="Advanced_Alerts_Download_Alerts" data-locale_ref="title" data-action="download" class="localizedElement grid-toolbar-item" onclick="alerts.toggleActions($(this))"><i class="fa fa-download fa-2x"></i></div>
                                            <% } %>

                                        <!-- Button update status alert -->
                                        <div id="alerts-modify-status" data-locale_key=Advanced_Alerts_Modify_Alert_Status data-locale_ref="title" data-action="status" class="localizedElement grid-toolbar-item" onclick="alerts.toggleStatusForm($(this))"><i class="fa fa-flag-o fa-2x"></i></div>
                                        <div id="alerts-modify" data-locale_key="Advanced_Alerts_Modify_Alert" data-locale_ref="title" data-action="modify" class="localizedElement grid-toolbar-item" onclick="alerts.toggleActions($(this))"><i class="fa fa-edit fa-2x"></i></div>
                                        <div id="alerts-insert" data-locale_key="Advanced_Alerts_Insert_New" data-locale_ref="title" data-action="insert" class="localizedElement grid-toolbar-item" onclick="alerts.toggleActions($(this))"><i class="fa fa-plus fa-2x"></i></div>
                                        <div id="alerts-selectmap" data-locale_key="Advanced_Alerts_Select" data-locale_ref="title" data-action="selectmap" class="localizedElement grid-toolbar-item ctrlButtons" onclick="alerts.toggleActions($(this))"><i class="fa fa-location-arrow fa-2x"></i></div>
                                        <div id="alerts-zoom" data-locale_key="General_ZoomToLayer_Button_Title" data-locale_ref="title" class="localizedElement grid-toolbar-item"  onclick="alerts.zoomToLayer();"><i class="fa fa-arrows-alt fa-2x"></i></div>
                                        <div id="alerts-zoom-selected" data-locale_key="General_ZoomToFeature" data-locale_ref="title" class="localizedElement grid-toolbar-item"  onclick="alerts.zoomToSelected();"><i class="fa fa-search fa-2x"></i></div>
                                    </div>
                                    <table class="data-grid"></table>
                                </div>

                                <!-- FORM UPDATE STATUS FOR FULLPANEL -->
                                <div id="data-grid-form-status" class="custom-hidden">
                                    <!-- 								<div data-locale_key="Advanced_Alerts_FormHeader_Status" data-locale_ref="text" class="localizedElement data-grid-form-header"></div> -->
                                    <input type="hidden" id="changestatus-alerts-id">
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_StatusNote" data-locale_ref="text" class="localizedElement status-action-label"></div>
                                        <textarea rows="3" id="alerts-status-note"></textarea>
                                    </div>

                                    <div>
                                        <!-- Accept status (set to ongoing) -->
                                        <div class="itemform-status">
                                            <div id="alerts-status-accept" class="localizedElement status-actions" data-status="S" onclick="alerts.status.change($(this));"><i class="fa fa-wrench fa-2x"></i></div>
                                            <div data-locale_key="Advanced_Alerts_StatusAdmit" data-locale_ref="text" class="localizedElement status-action-label"></div>
                                        </div>

                                        <!-- Reject status -->
                                        <div class="itemform-status">
                                            <div id="alerts-status-reject" class="localizedElement status-actions" data-status="R" onclick="alerts.status.change($(this));"><i class="fa fa-thumbs-down fa-2x"></i></div>
                                            <div data-locale_key="Advanced_Alerts_StatusReject" data-locale_ref="text" class="localizedElement status-action-label"></div>
                                        </div>

                                        <!-- Check status -->
                                        <div class="itemform-status">
                                            <div id="alerts-status-check" class="localizedElement status-actions" data-status="C" onclick="alerts.status.change($(this));"><i class="fa fa-check fa-2x"></i></div>
                                            <div data-locale_key="Advanced_Alerts_StatusCheck" data-locale_ref="text" class="localizedElement status-action-label"></div>
                                        </div>
                                    </div>										
                                </div>

                                <!-- FORM INSERT ALERTS FOR FULLPANEL -->
                                <form id="data-grid-form-insert" data-action="insert" class="custom-hidden alerts-form" onSubmit="return false">
                                    <div data-locale_key="Advanced_Alerts_FormHeader_Insert" data-locale_ref="text" class="localizedElement data-grid-form-header"></div>

                                    <!-- Name -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Name" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="insert-alerts-name" name="insert-alerts-name" required></div>
                                    </div>

                                    <!-- Fecha -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Date" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="insert-alerts-date" name="insert-alerts-date" required></div>
                                    </div>

                                    <!-- Type -->		
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Type" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><select id="insert-alerts-type"></select></div>
                                    </div>

                                    <!-- Departments -->		
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Department" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><select id="insert-alerts-department" ></select></div>
                                    </div>

                                    <!-- Description -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Desc" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><textarea id="insert-alerts-desc" required></textarea></div>
                                    </div>

                                    <!-- Email -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Email" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="insert-alerts-email" name="insert-alerts-email" type="email" required></div>
                                    </div>

                                    <!-- Telephone -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Phone" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="insert-alerts-phone" name="insert-alerts-phone" required></div>
                                    </div>

                                    <!-- Mobile -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Mobile" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="insert-alerts-mobile" name="insert-alerts-mobile" required></div>
                                    </div>

                                    <!-- Panel insert geometry -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_AddPoint" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div id="alerts-insert-typegeoms" class="form-horizontal-panel">
                                            <div id="alerts-point-insert" data-locale_key="Redline_Add_Point_Button_Title" data-locale_ref="title" data-action="pointDraw" class="localizedElement ctrlButtons" onclick="alerts.selectGeomType($(this));"><i class="fa fa-circle fa-lg"></i></div>
                                        </div>
                                    </div>

                                    <!-- Footer action buttons form -->
                                    <div class="data-grid-form-footer">
                                        <button id="data-grid-insert-submit" data-locale_key="General_Save" data-locale_ref="text" class="localizedElement" onclick="alerts.saveData($('#data-grid-form-insert'));"></button>
                                        <button id="data-grid-insert-cancel" data-locale_key="General_Cancel" data-locale_ref="text" class="localizedElement" onclick="alerts.doAction('viewgrid');"></button>
                                    </div>
                                </form>

                                <!-- FORM DOWNLOAD ALERTS FOR FULLPANEL -->
                                <div id="data-grid-form-download" data-action="download" class="custom-hidden alerts-form">
                                    <div data-locale_key="Advanced_Alerts_FormHeader_Download" data-locale_ref="text" class="localizedElement data-grid-form-header"></div>

                                    <!-- Fields data form -->

                                    <!-- Date FROM -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Download_Date_From" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <input type="text" id="download-alerts-datefrom">	
                                    </div>

                                    <!-- Date TO -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Download_Date_To" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <input type="text" id="download-alerts-dateto">
                                    </div>

                                    <!-- Footer action buttons form -->
                                    <div class="data-grid-form-footer">
                                        <button id="data-grid-download-submit" data-locale_key="General_Download" data-locale_ref="text" class="localizedElement" onclick="alerts.downloadZip();"></button>
                                        <button id="data-grid-download-cancel" data-locale_key="General_Cancel" data-locale_ref="text" class="localizedElement" onclick="alerts.doAction('viewgrid');"></button>
                                    </div>
                                </div>

                                <!-- FORM UPDATE ALERTS FOR FULLPANEL-->
                                <form id="data-grid-form-update" data-action="update" class="custom-hidden alerts-form" onSubmit="return false">
                                    <div data-locale_key="Advanced_Alerts_FormHeader_Update" data-locale_ref="text" class="localizedElement data-grid-form-header"></div>						
                                    <!-- Fields data form -->
                                    <input type="hidden" id="update-alerts-id">

                                    <!-- Name -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Name" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="update-alerts-name" name="update-alerts-name"></div>
                                    </div>

                                    <!-- Fecha -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Date" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="update-alerts-date" name="update-alerts-date"></div>
                                    </div>

                                    <!-- Type -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Type" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><select id="update-alerts-type"></select></div>
                                    </div>

                                    <!-- Departments -->		
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Department" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><select id="update-alerts-department"></select></div>
                                    </div>

                                    <!-- Description -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Desc" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><textarea rows="2" id="update-alerts-desc"></textarea></div>
                                    </div>

                                    <!-- Email -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Email" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="update-alerts-email" name="update-alerts-email" type="email"></div>
                                    </div>

                                    <!-- Telephone -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Phone" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="update-alerts-phone" name="update-alerts-phone"></div>
                                    </div>

                                    <!-- Mobile -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Mobile" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input type="text" id="update-alerts-mobile" name="update-alerts-mobile"></div>
                                    </div>

                                    <!-- Panel update geometry -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_MovePoint" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div id="alerts-update-modgeom" data-locale_key="Advanced_Alerts_Update_Geom" data-locale_ref="title" data-action="modify" class="localizedElement" onclick="alerts.toggleEditModifyGeom($(this));"><i class="fa fa-arrows"></i></div>
                                    </div>

                                    <!-- Footer action buttons form -->
                                    <div class="data-grid-form-footer">
                                        <button id="data-grid-update-submit" data-locale_key="General_Save" data-locale_ref="text" class="localizedElement" onclick="alerts.saveData($(this).closest('.alerts-form'));"></button>
                                        <button id="data-grid-update-cancel" data-locale_key="General_Cancel" data-locale_ref="text" class="localizedElement" onclick="alerts.doAction('viewgrid');"></button>
                                    </div>
                                </form>
                            </div>
                            <% } //END ALERT FULLPANEL %>


                            <!-- ********************* -->
                            <!-- CATALOG (CSW REQUEST) -->
                            <!-- ********************* -->
                            <div id="catalog" class="custom-hidden">
                                <div id="csw-catalog-container">
                                    <div id="catalog-form">
                                        <!-- FILTER KEYWORD -->
                                        <div class="itemform">
                                            <!-- Keyword label-->
                                            <div data-locale_key="Metadata_Label_Form_SearchKeyWord" data-locale_ref="text" class="form-label-title localizedElement"></div>
                                            <div>								
                                                <input id="catalog-input-keyword" type="text" >										
                                            </div>
                                        </div>

                                        <!-- FILTER BBOX -->
                                        <div class="itemform">
                                            <div data-locale_key="Advanced_Panel_Search_Label_SearchBbox" data-locale_ref="text" class="form-label-title localizedElement"></div>
                                            <div class="float">
                                                <input id="csw-search-bbox-deactive" type="radio" value="csw-bbox-deactive" name="csw-search-bbox" checked="checked">
                                                <div data-locale_key="Advanced_Panel_Search_Label_SearchBboxDeactive" data-locale_ref="text" class="localizedElement"></div>
                                                <input id="csw-search-bbox-active" type="radio" value="csw-bbox-active" name="csw-search-bbox">
                                                <div style="padding: 3px 5px 0 0;" data-locale_key="Advanced_Panel_Search_Label_SearchBboxActive" data-locale_ref="text" class="localizedElement"></div>
                                            </div>

                                            <!-- BBOX manager panel -->
                                            <div id="csw-catalog-bbox-panel" class="custom-hidden">
                                                <div id="csw-catalog-bbox-selected-buttons">
                                                    <div id="csw-catalog-bbox-select-button" data-locale_key="Advanced_Panel_Search_SearchBboxSelectButton" data-locale_ref="title" class="localizedElement" onclick="controls.catalog.activate();"><i class="fa fa-pencil-square-o fa-2x"></i></div>
                                                    <div id="csw-catalog-bbox-toggle-button" data-locale_key="Advanced_Panel_Search_SearchBboxHideButton" data-locale_ref="title" class="localizedElement custom-hidden" onclick="catalogCsw.toggleVisibilityBbox();"><i class="fa fa-eye fa-2x"></i></div>
                                                </div>
                                                <div id="csw-catalog-bbox-selected-text"></div>
                                            </div>				
                                        </div>

                                        <!-- Footer (Confirm button) -->
                                        <div class="advance-searchwfs-footerform">
                                            <button id="csw-catalog-clean" data-locale_key="General_Clean" data-locale_ref="text" class="localizedElement" style="float:left;"></button>
                                            <button id="csw-catalog-confirm" data-locale_key="General_Search" data-locale_ref="text" class="localizedElement" ></button>
                                        </div>
                                    </div>
                                    <div id="catalog-results">
                                        <div id="catalog-results-header" data-locale_key="Metadata_Panel_Csw_Search_Results" data-locale_ref="text" class="localizedElement"></div>			
                                        <div id="catalog-body"></div>
                                    </div>
                                </div>	
                            </div>

                            <!-- ********************* -->
                            <!--FEATURE GRID PANEL -->
                            <!-- ********************* -->
                            <div id="feature-grid-panel" style="display:none">

                                <div id="feature-grid-panel-container">
                                    <div id="feature-grid-panel-toolbar">
                                        <button id="feature-grid-panel-toolbar-zoomto" data-locale_key="General_ZoomToFeature" data-locale_ref="text" class="localizedElement" style="display:none;" disabled onclick="featureGridPanel.zoomToSelected();"></button>
                                        <!--  								<button id="feature-grid-panel-toolbar-close" data-locale_key="General_Close" data-locale_ref="text" class="localizedElement" style="display:none;" onclick="featureGridPanel.closePanel();"></button>  -->
                                        <div id="feature-grid-panel-max-number-of-feature-reached"></div>
                                    </div>
                                    <div id="feature-grid-panel-grid-container"></div>
                                </div>
                            </div>


                            <% 
                                // ALERTS READ PERMISSION
                                /*
                             * Simple Alert Panel is available to all user that are not Alerts Admin, 
                             * (ie dont have the ALERTS_READ permission)
                                 */
                                if (!LoginService.currentUserHasPermission(session, Permissions.ALERTS_READ)) {
                            %>
                            <!-- FORM INSERT ALERTS FOR SIMPLEPANEL -->
                            <form id="alert-simple-panel-insert" class="custom-hidden alerts-form" onSubmit="return false;">

                                <!-- Name -->
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Name" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <div><input type="text" id="simple-insert-alerts-name" name="simple-insert-alerts-name" ></div>
                                </div>

                                <!-- Fecha -->
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Date" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <div><input type="text" id="simple-insert-alerts-date" name="simple-insert-alerts-date" ></div>
                                </div>

                                <!-- Type -->		
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Type" data-locale_ref="text" class="localizedElement form-label-title mandatoryFormat"></div>
                                    <div><select id="simple-insert-alerts-type"></select></div>
                                </div>

                                <!-- Departments -->		
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Department" data-locale_ref="text" class="localizedElement form-label-title mandatoryFormat"></div>
                                    <div><select id="simple-insert-alerts-department"></select></div>
                                </div>

                                <!-- Description -->
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Desc" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <div><textarea id="simple-insert-alerts-desc"></textarea></div>
                                </div>

                                <!-- Email -->
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Email" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <div><input type="email" id="simple-insert-alerts-email" name="simple-insert-alerts-email"></div>
                                </div>

                                <!-- Telephone -->
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Phone" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <div><input type="text" id="simple-insert-alerts-phone" name="simple-insert-alerts-phone"></div>
                                </div>

                                <!-- Mobile -->
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_Mobile" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <div><input type="text" id="simple-insert-alerts-mobile" name="simple-insert-alerts-mobile"></div>
                                </div>

                                <!-- Panel insert geometry -->
                                <div class="itemform">
                                    <div data-locale_key="Advanced_Alerts_Label_Form_AddPoint" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                    <div id="simple-alerts-insert-typegeoms" class="form-horizontal-panel">
                                        <div id="simple-alerts-point-insert" style="width: auto;" data-locale_key="Redline_Add_Point_Button_Title" data-locale_ref="title" data-action="pointDraw" class="localizedElement ctrlButtons" onclick="alerts.selectGeomType($(this));"><i class="fa fa-circle fa-lg"></i></div>
                                    </div>
                                </div>

                                <!-- Panel insert geometry -->
                                <div class="itemform">
                                    <div data-locale_key="General_Mandatory_Fields" data-locale_ref="text" class="localizedElement" style="width: auto !important"></div>
                                </div>

                                <!-- Footer action buttons form -->
                                <div class="data-grid-form-footer">
                                    <button id="simple-alerts-insert-submit" data-locale_key="General_Save" data-locale_ref="text" class="localizedElement" onclick="alerts.saveNewAlertSimple();"></button>
                                    <button id="simple-alerts-insert-cancel" data-locale_key="General_Cancel" data-locale_ref="text" class="localizedElement" onclick="alerts.closeNewAlertSimple();"></button>
                                </div>
                            </form>

                            <!-- FORM DETAIL ALERTS FOR SIMPLEPANEL -->
                            <div id="alert-simple-panel-detail" class="custom-hidden alerts-form">
                                <div class="formFieldScrollable">
                                    <!-- Name -->		
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Name" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-name"></input></div>
                                    </div>

                                    <!-- Fecha -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Date" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-date"></div>
                                    </div>

                                    <!-- Type -->		
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Type" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-type"></input></div>
                                    </div>

                                    <!-- Departments -->		
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Department" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly id="simple-detail-alerts-department" type="text"></input></div>
                                    </div>

                                    <!-- Description -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Desc" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><textarea readonly id="simple-detail-alerts-desc"></textarea></div>
                                    </div>

                                    <!-- Email -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Email" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-email"></div>
                                    </div>

                                    <!-- Telephone -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Phone" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-phone"></div>
                                    </div>

                                    <!-- Mobile -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Form_Mobile" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-mobile"></div>
                                    </div>

                                    <!-- Insertion date -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Insert_Time" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-insert-date"></input></div>
                                    </div>

                                    <!-- Current Status -->
                                    <div class="itemform">
                                        <div data-locale_key="Advanced_Alerts_Label_Current_Status" data-locale_ref="text" class="localizedElement form-label-title"></div>
                                        <div><input readonly type="text" id="simple-detail-alerts-current-status"></input></div>
                                    </div>
                                </div>
                                <!-- Footer action buttons form -->
                                <div class="data-grid-form-footer">
                                    <button id="simple-alerts-detail-cancel" data-locale_key="General_Cancel" data-locale_ref="text" class="localizedElement" onclick="alerts.closeDetailVerifyPanel();"></button>
                                </div>
                            </div>

                            <% } //ENDSIMPLEPANEL ALERTS_READ %>


                            <div id="gis_information_popup" class="custom-hidden"></div>

                            <div id="gis_layer_information_popup"></div>

                            <div id="gis-map-overview" class="custom-hidden"></div>

                        </div>
                        <div id="footer">
                            <div id="gis_version">Version: 1.1</div>
                            <div id="gis_measures" class="custom-hidden"></div>

                            <!-- Show information message depending on settings -->
                            <% if (new SystemSettingService().showInformationMessage()) {%>
                            <div id="gis_information_message" data-locale_key="InformationMessage_Icon" data-locale_ref="title" class="localizedElement"><i class="fa fa-info"></i></div>
                                <%}%>

                            <div id="gis_coordinates"></div>
                            <div id="gis_current_scalebar"></div>
                        </div>
                    </div>

                </div>
                <!-- /page content -->
            </div>
        </div>
        <script>
            $(document).ready(function () {
                Print_Configuration.printerHealthCheck();
            });
        </script>
    </body>
</html>