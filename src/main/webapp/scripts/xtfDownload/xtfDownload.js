var xtfDownload = {
		active : false,
		panel: null,
		
		init: function() {
			if(this.panel == null){
				this.panel = $("#xtfdownload-panel");
				this.button = $("#xtfdownload-btn");
				
				
				$.ajax({
					url: "http://validador.proadmintierra.info:8083/ilivalidator/v1/export_catalogue",
					method: "GET",
					dataType: "json"
				}).done(function(data){
					
					$.each(data, function( index, item ) {
						var option1 = $("<option>",{text: item.name, value: item.id});
						
						$("#xtfdownload-dataset").append(option1);
						});
				});
				
				
				
			}
			
			this.openPanel();
		},
		toggle: function(button) {	
			if(!button.hasClass("btn-active")) {
				this.activate(button);
			}
			else {
				this.deactivate(button);
			}
		},
		activate: function(button) {
			button.addClass("btn-active");
			this.init();	
			this.active = true;
		},
		
		deactivate: function(button) {
			if(!button)
				if(this.button == null)
					return;
				button = this.button;
			
			button.removeClass("btn-active");
			this.closePanel();
			this.resetPanel();
			this.active = false;
		},
		/** ***************************
		 *  Open Go To coordinates panel
		 *  ***************************/
		openPanel: function() {
			this.panel.show();
			console.log(this.panel);
		},
		
		/** *****************************
		 *  Close Go To coordinates panel
		 *  *****************************/
		closePanel: function() {	
			// Close tools panel
			if(this.panel != null) {
				this.panel.hide();
			}
		},
		
		resetPanel: function() {
			Utils.cleanForm(this.panel);
		},
		
		downloadXtf: function(){
			
			window.location.href = 
				"http://validador.proadmintierra.info:8083/ilivalidator/v1/export_catalogue/"+$("#xtfdownload-dataset").val();

		}
};