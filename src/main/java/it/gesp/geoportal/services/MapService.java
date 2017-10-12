package it.gesp.geoportal.services;

import it.gesp.geoportal.dao.SessionFactoryManager;
import it.gesp.geoportal.dao.dto.MapDTO;
import it.gesp.geoportal.dao.entities.Map;
import it.gesp.geoportal.dao.repositories.MapRepository;
import it.gesp.geoportal.exceptions.OperationInvalidException;

import org.apache.log4j.Logger;
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
	
	public Map getMapById(int mapId){
		Session session = null;
		try{
			session = SessionFactoryManager.openSession();
			MapRepository mr = new MapRepository();
			return mr.getById(session, Map.class, mapId);
		}catch (Exception x) {
			log.debug(x);
			return null;
		} finally {
			session.close();
		}
	}
	
	public void createMap(MapDTO mapDTO) throws Exception{
		
		MapRepository mapRepository = new MapRepository();
		
		Session session = null;
		try{
			session = SessionFactoryManager.openSession();
			Transaction tx = session.beginTransaction();
			try{
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
				
				mapRepository.save(session, newMap);
				
				tx.commit();
			}catch (Exception x) {
				//log.debug(x);
				tx.rollback();
				throw x;
			}
			
		}catch(Exception x) {
			log.debug(x);
			throw x;
		} finally {
			session.close();
		}
	}
	
	public void updateMap(MapDTO mapDTO) throws Exception {
		
		MapRepository mapRepository = new MapRepository();
		
		Session session = null;
		try {
			session = SessionFactoryManager.openSession();
			Transaction tx = session.beginTransaction();
			try {

				Map existingMap = mapRepository.getById(session, Map.class, mapDTO.getIdMap()); 
				if (existingMap == null) {
					throw OperationInvalidException.createMissingIdExeption("Map",  mapDTO.getIdMap());
				}
				
				existingMap.setMapName(mapDTO.getMapName());
				
				existingMap.setProjection(mapDTO.getProjection());
				
				//existingMap.setZoom(mapDTO.getZoom());
				//existingMap.setCenterXCoord(mapDTO.getCenterx());
				//existingMap.setCenterYCoord(mapDTO.getCentery());
				
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
				
				//Dots per inch override
				existingMap.setDotsPerInch(mapDTO.getDotsPerInch());
				
				//LL
				//existingMap.setMaxExtentLL("" + mapDTO.getMinx() + "," + mapDTO.getMiny());
				//existingMap.setMaxExtentLL("" + mapDTO.getCenterx() + "," + mapDTO.getCentery());
				
				//UR
				//existingMap.setMaxExtentUR("" + mapDTO.getMaxx() + "," + mapDTO.getMaxy());
				//existingMap.setMaxExtentUR("" + mapDTO.getCenterx() + "," + mapDTO.getCentery());
				
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
	}
}
