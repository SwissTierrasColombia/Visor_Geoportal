package it.gesp.geoportal.servlets;

import it.gesp.geoportal.PaginationObject;
import it.gesp.geoportal.constants.Permissions;
import it.gesp.geoportal.dao.dto.LayerDTO;
import it.gesp.geoportal.dao.dto.LayerGroupDTO;
import it.gesp.geoportal.dao.dto.MapDTO;
import it.gesp.geoportal.dao.entities.Layer;
import it.gesp.geoportal.dao.entities.LayerGroup;
import it.gesp.geoportal.dao.entities.MapConfigVw;
import it.gesp.geoportal.dao.entities.User;
import it.gesp.geoportal.exceptions.DataInvalidException;
import it.gesp.geoportal.exceptions.OperationInvalidException;
import it.gesp.geoportal.exceptions.PermissionInvalidException;
import it.gesp.geoportal.json.JsonFactory;
import it.gesp.geoportal.locale.LocaleUtils;
import it.gesp.geoportal.services.LayerGroupService;
import it.gesp.geoportal.services.LayerService;
import it.gesp.geoportal.services.LoginService;
import it.gesp.geoportal.services.MapConfigService;
import it.gesp.geoportal.services.MapService;
import it.gesp.geoportal.utils.Utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.google.gson.Gson;

public class MapConfigServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final Logger log = Logger.getLogger(MapConfigServlet.class);
	private ResourceBundle dbMessages = LocaleUtils.getDBMessages();
	//private ResourceBundle userMessages = LocaleUtils.getUserMessages("en");

	public MapConfigServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doWork(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doWork(request, response);
	}

	@SuppressWarnings("unchecked")
	private void doWork(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession currentSession = request.getSession(false);
		String currentLanguage = LoginService.getCurrentLanguageFromSessionOrDefault(currentSession);
		ResourceBundle userMessages = LocaleUtils.getUserMessages(currentLanguage);
		
		User currentUser = LoginService.getLoggedInUserFromSession(currentSession);
		//currentUser = new UserService().getUserByUsername("mosef", true);
		
		PrintWriter w = response.getWriter();
		String jsonRes = null;

		String oper = request.getParameter("oper");

		/*
		 * Check that the user is connected
		 */
		if (currentUser == null && 
				!("exportMapConfigAsJson".equals(oper) ||
						"exportGroupConfigAsJson".equals(oper) ||
						"exportConfigAsJson".equals(oper) ||
						"exportLayerServicesListAsJson".equals(oper))) {
			jsonRes = GeoportalResponse.createErrorResponse(userMessages
					.getString("USER_NOT_LOGGED_IN"));
			ServletUtils.writeAndFlush(log, w, jsonRes);
			return;
		}
		
		int idMap = -1;
		try{
			it.gesp.geoportal.dao.entities.Map defaultMap = new MapService().getDefaultMap();
			idMap = defaultMap.getIdMap();
		}catch(Exception e){
			
			jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("NO_STORED_MAP_ERROR"));
			ServletUtils.writeAndFlush(log, w, jsonRes);
			return;
		}
		
		
		
		LayerGroupService layerGroupService = new LayerGroupService();
		LayerService layerService = new LayerService();
		

		try {

			/*
			 * GET MAP_SETTINGS 
			 */
			if ("mapSettings".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_SETTING_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				String mapIdStr = request.getParameter("idMap");
				if (Utils.isNullOrEmpty(mapIdStr)) {
					log.debug("Error parsing idMap parameter");
					throw new DataInvalidException();
				}
				int mapId = Integer.parseInt(mapIdStr);
				it.gesp.geoportal.dao.entities.Map map = new MapService().getMapById(mapId);
				MapDTO mapDTO = MapDTO.parseFromMap(map);
                                                              				
				jsonRes = GeoportalResponse.createSuccessResponse(mapDTO, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			
			/**
			 * GET MAP LIST
			 * @Author Agencia de Implementacion
			 * */
			else if("getMapList".equalsIgnoreCase(oper)){
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_SETTING_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
								
				MapService mapService = new MapService();
				List<it.gesp.geoportal.dao.entities.Map> maps = mapService.getAllMaps();
				
				PaginationObject<it.gesp.geoportal.dao.entities.Map> paginationObject = PaginationObject.createFromList(maps);
				jsonRes = GeoportalResponse.createSuccessResponseWithSerializationOfNulls(paginationObject, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}			
			/**
			 * CREATE NEW MAP
			 * @Author Agencia de Implementacion  
			 **/
			
			else if("createNewMap".equalsIgnoreCase(oper)){
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_SETTING_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				String settingsJsonNewMap = request.getParameter("settings");
				if(Utils.isNullOrEmpty(settingsJsonNewMap)){
					log.debug("Error parsing settings parameter");
					throw new DataInvalidException();
				}
                                
				Gson gson = JsonFactory.getGson();
				MapDTO mapDTO = gson.fromJson(settingsJsonNewMap, MapDTO.class);
				
				MapService mapService = new MapService();
				mapService.createMap(mapDTO);
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			/*
			 * DELETE MAP
			 * @Author Agencia de Implementacion  
			 */
                        else if("deleteMap".equalsIgnoreCase(oper)){
                            /*
                             * Check whether the current user has the appropriate permission
                             */
                            if (!LoginService.hasPermission(currentUser,Permissions.MAP_SETTING_CONFIG_ADMIN)) {
                                   // User does not have the permission
                                   jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
                                   ServletUtils.writeAndFlush(log, w, jsonRes);
                                   return;
                            }
                            
                            String mapIdStr = request.getParameter("idMap");
				if (Utils.isNullOrEmpty(mapIdStr)) {
                                    log.debug("Error parsing idMap parameter");
                                    throw new DataInvalidException();
				}
                            int mapId = Integer.parseInt(mapIdStr);
                            MapService mapService = new MapService();
                            it.gesp.geoportal.dao.entities.Map map = mapService.getMapById(mapId);
                            boolean result = mapService.deleteMap(map);
                            if(!result){
                                jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("DEFAULT_MAP_ERROR"));
                                ServletUtils.writeAndFlush(log, w, jsonRes);
                                return;
                            }
                            
                            jsonRes = GeoportalResponse.createSuccessResponse(null, true);
                            ServletUtils.writeAndFlush(log, w, jsonRes);
                        }
                        
			else if ("saveMapSettings".equalsIgnoreCase(oper)) {
				
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_SETTING_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}

				String settingsJson = request.getParameter("settings");
				if (Utils.isNullOrEmpty(settingsJson)) {
					log.debug("Error parsing settings parameter");
					throw new DataInvalidException();
				}
                                                                
				Gson gson = JsonFactory.getGson();
				MapDTO mapDTO = gson.fromJson(settingsJson, MapDTO.class);
                                
				MapService mapService = new MapService();
				boolean result = mapService.updateMap(mapDTO);
                                if(!result){
                                    jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("DEFAULT_MAP_ERROR"));
                                    ServletUtils.writeAndFlush(log, w, jsonRes);
                                    return;
                                }
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			
			/*
			 * GET LAYERGROUPS AND LAYERS BY MAP ID
			 */
			else if ("layerGroupsAndLayers".equalsIgnoreCase(oper)) {

				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				String idMapStr = request.getParameter("idMap");
				if (Utils.isNullOrEmpty(idMapStr)) {
					log.debug("Error parsing idMap parameter");
					throw new DataInvalidException();
				}
				int mapId = Integer.parseInt(idMapStr);
				
				List<MapConfigVw> layerGroups = layerGroupService.getGroupsAndLayersByMapId(mapId);
				List <LayerGroupDTO> grooupsAndLayers = LayerGroupDTO.createGroupsAndLayersDTO(layerGroups);
				
				PaginationObject<User> paginationObject = PaginationObject.createFromList(grooupsAndLayers);
				jsonRes = GeoportalResponse.createSuccessResponse(paginationObject, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			} 
			
			/*
			 * GET LAYERGROUPS
			 */
			else if ("layerGroups".equalsIgnoreCase(oper)) {

				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}

				List<LayerGroup> layerGroups = layerGroupService.getLayerGroupsByMapId(idMap);
				
				PaginationObject<User> paginationObject = PaginationObject.createFromList(layerGroups);
				jsonRes = GeoportalResponse.createSuccessResponse(paginationObject, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			} 
			
			/*
			 * ADD LAYERGROUP
			 */
			else if ("addLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				String layerGroupName = request.getParameter("layerGroupName");
				String idMapStr = request.getParameter("idMap");
				if (Utils.isNullOrEmpty(layerGroupName) || Utils.isNullOrEmpty(idMapStr)) {
					log.debug("Error parsing layerGroupName parameter or idMap parameter");
					throw new DataInvalidException();
				}
				
				int mapId = Integer.parseInt(idMapStr);
				
				LayerGroup layerGroup = new LayerGroup();
				layerGroup.setLayerGroupName(layerGroupName);
				layerGroup.setIdMap(mapId);
				
				layerGroupService.addLayerGroup(layerGroup);
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			
			/*
			 * UPDATE LAYERGROUP
			 */
			else if ("updateLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}

				String layerGroupName = request.getParameter("layerGroupName");
				if (Utils.isNullOrEmpty(layerGroupName)) {
					log.debug("Error parsing layerGroupName parameter");
					throw new DataInvalidException();
				}
				
				String idMapStr = request.getParameter("idMap");
				if (Utils.isNullOrEmpty(idMapStr)) {
					log.debug("Error parsing idMap parameter");
					throw new DataInvalidException();
				}
				int mapId =  Integer.parseInt(idMapStr);
				layerGroupService.updateLayerGroup(mapId, layerGroupId, layerGroupName);
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			
			/*
			 * DELETE LAYERGROUP
			 */
			else if ("deleteLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}

				//ForceDeletion (false by default)
				boolean forceDeletion = false;
				try {
					String forceDeletionStr = request.getParameter("forceDeletion");
					if (!Utils.isNullOrEmpty(forceDeletionStr)) {
						forceDeletion = Boolean.parseBoolean(forceDeletionStr);
					}
				} catch (Exception x) {
					log.debug("Error parsing baseLayer parameter");
					throw new DataInvalidException();
				}
				
				layerGroupService.deleteLayerGroup(layerGroupId, forceDeletion);
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			
			/*
			 * REORDER LAYERGROUP
			 */
			else if ("reorderLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				//layerGroupId
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}
				
				//position
				int position = -1;
				try {
					String positionStr = request.getParameter("position");
					position = Integer.parseInt(positionStr);
				} catch (Exception x) {
					log.debug("Error parsing position parameter");
					throw new DataInvalidException();
				}
				
				layerGroupService.reorderLayerGroup(layerGroupId, position);
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			
			/*
			 * LAYERS
			 */
			else if ("unAssociatedlayers".equalsIgnoreCase(oper)) {

				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				String idMapStr = request.getParameter("idMap");
				if (Utils.isNullOrEmpty(idMapStr)) {
					log.debug("Error parsing idMap parameter");
					throw new DataInvalidException();
				}
				int mapId = Integer.parseInt(idMapStr);
				
				List<LayerDTO> layers = layerService.getUnassociatedLayers(mapId);
				PaginationObject<Layer> paginationObject = PaginationObject.createFromList(layers);
				jsonRes = GeoportalResponse.createSuccessResponse(paginationObject, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			} 
			
			/*
			 * LAYERS FOR A GROUP
			 */
			else if ("layersByLayerGroup".equalsIgnoreCase(oper)) {

				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}
				
				List<Layer> layers = layerService.getLayersByLayerGroupId_Cycle(layerGroupId);
				PaginationObject<Layer> paginationObject = PaginationObject.createFromList(layers);
				jsonRes = GeoportalResponse.createSuccessResponse(paginationObject, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			/*
			 * ADD LAYER TO A GROUP
			 */
			else if ("addLayerToLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				//layerGroupId
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}
				
				//layerId
				int layerId = -1;
				try {
					String layerIdStr = request.getParameter("layerId");
					layerId = Integer.parseInt(layerIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerId parameter");
					throw new DataInvalidException();
				}
				
				layerGroupService.addLayerToLayerGroup(layerGroupId, layerId);
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			/*
			 * ACTIVATE LAYER BY DEFAULT 
			 * @Author Agencia de Implementacion
			 */
			else if("activateLayerByDefault".equalsIgnoreCase(oper)){
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				int layerId = -1;
				
				try {
					String layerIdStr = request.getParameter("layerId");
					layerId = Integer.parseInt(layerIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerId parameter");
					throw new DataInvalidException();
				}
				
				//layerGroupId
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}
				
				boolean isLayerActive = false;
				try{
					String isLayerActiveStr = request.getParameter("isLayerActive");
					isLayerActive = Boolean.parseBoolean(isLayerActiveStr);
				}catch(Exception x){
					log.debug("Error parsing isLayerActive parameter");
					throw new DataInvalidException();
				}
				
				layerGroupService.activateLayerByDefault(layerId, layerGroupId, isLayerActive);
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			/*
			 * REORDER LAYER IN A GROUP
			 */
			else if ("reorderLayerInLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				//layerGroupId
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}
				
				//layerId
				int layerId = -1;
				try {
					String layerIdStr = request.getParameter("layerId");
					layerId = Integer.parseInt(layerIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerId parameter");
					throw new DataInvalidException();
				}
				
				//position
				int position = -1;
				try {
					String positionStr = request.getParameter("position");
					position = Integer.parseInt(positionStr);
				} catch (Exception x) {
					log.debug("Error parsing position parameter");
					throw new DataInvalidException();
				}
				
				layerGroupService.reorderLayerInGroup(layerGroupId, layerId, position);
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			/*
			 * MOVE LAYER FROM A GROUP TO ANOTHER ONE
			 */
			else if ("moveLayerToLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				//newlayerGroupId
				int newlayerGroupId = -1;
				try {
					String newlayerGroupIdStr = request.getParameter("newLayerGroupId");
					newlayerGroupId = Integer.parseInt(newlayerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing newLayerGroupId parameter");
					throw new DataInvalidException();
				}
				
				//oldlayerGroupId
				int oldlayerGroupId = -1;
				try {
					String oldlayerGroupIdStr = request.getParameter("oldlayerGroupId");
					oldlayerGroupId = Integer.parseInt(oldlayerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing oldlayerGroupId parameter");
					throw new DataInvalidException();
				}
				
				//layerId
				int layerId = -1;
				try {
					String layerIdStr = request.getParameter("layerId");
					layerId = Integer.parseInt(layerIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerId parameter");
					throw new DataInvalidException();
				}
				
//				//position
//				int position = -1;
//				try {
//					String positionStr = request.getParameter("position");
//					position = Integer.parseInt(positionStr);
//				} catch (Exception x) {
//					log.debug("Error parsing position parameter");
//					throw new DataInvalidException();
//				}
				
				layerGroupService.moveLayerFromGroups(oldlayerGroupId, layerId, newlayerGroupId);
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			/*
			 * REMOVE LAYER FROM A GROUP
			 */
			else if ("removeLayerFromLayerGroup".equalsIgnoreCase(oper)) {
				
				/*
				 * Check whether the current user has the appropriate permission
				 */
				if (!LoginService.hasPermission(currentUser,Permissions.MAP_CONFIG_ADMIN)) {
					// User does not have the permission
					jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("USER_DOES_NOT_HAVE_PERMISSION"));
					ServletUtils.writeAndFlush(log, w, jsonRes);
					return;
				}
				
				//layerGroupId
				int layerGroupId = -1;
				try {
					String layerGroupIdStr = request.getParameter("layerGroupId");
					layerGroupId = Integer.parseInt(layerGroupIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerGroupId parameter");
					throw new DataInvalidException();
				}
				
				//layerId
				int layerId = -1;
				try {
					String layerIdStr = request.getParameter("layerId");
					layerId = Integer.parseInt(layerIdStr);
				} catch (Exception x) {
					log.debug("Error parsing layerId parameter");
					throw new DataInvalidException();
				}
				
				layerGroupService.removeLayerFromLayerGroup(layerGroupId, layerId);
				
				jsonRes = GeoportalResponse.createSuccessResponse(null, true);
				ServletUtils.writeAndFlush(log, w, jsonRes);
			}
			
			/*
			 * EXPORT CONFIG AS JSON
			 */
			else if ("exportConfigAsJson".equalsIgnoreCase(oper)) {
				
				int mapId = -1;
				try {
					String mapIdStr = request.getParameter("mapId");
					mapId = mapIdStr!=null?Integer.parseInt(mapIdStr):-1;
				} catch (Exception x) {
					log.debug("Error parsing mapId parameter");
					throw new DataInvalidException();
				}

				if(mapId==-1)
					mapId = idMap;
				
				String res = new MapConfigService().getConfigAsJson(mapId);
				ServletUtils.writeAndFlush(log, w, res);
			}
			
			/*
			 * EXPORT MAP CONFIG AS JSON
			 */
			else if ("exportMapConfigAsJson".equalsIgnoreCase(oper)) {
				
				String res = new MapConfigService().getMapConfigAsJson(idMap);
				ServletUtils.writeAndFlush(log, w, res);
			}
			
			/*
			 * EXPORT GROUP CONFIG AS JSON
			 */
			else if ("exportGroupConfigAsJson".equalsIgnoreCase(oper)) {
				
				String res = new MapConfigService().getGroupConfigAsJson(idMap);
				ServletUtils.writeAndFlush(log, w, res);
			}
			
			/*
			 * EXPORT LAYER SERVICES AS JSON
			 */
			else if ("exportLayerServicesListAsJson".equalsIgnoreCase(oper)) {
				String res = new MapConfigService().getLayerServicesListAsJson(idMap);
				ServletUtils.writeAndFlush(log, w, res);
			}
			
			else {
				log.debug("Wrong OPER param");
				throw new DataInvalidException();
			}

		} catch (DataInvalidException de) {
			log.debug("Data invalid exception.", de);
			if (de.getMessage() != null) {
				jsonRes = GeoportalResponse.createErrorResponse(de.getMessage());
			} else {
				jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("MISSING_PARAMETERS"));
			}
			ServletUtils.writeAndFlush(log, w, jsonRes);

		} catch (PermissionInvalidException pei) {
			log.debug("Permssion invalid exception", pei);
			jsonRes = GeoportalResponse.createErrorResponse(userMessages
					.getString("USER_DOES_NOT_HAVE_PERMISSION"));
			ServletUtils.writeAndFlush(log, w, jsonRes);
		} catch (OperationInvalidException oie) {
			try {
				String realMess = MessageFormat.format(userMessages.getString(oie.getExceptionCode()), (Object[])oie.getArgs());
				log.debug("OperationInvalidException", oie);
				jsonRes = GeoportalResponse.createErrorResponse(realMess, oie.getExceptionCode());
			} catch (Exception x) {
				jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("GENERIC_ERROR"));
			}
			ServletUtils.writeAndFlush(log, w, jsonRes);
			
		} catch (Exception x) {
			log.debug("Generic exception", x);
			jsonRes = GeoportalResponse.createErrorResponse(userMessages.getString("GENERIC_ERROR"));
			ServletUtils.writeAndFlush(log, w, jsonRes);
		}

	}

}
