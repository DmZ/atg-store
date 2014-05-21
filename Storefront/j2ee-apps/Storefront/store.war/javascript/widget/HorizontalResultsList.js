dojo.provide("atg.store.widget.HorizontalResultsList");
dojo.require("dojox.fx.scroll");
dojo.require("dojox.widget.Standby");

dojo.declare(
	"atg.store.widget.HorizontalResultsList",
	[dijit._Widget, dijit._Templated, dijit._Container],
	{
		debugOn: false,
		id: "",
		ajaxUrl: "",
		contentCollection: "",
		siteContextPath: "",
		pageSize: 12,
		totalNumberOfRecords: 0,
		previousLinkTitle: "previous",
		nextLinkTitle: "next",
		viewableRecords: 4,
		firstProductInViewNumber: 0,
		lastProductInViewNumber: 0,
		maxProductNumberRetrieved: 0,
		templatePath: dojo.moduleUrl("atg.store.widget", "template/horizontalResultsList.html"),
		templateString: "",
		xhr: "",
		data: null,
		standby: null,
		
		startup: function() {
			console.debug("HorizontalResultsList startup");

			this.setProductsInView(1);
			
			this.addIdsToListItems();
			
			this.setNavigationLinks();

			this.initStandbyControl();
		},

		setProductsInView: function (startNumber) {
			this.firstProductInViewNumber += startNumber;
			this.lastProductInViewNumber = this.firstProductInViewNumber + this.viewableRecords -1;

			if (this.lastProductInViewNumber > this.maxProductNumberRetrieved){
				this.maxProductNumberRetrieved = this.lastProductInViewNumber;
			}
		},

		addIdsToListItems: function(){
			var counter = 1;
			
      		dojo.query("ul > li", this.containerNode).forEach(function(node, index, array){
          		dojo.attr(node, "id", "product" + counter++);
      		});
		},

		setNavigationLinks: function(){		
      		dojo.empty(this.previousLinkNode);
      		dojo.empty(this.nextLinkNode);
      		var self = this;
		
			if (areLinksRequired()){

				var changeNumber = this.viewableRecords;

				if (isPreviousLinkRequired()){
					
					var node = createLinkNode(this.previousLinkTitle, this.previousLinkNode);

					// previous link just moves previous items into view
					// (Multiplying by -1 to make changeNumber negative)
					addChangeProductsInViewToLinkClick(node, changeNumber * -1)
				}
        
        
				if (isNextLinkRequired()) {

					var node = createLinkNode(this.nextLinkTitle, this.nextLinkNode);

					if (haveNextResultsAlreadyBeenLoaded()) {

						// next link just moves next items into view
						addChangeProductsInViewToLinkClick(node, changeNumber)

					}
					else { 
						// next link needs to get next set of products via Ajax
						addRequestDataToLinkClick(node)
					}
				}
			}

			function areLinksRequired(){
				return !!(self.totalNumberOfRecords > self.viewableRecords);
			}

			function isPreviousLinkRequired(){
				return !!(self.firstProductInViewNumber >= self.viewableRecords);
			}

			function isNextLinkRequired(){
				return !!(self.lastProductInViewNumber < self.totalNumberOfRecords);
			}
			function haveNextResultsAlreadyBeenLoaded(){
				return !!(((self.lastProductInViewNumber % self.pageSize) != 0) ||
						(self.lastProductInViewNumber < self.maxProductNumberRetrieved));
			}
			function createLinkNode(title, attachNode){
				return dojo.create("a", { href: "#", title: title, innerHTML: title }, attachNode);
			}
			function addChangeProductsInViewToLinkClick(node, changeNumber){
				dojo.connect(node, "onclick", function(e){
					dojo.stopEvent(e);
					self.changeProductsInView(changeNumber);
				});
			}
			function addRequestDataToLinkClick(node){
				dojo.connect(node, "onclick", function(e){
					dojo.stopEvent(e);
					self.requestData();
				});
			}
		},

		initStandbyControl : function () {
			this.standby = new dojox.widget.Standby({target: this.id});
			document.body.appendChild(this.standby.domNode);
			this.standby.startup();
		},
		
		changeProductsInView: function(changeNumber){      
      		this.setProductsInView(changeNumber);

			dojox.fx.smoothScroll({
				node: dojo.byId("product" + this.firstProductInViewNumber),
				win: this.containerNode
			}).play();

			this.setNavigationLinks();		
		},
		
		requestData: function(startProductNumber){
			this.standby.show();

			if (this.xhr){
				this.xhr.cancel();
			}

			var url = this.buildAjaxRequestUrl();

			var self = this;
			
			var bindParams={
				url: url, 
				handleAs: "text",
				load: function(data, ioArgs) {
					self.handleResponse(data,ioArgs);
				},
				error: function(data, ioArgs) {
					self.handleError(data, ioArgs);
				},
				timeout: 0
			};
			
			this.xhr = dojo.xhrGet(bindParams);			
		},

		buildAjaxRequestUrl: function(){
			// extract querystring part from the ajaxUrl
			var uri = decodeURIComponent(this.ajaxUrl.replace(/\+/g,  " "));
			var query = dojo.queryToObject(uri.substring(uri.indexOf("?") + 1, uri.length))
			
			// update the "No" parameter
			query.No = this.lastProductInViewNumber;

			// add the "contentCollection" parameter
			query.contentCollection = this.contentCollection;

			// append to cartridge path
			return this.siteContextPath + "/cartridges/HorizontalResultsList/HorizontalResultsList.jsp?" + dojo.objectToQuery(query);
		},
		
		handleResponse: function(data, ioArgs){
			var ul = dojo.query("ul", this.containerNode)[0]; // assuming content UL is always first

			dojo.place(data, ul, "last")

			this.setProductsInView(this.viewableRecords);

			this.addIdsToListItems();

			// pass 0 to changeProductsInView()
			// as call to setProductsInView()
			// has already updated first/last in view numbers
			this.changeProductsInView(0);

			this.standby.hide();
		},
		
		handleError: function(data, ioArgs){
			if (ioArgs.dojoType=='cancel') {
				// xhr.cancel triggers the error callback
				// inspect the args dojoType, if it's
				// the result of a cancel we can ignore
				return;
			}

			// TODO: what should be display to the user when data retrieval failed?
			console.debug("HoriziontalResultsList: in handleError, xhrGet failed");

			this.standby.hide();
		}
  })