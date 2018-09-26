package it.gesp.geoportal.dao.entities;

import it.gesp.geoportal.json.GeoportalGsonExclusionStrategy;
import it.gesp.geoportal.json.JsonUtils;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import org.hibernate.annotations.Type;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.gesp.geoportal.GsonExclude;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;

@Entity
@Table(name = "maps", uniqueConstraints = { @UniqueConstraint(columnNames = { "id_map" }) })
public class Map {

	private int idMap;
	private String mapName;
	private String projection;
	private String units;
	
	private double defaultExtentMinX;
	private double defaultExtentMinY;
	private double defaultExtentMaxX;
	private double defaultExtentMaxY;
	
	private boolean showOverview;
	private Double maxScale;
	private Double dotsPerInch;
	private String enableCustomScalesResolutions;
	private String customScales;
	private String customResolutions;
	private String thumbnail;
        
        @GsonExclude
	private List<Role> roles;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id_map", nullable = false, unique = true)
	public int getIdMap() {
		return idMap;
	}

	public void setIdMap(int idMap) {
		this.idMap = idMap;
	}
	
	@Column(name = "s_name", nullable = false, unique=true)
	public String getMapName() {
		return mapName;
	}

	public void setMapName(String mapName) {
		this.mapName = mapName;
	}

	@Column(name = "s_projection", nullable = false)
	public String getProjection() {
		return projection;
	}

	public void setProjection(String projection) {
		this.projection = projection;
	}

	@Column(name = "s_units", nullable = false)
	public String getUnits() {
		return units;
	}

	public void setUnits(String units) {
		this.units = units;
	}

	@Transient
	public List<Double> getDefaultExtentAsObject() {
		List<Double> resultList = new ArrayList<Double>();
		
		resultList.add(getDefaultExtentMinX());
		resultList.add(getDefaultExtentMinY());
		resultList.add(getDefaultExtentMaxX());
		resultList.add(getDefaultExtentMaxY());
		return resultList;
	}
	
	@Column(name = "f_show_overview", nullable = false)
	public boolean isShowOverview() {
		return showOverview;
	}

	public void setShowOverview(boolean showOverview) {
		this.showOverview = showOverview;
	}

	@Column(name = "d_dots_per_inch_override")
	public Double getDotsPerInch() {
		return dotsPerInch;
	}

	public void setDotsPerInch(Double dotsPerInch) {
		this.dotsPerInch = dotsPerInch;
	}

	
	@Type(type = "StringJsonObject")
	@Column(name = "j_custom_scales")
	public String getCustomScales() {
		return customScales;
	}

	@Transient
	public List<Integer> getCustomScalesAsList() {
		String customScalesAsJson = getCustomScales();
		
		Gson gson = new GsonBuilder().setExclusionStrategies(new GeoportalGsonExclusionStrategy()).create();
		List<Integer> scaleList = JsonUtils.parseJsonAsIntegerList(gson, customScalesAsJson);
		return scaleList;	
	}
	
	public void setCustomScales(String customScales) {
		this.customScales = customScales;
	}

	@Column(name = "custom_scales_resolutions")
	public String getEnableCustomScalesResolutions() {
		return enableCustomScalesResolutions;
	}

	public void setEnableCustomScalesResolutions(
			String enableCustomScalesResolutions) {
		this.enableCustomScalesResolutions = enableCustomScalesResolutions;
	}

	@Type(type = "StringJsonObject")
	@Column(name = "j_custom_resolutions")
	public String getCustomResolutions() {
		return customResolutions;
	}

	@Transient
	public List<Double> getCustomResolutionsAsList() {
		String customResolutionsAsJson = getCustomResolutions();
		
		Gson gson = new GsonBuilder().setExclusionStrategies(new GeoportalGsonExclusionStrategy()).create();
		List<Double> resolutionList = JsonUtils.parseJsonAsDoubleList(gson, customResolutionsAsJson);
		return resolutionList;	
	}
	
	public void setCustomResolutions(String customResolutions) {
		this.customResolutions = customResolutions;
	}

	@Column(name = "f_maxscale", nullable = true)
	public Double getMaxScale() {
		return maxScale;
	}

	public void setMaxScale(Double maxScale) {
		this.maxScale = maxScale;
	}

	@Column(name = "f_default_extent_minx", nullable = false)
	public double getDefaultExtentMinX() {
		return defaultExtentMinX;
	}

	public void setDefaultExtentMinX(double defaultExtentMinX) {
		this.defaultExtentMinX = defaultExtentMinX;
	}

	@Column(name = "f_default_extent_miny", nullable = false)
	public double getDefaultExtentMinY() {
		return defaultExtentMinY;
	}

	public void setDefaultExtentMinY(double defaultExtentMinY) {
		this.defaultExtentMinY = defaultExtentMinY;
	}

	@Column(name = "f_default_extent_maxx", nullable = false)
	public double getDefaultExtentMaxX() {
		return defaultExtentMaxX;
	}

	public void setDefaultExtentMaxX(double defaultExtentMaxX) {
		this.defaultExtentMaxX = defaultExtentMaxX;
	}

	@Column(name = "f_default_extent_maxy", nullable = false)
	public double getDefaultExtentMaxY() {
		return defaultExtentMaxY;
	}

	public void setDefaultExtentMaxY(double defaultExtentMaxY) {
		this.defaultExtentMaxY = defaultExtentMaxY;
	}
	
	@Column(name="thumbnail")
	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}
	
	@ManyToMany(cascade = {CascadeType.ALL})
	@JoinTable(name = "role_permission", joinColumns = { @JoinColumn(name = "id_role", nullable = false, updatable = false) }, inverseJoinColumns = { @JoinColumn(name = "id_permission", nullable = false, updatable = false) })
	public List<Role> getRoles() {
		return roles;
	}
        
        @Transient
        public List<Integer> getRolesId(){
            List<Integer> ids = new ArrayList<Integer>();
            for(Role r : this.getRoles()){
                ids.add(r.getIdRole());
            }
            return ids;
        }

	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}
	
}