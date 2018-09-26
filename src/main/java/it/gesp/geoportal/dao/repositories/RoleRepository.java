package it.gesp.geoportal.dao.repositories;

import it.gesp.geoportal.dao.entities.Role;
import it.gesp.geoportal.dao.repositories.base.BaseRepository;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

public class RoleRepository extends BaseRepository<Role> {
	
	private static final Logger log = Logger.getLogger(RoleRepository.class);
	
	@SuppressWarnings("unchecked")
	public List<Role> getRoles(Session session) {
		List<Role> roles = null;
		
		String hql ="select role from Role role order by roleName";
		Query query = session.createQuery(hql);
		roles = query.list();
		//roles = this.getAll(session, Role.class);
		return roles;
	}
        
        public List<Role> getRolesByIds(Session session, List<Integer> ids){
            List<Role> roles = null;
            
            String hql ="select role from Role role where role.idRole IN :ids order by roleName";
            Query query = session.createQuery(hql);
            query.setParameterList("ids", ids);
            roles = query.list();
            //roles = this.getAll(session, Role.class);
            return roles;
        }
	
	public void deleteRole(Session session, int roleId) {
		Role role = loadById(session, Role.class, roleId);
		delete(session, role);
	}
}