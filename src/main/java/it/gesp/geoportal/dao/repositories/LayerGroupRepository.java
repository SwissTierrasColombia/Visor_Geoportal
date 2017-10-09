package it.gesp.geoportal.dao.repositories;

import it.gesp.geoportal.dao.entities.LayerGroup;
import it.gesp.geoportal.dao.repositories.base.BaseRepository;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

public class LayerGroupRepository extends BaseRepository<LayerGroup> {

	private static final Logger log = Logger.getLogger(LayerGroupRepository.class);
	
	@SuppressWarnings("unchecked")
	public List<LayerGroup> getLayerGroups(Session session) {
//		try {

			List<LayerGroup> layerGroups = null;
			layerGroups = this.getAll(session, LayerGroup.class);
			return layerGroups;

//		} catch (Exception x) {
//			// Log
//			throw x;
//		}
	}
	
	@SuppressWarnings("unchecked")
	public long getMaxLayerGroupPositionInMap(Session session, int mapId) {
//		try {

			long maxCurrentPosition = 0;
			
			List<LayerGroup> layerGroups = null;
			
			Criteria numLayerGroupInMapCriteria = session
				    .createCriteria(LayerGroup.class)
				    .add(Restrictions.eq("idMap", mapId))
				    .setProjection(Projections.rowCount());
			long numLayersInGroup = (Long) numLayerGroupInMapCriteria.uniqueResult();
			
			if (numLayersInGroup > 0) {
				Criteria maxPositionInMapCriteria = session
					    .createCriteria(LayerGroup.class)
					    .add(Restrictions.eq("idMap", mapId))
					    .setProjection(Projections.max("position"));
				maxCurrentPosition = (Long) maxPositionInMapCriteria.uniqueResult();
			}

			return maxCurrentPosition;
//		} catch (Exception x) {
//			// Log
//			throw x;
//		}
	}
	
	/**
	 * Fetch the layerGroups by a given map id.
	 * @param session
	 * @param mapId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<LayerGroup> getLayerGroupsByMapId(Session session, int mapId) {
		return getLayerGroupsByMapId(session, mapId, false);
	}
	
	
	/**
	 * Fetch the layerGroups by a given map id.
	 * If fetch relationships is specified, layers belonging to the group are fetched as well
	 * in one query.
	 * @param session
	 * @param mapId
	 * @param fetchRelationships
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<LayerGroup> getLayerGroupsByMapId(Session session, int mapId, boolean fetchRelationships) {

		String hql = "from LayerGroup where idMap = :idMap";
		Query q = session.createQuery(hql);
		q.setParameter("idMap", mapId);
		
		List<LayerGroup> layerGroups = q.list();

//			List<LayerGroup> layerGroups = null;
//			Criteria criteria = session.createCriteria(LayerGroup.class);
//			criteria.add(Restrictions.eq("idMap", mapId));
//			layerGroups = criteria.list();
//			
//			return layerGroups;
		return layerGroups;

	}
	
	@SuppressWarnings("unchecked")
	public LayerGroup getLayerGroupsByMapIdAndName(Session session, int mapId, String layerGroupName) {
//		try {

			List<LayerGroup> layerGroups = null;
			//users = this.getAll(session, User.class);
			//layerGroups = this.getAll(session, LayerGroup.class);

			Criteria criteria = session.createCriteria(LayerGroup.class);
			criteria.add(Restrictions.eq("idMap", mapId));
			//criteria.add(Restrictions.eq("layerGroupName", layerGroupName).ignoreCase());
			criteria.add(Restrictions.eq("layerGroupName", layerGroupName));
			layerGroups = criteria.list();
			
			if (layerGroups.size() > 1) {
				throw new RuntimeException("Must be less than one");
			}
			
			if (layerGroups.size() == 0) return null;
			return layerGroups.get(0);

//		} catch (Exception x) {
//			// Log
//			throw x;
//		}
	}
	
	public void deleteLayerGroup(Session session, int layerGroupId) {
//		try {
			LayerGroup layerGroup = loadById(session, LayerGroup.class, layerGroupId);
			delete(session, layerGroup);
			
//		} catch (Exception x) {
//			// Log
//			throw x;
//		}
	} 
}
