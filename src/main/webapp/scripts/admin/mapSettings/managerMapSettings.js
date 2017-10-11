var mMapSettings = {
	pFormAddMap: null,
	validatorFormAddMap: null,
		
	init: function(){
		
		if(this.pFormAddMap == null){
			this.pFormAddMap = $("#form-addmap-dialog");
			
			this.validatorFormAddMap = new Validate({
				form: this.pFormAddMap
			});
			
//			var buttons = {};
//			buttons[LocaleManager.getKey('General_Cancel')] = function(){
//				Utils.closeDialogForm(mMaps.pFormAddMap);
//			};
//			
//			buttons[LocaleManager.getKey('General_Save')] = function(){
//				//mMaps.submitAddMap();
//				mMapSettings.requests.saveData();
//			};
//			
//			DialogUtils.renderDialog(LocaleManager.getKey("General_TitleForm"), buttons, {
//				modal: false,
//				resizable: false,
//				height: 200,
//				width: 400,
//				closeFn: function() {
//					Utils.cleanForm(this.pFormAddMap);
//				}
//			}, this.pFormAddMap);
		}
	},
	
	
	/*
	
	openUpdateForm: function() {
	 	this.createUpdateFormPanel();
		Utils.cleanForm(this.pForm);
		
		var selectedRow = Utils.getSelectedRow(this.dt)[0];
		this.populateDataForm(selectedRow);
		
		this.pForm.dialog("open");
	 */
	
	/**
	 * Open dialog to insert a new map
	 * @Author: Agencia de implementacion
	 * */
	openDialogAddMap: function(){
		this.createUpdateFormPanel();
		Utils.cleanForm(this.pFormAddMap);
		if(this.pFormAddMap != null)
			if(this.validatorFormAddMap != null){
				this.validatorFormAddMap.reset();
			}
		
		// populatePage?
		//mMapSettings.requests.getData();
		
		this.pFormAddMap.dialog("open");
		
		return;
	},
	openDialogUpdateMap:  function(){
		this.createUpdateFormPanel();
		Utils.cleanForm(this.pFormAddMap);
		if(this.pFormAddMap != null)
			if(this.validatorFormAddMap != null){
				this.validatorFormAddMap.reset();
			}
		
		// populatePage?
		mMapSettings.requests.getData();
		
		this.pFormAddMap.dialog("open");
		
		return;
	},
	
	
	createUpdateFormPanel: function() {
		//$("#form-dialog-header").data("locale_key", "Manager_Layers_HeaderForm_Update");
		//LocaleManager.refreshLocalizedElement($("#form-dialog-header"));
		
		//Reset validator
		if(this.validatorFormAddMap) {
			this.validatorFormAddMap.reset();
		}
		
		var buttons = {};
		buttons[LocaleManager.getKey('General_Cancel')] = function(){
			//Utils.closeDialogForm(mMaps.pFormAddMap);
			$(this).dialog("close");
		};
		
		buttons[LocaleManager.getKey('General_Save')] = function(){
			//mMaps.submitAddMap();
			mMapSettings.requests.updateData();
			$(this).dialog("close");
		};
		
		DialogUtils.renderDialog(LocaleManager.getKey("General_TitleForm"), buttons, {
			modal: false,
			resizable: false,
			height: 400,
			width: 700,
			closeFn: function() {
				Utils.cleanForm(this.pFormAddMap);
			}
		}, this.pFormAddMap);
		
		return this.pFormAddMap;
	},
	
	createAddFormPanel: function() {
		//$("#form-dialog-header").data("locale_key", "Manager_Layers_HeaderForm_Update");
		//LocaleManager.refreshLocalizedElement($("#form-dialog-header"));
		
		//Reset validator
		if(this.validatorFormAddMap) {
			this.validatorFormAddMap.reset();
		}
		
		var buttons = {};
		buttons[LocaleManager.getKey('General_Cancel')] = function(){
			//Utils.closeDialogForm(mMaps.pFormAddMap);
			$(this).dialog("close");
		};
		
		buttons[LocaleManager.getKey('General_Save')] = function(){
			//mMaps.submitAddMap();
			mMapSettings.requests.addData();
			$(this).dialog("close");
		};
		
		DialogUtils.renderDialog(LocaleManager.getKey("General_TitleForm"), buttons, {
			modal: false,
			resizable: false,
			height: 400,
			width: 700,
			closeFn: function() {
				Utils.cleanForm(this.pFormAddMap);
			}
		}, this.pFormAddMap);
		
		return this.pFormAddMap;
	},
	/**
	 * Submit new map
	 * @Author Agencia de implementacion
	 * */
	submitAddMap: function(){
		var isValid = this.validatorFormAddMap.valid();
		if(!isValid){
			return;
		}
		
		var mapName = $("#map-input-name").val();
		this.requests.addNewMap(mapName);
		return true;
	},
	
	/**
	 * TODO add map
	 * @Author Agencia de implementacion
	 * */
	addNewMap: function(mapNameParam){
		Utils.ajaxCall(Services.getMapConfigUrl(), "POST", "json",{
			oper: "addMap",
			mapName: mapNameParam
		}, function(){
			mMaps.updateData();
			Utils.closeDialogForm(mMaps.pFormAddMap);
		}, null);
	},
	
	
	getDataFromPage: function() {
		var settings = new Object();
		
		settings.projection = $("#projection-input").val();
		settings.units = $("#units-input").val();
		
		
		//Set mapscale if it is a valid value
		var maxScale = $("#default-maxscale-input").val();
		if (Utils.isFloat(maxScale)) {
			settings.maxScale = maxScale;	
		}
		
		settings.zoom = $("#default-zoomlevel-input").val();
		settings.centerx = $("#centerx-input").val();
		settings.centery = $("#centery-input").val();
		
		settings.defaultExtentMinX = $("#minx-input").val();
		settings.defaultExtentMinY = $("#miny-input").val();
		settings.defaultExtentMaxX = $("#maxx-input").val();
		settings.defaultExtentMaxY = $("#maxy-input").val();
		
		settings.showOverview = $("#show_overview").is(":checked");
		settings.dotsPerInch = $("#dots-per-inch-input").val();
		if (settings.dotsPerInch.trim() == "") {
			settings.dotsPerInch = null;
		}
		
		/*
		 * Custom scales / resolutions radio
		 */
		var enableCustomScalesResolutionsVal = "";
		var selectedRadio = $("input[type='radio'][name='enable_custom_scales_resolutions']:checked");
		if (selectedRadio.length > 0) {
			enableCustomScalesResolutionsVal = selectedRadio.val();
		}
		settings.enableCustomScalesResolutions = enableCustomScalesResolutionsVal;
		
		settings.customScales = this.getScalesFromPage();
		settings.customResolutions  = this.getResolutionsFromPage(); 
		
		return settings;
	},
	
	refreshDataButtons: function() {
		var numScalesSelected = $("#list_scales .ui-selected").length;
		if (numScalesSelected > 0) {
			$("#scales-delete").show();
		}
		else {
			$("#scales-delete").hide();
		}
		
		var numResolutionsSelected = $("#list_resolutions .ui-selected").length;
		if (numResolutionsSelected > 0) {
			$("#resolutions-delete").show();
		}
		else {
			$("#resolutions-delete").hide();
		}
	},
	
	populatePage: function(settings) {
		$("#projection-input").val(settings.projection);
		$("#units-input").val(settings.units);
		
		$("#default-maxscale-input").val(settings.maxScale);
		
//		$("#default-zoomlevel-input").val(settings.zoom);
//		$("#centerx-input").val(settings.centerx);
//		$("#centery-input").val(settings.centery);
		
		$("#minx-input").val(settings.defaultExtentMinX);
		$("#miny-input").val(settings.defaultExtentMinY);
		$("#maxx-input").val(settings.defaultExtentMaxX);
		$("#maxy-input").val(settings.defaultExtentMaxY);
		
		$("#show_overview").prop('checked', settings.showOverview);
		
		$("#dots-per-inch-input").val(settings.dotsPerInch);
		
		/*
		 * Scales / resolutions radio
		 */
		$("input[type='radio'][name='enable_custom_scales_resolutions']").prop("checked", false);
		
		if (settings.enableCustomScalesResolutions === "scales") {
			$("#custom_sr_scales").prop("checked", true);
		}
		else if (settings.enableCustomScalesResolutions === "resolutions") {
			$("#custom_sr_resolutions").prop("checked", true);
		}
		else {
			$("#custom_sr_none").prop("checked", true);
		}
		
		/*
		 * Populate scales
		 */
		var scaleList = settings.customScales;
		this.populateScales(scaleList);
		
		/*
		 * Populate resolutions
		 */
		var resolutionList = settings.customResolutions;
		this.populateResolutions(resolutionList);
		
	},
	
	populateScales: function(scaleArray) {
		mMapSettings.refreshDataButtons();
		var list = $("#list_scales");
		list.empty();
		
		if (!Utils.isNullOrUndefined(scaleArray)) {
			Utils.populateListFromArray($("#list_scales"), scaleArray, "scale");
			$(list).selectable({
				stop: function() {
					mMapSettings.refreshDataButtons();
				}
			});
		}
	},
	
	getScalesFromPage: function() {
		var scales = [];
		$("#list_scales li").each(function(k,v){
			var textValue = $(v).text();
			var intValue = parseInt(textValue);
			scales.push(intValue);
		});
		
		return scales;
	},
	
	deleteScale: function() {
		$("#list_scales .ui-selected").remove();
	},
	
	addScale: function() {
		var newValue = $("#scale-input").val();
		
		/*
		 * Test that the value is an integer
		 */
		if (!Utils.isInt(newValue)) {
			AlertDialog.createOkDefaultDialog(LocaleManager.getKey("General_Error"), LocaleManager.getKey("Manager_Map_Settings_CustomScale_Integer"), "warning");
			return;
		}
		
		var currentScaleList = this.getScalesFromPage();
		$("#scale-input").val("");
		
		currentScaleList.push(parseInt(newValue));
		Utils.orderArrayNumber(currentScaleList);
		
		this.populateScales(currentScaleList);
	},
	
	populateResolutions: function(resolutionArray) {
		mMapSettings.refreshDataButtons();
		var list = $("#list_resolutions");
		list.empty();
		if (!Utils.isNullOrUndefined(resolutionArray)) {
			Utils.populateListFromArray($("#list_resolutions"), resolutionArray, "resolution");
			$(list).selectable({
				stop: function() {
					mMapSettings.refreshDataButtons();
				}
			});	
		}
	},
	
	getResolutionsFromPage: function() {
		var resolutions = [];
		$("#list_resolutions li").each(function(k,v){
			var textValue = $(v).text();
			var floatValue = parseFloat(textValue);
			resolutions.push(floatValue);
		});
		
		return resolutions;
	},
	
	deleteResolution: function() {
		$("#list_resolutions .ui-selected").remove();
	},
	
	addResolution: function() {
		var newValue = $("#resolution-input").val();
		
		/*
		 * Test that the value is a float
		 */
		if (!Utils.isFloat(newValue)) {
			AlertDialog.createOkDefaultDialog(LocaleManager.getKey("General_Error"), LocaleManager.getKey("Manager_Map_Settings_CustomResolution_Float"), "warning");
			return;
		}
		
		var currentResolutionList = this.getResolutionsFromPage();
		$("#resolution-input").val("");
		
		currentResolutionList.push(parseFloat(newValue));
		Utils.orderArrayNumber(currentResolutionList);
		
		this.populateResolutions(currentResolutionList);
	},
	
	requests: {		
		
		getData: function() {
			
			//Reset validator
			if(validator) {
				validator.reset();
			}
			
			Utils.ajaxCallSynch("./mapConfig", "POST", "json", {
				oper: "mapSettings"
			}, function(response) {
				if(response.success) {
					mMapSettings.populatePage(response.result);
				}
			});
		},
		
		updateData: function() {
			var isValid = validator.valid();
			if(!isValid) {
				return;
			}
			
			var settings = mMapSettings.getDataFromPage();
			Utils.ajaxCallSynch("./mapConfig", "POST", "json", {
				oper: "saveMapSettings",
				settings: JSON.stringify(settings) 
			}, function(response) {				
				if(response.success) {
					AlertDialog.createOkDefaultDialog(LocaleManager.getKey("Manager_Item_ConfigSystem"), LocaleManager.getKey("Manager_Config_Saved_Ok"), "info", function() {
						//Reload
						mMapSettings.requests.getData();
					});
				}
			});
		},
		
		addData: function(){
			var isValid = validator.valid();
			if(!isValid) {
				return;
			}
			
			var settings = mMapSettings.getDataFromPage();
			Utils.ajaxCallSynch("./mapConfig", "POST", "json", {
				oper: "createNewMap",
				settings: JSON.stringify(settings) 
			}, function(response) {				
				if(response.success) {
					AlertDialog.createOkDefaultDialog(LocaleManager.getKey("Manager_Item_ConfigSystem"), LocaleManager.getKey("Manager_Config_Saved_Ok"), "info", function() {
						//Reload
						mMapSettings.requests.getData();
					});
				}
			});
		}
		
	}
};