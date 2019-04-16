package it.gesp.geoportal.services;

import it.gesp.geoportal.dao.SessionFactoryManager;
import it.gesp.geoportal.dao.dto.MapDTO;
import it.gesp.geoportal.dao.entities.LayerGroup;
import it.gesp.geoportal.dao.entities.Map;
import it.gesp.geoportal.dao.entities.Role;
import it.gesp.geoportal.dao.repositories.MapRepository;
import it.gesp.geoportal.dao.repositories.RoleRepository;
import it.gesp.geoportal.exceptions.OperationInvalidException;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class MapService {

    private static final Logger log = Logger.getLogger(MapService.class);

    public Map getMapByName(String mapName) {
        Session session = null;
        try {
            session = SessionFactoryManager.openSession();
            MapRepository mr = new MapRepository();
            return mr.getMapByName(session, mapName);

        } catch (Exception x) {
            log.debug(x);
            //throw x;
            return null;
        } finally {
            session.close();
        }
    }

    public Map getMapById(int mapId) {
        Session session = null;
        try {
            session = SessionFactoryManager.openSession();
            MapRepository mr = new MapRepository();

            Map map = mr.getById(session, Map.class, mapId);
            List<Role> roles = map.getRoles();

            //Loads permission eagerly
            Hibernate.initialize(roles);

            return map;

        } catch (Exception x) {
            log.debug(x);
            return null;
        } finally {
            session.close();
        }
    }

    public Map getDefaultMap() {
        Session session = null;

        try {
            session = SessionFactoryManager.openSession();
            MapRepository mr = new MapRepository();
            return mr.getDefaultMap(session);
        } catch (Exception e) {
            log.debug(e);
            return null;
        } finally {
            session.close();
        }

    }

    public List<Map> getAllMaps() {
        Session session = null;
        try {
            session = SessionFactoryManager.openSession();
            MapRepository mr = new MapRepository();
            return mr.getAll(session, Map.class);
        } catch (Exception x) {
            log.debug(x);
            return null;
        } finally {
            session.close();
        }
    }

    public void createMap(MapDTO mapDTO) throws Exception {

        MapRepository mapRepository = new MapRepository();

        Session session = null;
        try {
            session = SessionFactoryManager.openSession();
            Transaction tx = session.beginTransaction();
            try {
                Map newMap = new Map();
                newMap.setMapName(mapDTO.getMapName());
                newMap.setProjection(mapDTO.getProjection());
                newMap.setUnits(mapDTO.getUnits());

                newMap.setShowOverview(mapDTO.getShowOverview());
                newMap.setCustomScales(mapDTO.getCustomScalesAsJson());
                newMap.setDotsPerInch(mapDTO.getDotsPerInch());
                newMap.setCustomResolutions(mapDTO.getCustomResolutionsAsJson());
                newMap.setEnableCustomScalesResolutions(mapDTO.getEnableCustomScalesResolutions());
                newMap.setMaxScale(mapDTO.getMaxScale());

                //Default extent
                newMap.setDefaultExtentMinX(mapDTO.getDefaultExtentMinX());
                newMap.setDefaultExtentMinY(mapDTO.getDefaultExtentMinY());
                newMap.setDefaultExtentMaxX(mapDTO.getDefaultExtentMaxX());
                newMap.setDefaultExtentMaxY(mapDTO.getDefaultExtentMaxY());

                if (mapDTO.getThumbnail() != null) {
                    newMap.setThumbnail(mapDTO.getThumbnail());
                }

                List<Map> allMaps = getAllMaps();
                if ((mapDTO.getIsDefault()!=null && mapDTO.getIsDefault()) || allMaps.isEmpty()) {
                    for (Map m : allMaps) {
                        m.setIsDefault(false);
                    }
                    newMap.setIsDefault(true);

                    mapRepository.updateAll(session, allMaps);
                }

                mapRepository.save(session, newMap);

                tx.commit();
            } catch (Exception x) {
                //log.debug(x);
                tx.rollback();
                throw x;
            }

        } catch (Exception x) {
            log.debug(x);
            throw x;
        } finally {
            session.close();
        }
    }

    public boolean updateMap(MapDTO mapDTO) throws Exception {

        boolean result = false;
        MapRepository mapRepository = new MapRepository();

        Session session = null;
        try {
            session = SessionFactoryManager.openSession();
            Transaction tx = session.beginTransaction();
            try {

                Map existingMap = mapRepository.getById(session, Map.class, mapDTO.getIdMap());
                if (existingMap == null) {
                    throw OperationInvalidException.createMissingIdExeption("Map", mapDTO.getIdMap());
                }

                existingMap.setMapName(mapDTO.getMapName());

                existingMap.setProjection(mapDTO.getProjection());

                existingMap.setMaxScale(mapDTO.getMaxScale());
                existingMap.setUnits(mapDTO.getUnits());

                //Default extent
                existingMap.setDefaultExtentMinX(mapDTO.getDefaultExtentMinX());
                existingMap.setDefaultExtentMinY(mapDTO.getDefaultExtentMinY());
                existingMap.setDefaultExtentMaxX(mapDTO.getDefaultExtentMaxX());
                existingMap.setDefaultExtentMaxY(mapDTO.getDefaultExtentMaxY());

                //Show overview
                existingMap.setShowOverview(mapDTO.getShowOverview());

                //Custom scales
                existingMap.setEnableCustomScalesResolutions(mapDTO.getEnableCustomScalesResolutions());

                existingMap.setCustomScales(mapDTO.getCustomScalesAsJson());
                existingMap.setCustomResolutions(mapDTO.getCustomResolutionsAsJson());

                List<Role> rolesPerMap = getRolesByIds(mapDTO.getRoles());
                if (rolesPerMap != null) {
                    existingMap.setRoles(rolesPerMap);
                }
                //Dots per inch override
                existingMap.setDotsPerInch(mapDTO.getDotsPerInch());
                if (mapDTO.getThumbnail() != null) {
                    existingMap.setThumbnail(mapDTO.getThumbnail());
                }

                List<Map> allMaps = getAllMaps();
                if (mapDTO.getIsDefault() != null) {
                    if (mapDTO.getIsDefault() == Boolean.TRUE) {

                        for (Map m : allMaps) {
                            m.setIsDefault(false);
                        }
                        existingMap.setIsDefault(true);

                        mapRepository.updateAll(session, allMaps);
                        result = true;
                    }
                } else {

                    for (Map m : allMaps) { //remove itself from list
                        if (m.getIdMap() == mapDTO.getIdMap()) {
                            allMaps.remove(m);
                            break;
                        }
                    }

                    boolean thereIsDefaultMap = false;
                    for (Map m : allMaps) { //list without map itself
                        if (m.getIsDefault() != null) {
                            if (m.getIsDefault() == Boolean.TRUE) {
                                thereIsDefaultMap = true;
                                result = true;
                                break;
                            }
                        }
                    }

                    if (allMaps.isEmpty() || !thereIsDefaultMap) {
                        return false;
                    }
                }

                mapRepository.update(session, existingMap);

                tx.commit();
            } catch (Exception x) {
                //log.debug(x);
                tx.rollback();
                throw x;
            }
        } catch (Exception x) {
            log.debug(x);
            throw x;
        } finally {
            session.close();
        }
        return result;
    }

    /**
     * Business method for delete maps
     *
     * @author Agencia de Implementacion
     */
    public boolean deleteMap(Map map) throws Exception {
        boolean result = false;
        Session session = null;
        try {
            if (map.getIsDefault()!=null && map.getIsDefault() == true) {
                return false;
            }
            session = SessionFactoryManager.openSession();
            MapRepository mapRepository = new MapRepository();

            LayerGroupService lgs = new LayerGroupService();

            //search layergroups of map to delete
            List<LayerGroup> layerGroups = lgs.getLayerGroupsByMapId(map.getIdMap());

            //delete layergroups and layergroups_layers of map to delete
            for (LayerGroup lg : layerGroups) {
                lgs.deleteLayerGroup(lg.getIdLayerGroup(), true);
            }
            //delete map
            mapRepository.delete(map);
            result = true;
        } catch (Exception x) {
            log.debug(x);
            result = false;
        } finally {
            session.close();
        }
        return result;
    }

    private List<Role> getRolesByIds(List<Integer> ids) {
        Session session = null;
        try {
            session = SessionFactoryManager.openSession();
            RoleRepository rr = new RoleRepository();
            return rr.getRolesByIds(session, ids);

        } catch (Exception x) {
            log.debug(x);
            //throw x;
            return null;
        } finally {
            session.close();
        }
    }

}
