var TestPlugin = function() {
	var self = this;
	
	this.active = false;
	
	this.toggle = function(button) {	
		if(!button.hasClass("btn-active")) {
			this.activate(button);
		}
		else {
			this.deactivate(button);
		}
	};

	this.activate = function(button) {
		button.addClass("btn-active");
		this.init();
		this.active = true;
	};

	this.deactivate = function(button) {
		if(!button) {
			button = $('#gis_testBtn');
		}
		button.removeClass("btn-active");
		this.active = false;
	};
	
	this.init = function() {
		AlertDialog.createOkDefaultDialog("TEST TITLE", "Hello world!!", "info", function() {
			//User clicked on message -> control must be disactivated.
			self.deactivate();
			
		});
	};
};

var testPlugin = new TestPlugin();