<%@page import="it.gesp.geoportal.utils.ConfigUtils"%>
<%@page import="it.gesp.geoportal.dao.dto.SystemSettingDTO"%>
<%@page import="it.gesp.geoportal.services.SystemSettingService"%>
<%@page import="it.gesp.geoportal.locale.LocaleUtils, it.gesp.geoportal.services.LoginService,it.gesp.geoportal.constants.Permissions, it.gesp.geoportal.dao.entities.User, it.gesp.geoportal.services.SystemSettingService" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Geoportal</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- Favicon -->
        <link rel="shortcut icon" type="image/png" href="images/marker.png"/>
        <!--  Google Maps -->
        <script src="//maps.google.com/maps/api/js?v=3&amp;key=AIzaSyDxpY6bD5mC987a9icRD0ghTVc1xdpLjvE"></script>

        <!-- Openlayers -->
        <link rel="stylesheet" href="lib/openlayers/OpenLayers-2.13.1/theme/default/style.css" type="text/css">

        <!-- Openlayers Addins-->
        <!-- Scalebar -->
        <link rel="stylesheet" href="lib/openlayers/addins/ScaleBar/theme/default/scalebar-thin.css" type="text/css" />

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link rel="stylesheet" href="css/base/component.css">
        <link rel="stylesheet" href="css/base/base.css">
        <link rel="stylesheet" href="css/base/icons.css">
    </head>
    <body lang="es">

        <!-- MENU -->
        <%@ include file="components/cmenu.jspf" %>
        <!-- END MENU -->

        <!-- MENU -->
        <div id="map" class="map"></div>
        <!-- END MENU -->

        <script src="lib/gnmenu/gnmenu.js"></script>
        <script src="lib/gnmenu/classie.js"></script>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        
        
        <script>
            new gnMenu(document.getElementById('gn-menu'));

            var displayLayersPanel = true;
            var displayUserPanel = false;

            function onClickBtnLayers(btn) {
                var panel = $(btn).children(".gn-menu-wrapper-r")[0];
                if ($(panel).hasClass("gn-open-all")) {
                    $(panel).removeClass("gn-open-all");
                    $(btn).removeClass("cont-icon-layers-title");
                    displayLayersPanel = false;
                } else {
                    $(panel).addClass("gn-open-all");
                    $(btn).addClass("cont-icon-layers-title");
                    displayLayersPanel = true;
                    if (displayUserPanel) {
                        $("#btnUser").click();
                    }
                }
            }

            function onClickBtnUser(btn) {
                var panel = $(btn).children(".gn-menu-wrapper-r")[0];
                if ($(panel).hasClass("gn-open-all")) {
                    $(panel).removeClass("gn-open-all");
                    $(btn).removeClass("cont-icon-layers-title");
                    displayUserPanel = false;
                } else {
                    $(panel).addClass("gn-open-all");
                    $(btn).addClass("cont-icon-layers-title");
                    displayUserPanel = true;
                    if (displayLayersPanel) {
                        $("#btnLayers").click();
                    }
                }
            }
        </script>
    </body>
</html>