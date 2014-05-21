dojo.provide("atg.store.widget.AutoSuggest");

dojo.declare(
	"atg.store.widget.AutoSuggest",
	[dijit._Widget, dijit._Templated, dijit._Container],
	{
		debugOn: false,
		id: "",
		ajaxUrl: "",
		contentCollection: "",
		siteContextPath: "",
		minInputLength: 3,
		searchBoxId: "",
		submitButtonId: "",
		animationDuration: 500,
		totalSuggestions: 0,
		userInput: "",
		currentLinkIndex: 0,
		connections: new Array(),
		templatePath: dojo.moduleUrl("atg.store.widget", "template/AutoSuggest.html"),
		templateString: "",
		xhr: "",
		data: null,
		
		startup: function() {
			console.debug("autoSuggest startup");

			var searchBox = dojo.byId(this.searchBoxId);
			
			// handle keyup events on search box
			dojo.connect(searchBox, 
				"keyup", 
				this, 
				this.handleKeyup);

			// handle keypress events on search box
			dojo.connect(searchBox, 
				"keypress", 
				this, 
				this.handleKeypress);

			this.hide();
		},

		handleKeyup: function(event){
			switch(event.keyCode) {
				case dojo.keys.DOWN_ARROW:
				case dojo.keys.UP_ARROW:
					if (this.totalSuggestions > 0){
						this.selectSuggestedItem(event.keyCode);
					}
				break;
				case dojo.keys.ESCAPE:
				case dojo.keys.ENTER:
				case dojo.keys.LEFT_ARROW:
				case dojo.keys.RIGHT_ARROW:
					// do nothing more
				break;
				default:
					this.doSearch();
				break;
			}
		},

		handleKeypress: function(event){
			switch(event.keyCode) {
				case dojo.keys.DOWN_ARROW:
				case dojo.keys.UP_ARROW:
					event.preventDefault();
				break;
				case dojo.keys.TAB:
				case dojo.keys.ESCAPE:
					this.closeSuggestionList();
					this.saveUserSearchTerm(this.getUserSearchTerm());
				break;
				default:
				break;
			}
		},
		
		doSearch: function(){
			var searchTerm = this.getUserSearchTerm();

			if (searchTerm != this.userInput){
				if (searchTerm.length >= this.minInputLength){
					this.requestData(searchTerm);
				}
				else{
					this.cancelRequest();
					this.hide();
				}
				this.saveUserSearchTerm(searchTerm);
			}
			
		},

		getUserSearchTerm: function(){
			return dojo.trim(dojo.byId(this.searchBoxId).value.toLocaleLowerCase());
		},

		saveUserSearchTerm: function(searchTerm){
			this.userInput = searchTerm.toLocaleLowerCase();
		},

		addClickEventHandlers: function(){
			var self = this;
			var searchBox = dojo.byId(this.searchBoxId);

			// add body click handler to close suggestion list
			// when the user clicks outside the list
			this.connections.push(
				dojo.connect(document,
					"click",
					this,
					self.hide)
			);

			// add click handler to suggestion list to suppress click
			// from bubbling to the body handler
			// i.e. don't close suggestion list when it is clicked
			this.connections.push(
				dojo.connect(self.containerNode,
					"click",
					this,
					function(event){
						event.stopPropagation();
					})
			);

			// add click handler to the search box to suppress click
			// from bubbling to the body handler
			// i.e. don't close suggestion list when search box is clicked
			this.connections.push(
				dojo.connect(searchBox,
					"click",
					this,
					function(event){
						event.stopPropagation();
					})
			);
		},

		removeClickEventHandlers: function(){
			dojo.forEach(this.connections, dojo.disconnect);
		},
		
		requestData: function(searchTerm){
			this.cancelRequest();
			
			var seperator = this.ajaxUrl.indexOf("?") === -1 ? "?" : "&"; 
			
			var url =	this.ajaxUrl +
				seperator +
				"format=json&Dy=1&assemblerContentCollection=" +
				this.contentCollection +
				"&Ntt=" +
				searchTerm +
				"*";

			var self = this;
			
			var bindParams={
				url: url, 
		        headers: { "Accept" : "application/json" },
		        mimetype: "application/json",
		        handleAs: "json",
		        load: function(data, ioArgs) {
		          self.handleResponse(data,ioArgs);
		        },
		        error: function(data, ioArgs) {
		          self.handleError(data, ioArgs);
		        },
		        timeout: function(data, ioArgs) {
		          self.handleError(data, ioArgs);
		        }
		    };
			
			this.xhr = dojo.xhrGet(bindParams);
			
		},

		cancelRequest: function(){
			if (this.xhr){
				this.xhr.cancel();
			}
		},
		
		handleResponse: function(data, ioArgs){

			var autoSuggestDimension = this.getAutoSuggestDimension(data);

			if (autoSuggestDimension && autoSuggestDimension.dimensionSearchGroups
					&& autoSuggestDimension.dimensionSearchGroups.length > 0) {

				this.createListHtml(autoSuggestDimension.dimensionSearchGroups);

				this.show();
			}
			else{
				this.hide();
			}
		},
		
		handleError: function(data, ioArgs){
			if (data.dojoType=='cancel') {
				// xhr.cancel triggers the error callback
				// inspect the data.dojoType, if it's
				// the result of a cancel we can ignore
				return;
			}

			// assuminng we should fail silently
			// as type ahead is an enhancement and
			// not critical to being able to peform
			// a search
		    console.debug("AutoSuggest: in handleError, xhrGet failed");
		},

		show: function(){
			dojo.removeClass(this.domNode, "hide");
			var fadeArgs = {
				node: this.domNode,
				duration: this.animationDuration
			};
			dojo.fadeIn(fadeArgs).play();

			// reset the currently selected link
			this.currentLinkIndex = 0;

			this.addClickEventHandlers();
		},

		hide: function(){
			var fadeArgs = {
				node: this.domNode,
				duration: this.animationDuration
			};
			dojo.fadeOut(fadeArgs).play();
			dojo.addClass(this.domNode, "hide");
			this.totalSuggestions = 0;

			this.removeClickEventHandlers();
		},

		getAutoSuggestDimension: function(data){
			var autoSuggestDimension = null;
			var filteredItems = dojo.filter(data.contents[0].autoSuggest, function(item){
				return item["@type"] === "DimensionSearchAutoSuggestItem";
			});

			if (filteredItems && filteredItems.length > 0){
				autoSuggestDimension = filteredItems[0];
			}

			return autoSuggestDimension;
		},

		createListHtml: function(groups){
			
			dojo.empty(this.containerNode);

			var ul = dojo.create("ul", null, this.containerNode, "first");

			dojo.forEach(groups, function(group){
				dojo.forEach(group.dimensionSearchValues, function(suggestionItem){
					this.createListItemHtml(suggestionItem, ul);
					this.totalSuggestions++;
				}, this);
			}, this);
		},

		createListItemHtml: function(suggestionItem, ul){
			var action = suggestionItem.contentPath + suggestionItem.navigationState;
			var text = suggestionItem.label.toLocaleLowerCase();
			var ancestorsText = ""; 

			if (suggestionItem.ancestors){
				dojo.forEach(suggestionItem.ancestors, function(ancestor){
					ancestorsText +=  ancestor.label + " > ";
				});
			}

			var li = dojo.create("li", null, ul);

			this.createLink(li, action, text, ancestorsText);
		},

		createLink: function(li, action, text, ancestorsText){
			var innerHtml = ancestorsText + text;
			var regEx = new RegExp(this.userInput,"gi");
			var highlight = "<span class='highlight'>" + this.userInput.toLocaleLowerCase() + "</span>";
			innerHtml = innerHtml.replace(regEx, highlight)

			var link = dojo.create("a", {
						href: this.createLinkHref(action),
						title: ancestorsText + text,
						innerHTML: innerHtml},
					li);

			var self = this;

			// if user clicks on an option in the list
			// update the value in the search box
			// and submit the search form... this means
			// a search will be performed rather than
			// a dimension value change
			dojo.connect(link, "onclick", function(event){
				dojo.stopEvent(event);
				dojo.byId(self.searchBoxId).value = this.innerText || this.textContext || this.text;
				dojo.byId(self.submitButtonId).click();
			});
		},

		createLinkHref: function(action){
			var query = action.substring(action.indexOf("?") + 1, action.length);
			var queryObject = dojo.queryToObject(query);

			queryObject.format = null;
			queryObject.assemblerContentCollection = null;

			var href = this.siteContextPath + 
				action.substring(0, action.indexOf("?") + 1) +
				dojo.objectToQuery(queryObject);

			return	href;
		},

		resetSearchBox: function(){
			var searchBox = dojo.byId(this.searchBoxId);
			searchBox.value = this.userInput;
			searchBox.focus();
			this.currentLinkIndex = 0;
		},

		closeSuggestionList: function(){
			var searchBox = dojo.byId(this.searchBoxId);
			searchBox.focus();
			this.hide();
		},

		selectSuggestedItem: function(keyCode){
			var allLinks = dojo.query("a", this.containerNode);
			var self = this;

			switch(keyCode) {
				case dojo.keys.UP_ARROW:
					setNextNode(-1);
				break;
				case dojo.keys.DOWN_ARROW:
					setNextNode(1);
				break;
				default:
				break;
    		}

	    	function setNextNode(indexChange){

	    		var currentLink = allLinks[self.currentLinkIndex - 1];

	    		if (currentLink){
	    			// remove style from currently selected link
		    		dojo.removeClass(currentLink, "selected");
		    	}

		    	self.currentLinkIndex += indexChange;

		    	if(self.currentLinkIndex < 0){
		    		// user has pressed up with no item selected
		    		// so move to last link in list
		    		self.currentLinkIndex = allLinks.length;
				}

				// get link at specified index, if it exists
		    	currentLink = allLinks[self.currentLinkIndex - 1];

				if(currentLink){
					// highlight link and update text in search box
					dojo.addClass(currentLink, "selected");
					dojo.byId(self.searchBoxId).value = currentLink.innerText || currentLink.textContext || currentLink.text;
				}
				else{
					// user has pressed down from last link
					// or has pressed up from first link
					// so reset value in search box to
					// the user's original input
					self.resetSearchBox();
				}
				
	    	}

		}
  })