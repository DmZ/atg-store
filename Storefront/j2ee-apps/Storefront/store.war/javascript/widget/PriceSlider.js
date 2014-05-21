dojo.provide("atg.store.widget.PriceSlider");

dojo.declare(
  "atg.store.widget.PriceSlider",
  [dijit._Widget, dijit._Templated, dijit._Container],
  {
    debugOn: false,
    id: "",
    formattedMinimum: "",
    formattedMaximum: "",
    selectedMinimum: 0,
    selectedMaximum: 0,
    sliderMinimum: 0,
    sliderMaximum: 0,
    contentItemPricePropertyName: "",
    isMouseDown: false,
    slider: null,
    templatePath: dojo.moduleUrl("atg.store.widget", "template/priceSlider.html"),
    templateString: "",

    startup: function() {
      console.debug("autoSuggest startup");

      this.minPriceNode.innerHTML = this.formattedMinimum;
      this.maxPriceNode.innerHTML = this.formattedMaximum;

      // the position of the min handle, if user has not
      // previously selected a min value then set to sliderMinimum (start)
      this.selectedMinimum = parseInt(this.selectedMinimum, 10) || this.sliderMinimum;

      // the position of the max handle, if user has not
      // previously selected a max value then set to sliderMaximum (end)
      this.selectedMaximum = parseInt(this.selectedMaximum, 10) || this.sliderMaximum;

      // lower and upper bound value sanity checks
      // ... ensure that the position of the min and
      // max handles are within the allowable range
      if (this.selectedMinimum < this.sliderMinimum){
        this.selectedMinimum = this.sliderMinimum;
      }
      if (this.selectedMaximum > this.sliderMaximum){
        this.selectedMaximum = this.sliderMaximum;
      }

      var self = this;

      this.slider = new dojox.form.HorizontalRangeSlider({
          name: "rangeSlider",
          value: [self.selectedMinimum, self.selectedMaximum],
          minimum: self.sliderMinimum,
          maximum: self.sliderMaximum,
          intermediateChanges: true,
          discreteValues: (self.sliderMaximum - self.sliderMinimum) + 1,
          showButtons: false,
          pageIncrement: 10,
          style: "width:140px;margin-left:27px;height:26px;",
          isMouseDown: false,
          connections: new Array(),
          currentMinValue: self.selectedMinimum,
          currentMaxValue: self.selectedMaximum,
          contentItemPricePropertyName: self.contentItemPricePropertyName,
          hasValueChanged: false,

          setMouseDownAttr: function(){
            this.isMouseDown = true;
          },

          toggleMinPriceLabel: function(){
            dojo.query("#minPrice").toggleClass("highlight");
          },

          toggleMaxPriceLabel: function(){
            dojo.query("#maxPrice").toggleClass("highlight");
          },

          toggleBothMinAndMaxPriceLabel: function(){
            this.toggleMinPriceLabel();
            this.toggleMaxPriceLabel();
          },

          addConnections: function(){
            // focus event on the min selector handle
            this.connections.push(
              dojo.connect(this.sliderHandle, "focus", this, this.toggleMinPriceLabel)
            );

            // blur event on the min selector handle
            this.connections.push(
              dojo.connect(this.sliderHandle, "blur", this, this.toggleMinPriceLabel)
            );

            // focus event on the max selector handle
            this.connections.push(
              dojo.connect(this.sliderHandleMax, "focus", this, this.toggleMaxPriceLabel)
            );

            // blur event on the max selector handle
            this.connections.push(
              dojo.connect(this.sliderHandleMax, "blur", this, this.toggleMaxPriceLabel)
            );

            // focus event on the range bar handle
            this.connections.push(
              dojo.connect(this.progressBar, "focus", this, this.toggleBothMinAndMaxPriceLabel)
            );

            // blur event on the range bar handle
            this.connections.push(
              dojo.connect(this.progressBar, "blur", this, this.toggleBothMinAndMaxPriceLabel)
            );
          
            // NOTE: onMouseDown event is not firing on the slider 
            // widget (Dojo bug?) so wiring up mouseDown event handlers
            // for min handle, range bar and max handle using dojo.connect

            // mouse down on the min selector handle  
            this.connections.push(
              dojo.connect(this.sliderHandle, "mousedown", this, this.setMouseDownAttr)
            );

            // mouse down on the range bar handle  
            this.connections.push(
              dojo.connect(this.progressBar, "mousedown", this, this.setMouseDownAttr)
            );

            // mouse down on the max selector handle  
            this.connections.push(
              dojo.connect(this.sliderHandleMax, "mousedown", this, this.setMouseDownAttr)
            );

            // need to handle scenario where the mouse
            // button is released when the mouse
            // is not over the widget, so trap mouse
            // up event on the page document element
            this.connections.push(
              dojo.connect(dojo.doc, "mouseup", this, function(evt){
                if (this.isMouseDown){
                  // the user has previously clicked on the price
                  // slider widget, so regardless of where they
                  // released the mouse the widget's mouse up
                  // event handler needs to be called
                  this.onMouseUp();
                }
              })
            );
          },

          deleteConnections: function(){
            dojo.forEach(connections, dojo.disconnect);
          },

          onChange: function(value){

            /* START FIX */
            if(!dojo.isArray(value)){
              // the slider widget value should contain an array of
              // two values (the selected min value and the selected max value)
              // however, under certain circumstances this.value changes from
              // an array of two values to an integer, which results in an
              // unhandled exception. If the value does not contain an array
              // simply reset to the last known good values.
              this.value = value = [this.currentMinValue, this.currentMaxValue];
            }
            /* END FIX */

            self.updateOnScreenValues(value[0], value[1]);

            // store the selected min and max values
            this.currentMinValue =  value[0];
            this.currentMaxValue = value[1];
          
            // We only want to post the request when a lower or upper value has actually changed.
            // For example, when the user moves a lower or upper slider to another value, then back 
            // to the original value in a single movement, don't post.
            if ((self.selectedMinimum != this.currentMinValue) || (self.selectedMaximum != this.currentMaxValue)) {
              this.hasValueChanged = true;
            }
            else {
              this.hasValueChanged = false;
            }
          },

          onMouseUp: function(){
            this.isMouseDown = false;

            if (this.hasValueChanged){

              // build new url with the selected min and max prices
              // then load the new url

              var uri = decodeURIComponent(window.location.href.replace(/\+/g,  " "));
              var query;

              if (uri.indexOf("?")==-1){
                // url DOES NOT contain any querystring parameters
                // simply add new price range querystring parameter
                query = {
                  Nf: this.contentItemPricePropertyName + "|BTWN+" + this.currentMinValue + "+" + this.currentMaxValue
                };
              }
              else{
                // url DOES contain querystring parameters
                // keep existing querystring parameters AND
                // add (or replace) price range querystring
                query = dojo.queryToObject(uri.substring(uri.indexOf("?") + 1, uri.length));

                query.Nf = this.contentItemPricePropertyName + "|BTWN+" + this.currentMinValue + "+" + this.currentMaxValue;
              
                // remove existing querystring values from the url string
                uri = uri.substring(0, uri.indexOf("?"));
              }

              // append querystring parameters to the url
              uri += "?" + dojo.objectToQuery(query);

              // disable the price range widget to prevent
              // any further user interaction until the page
              // has been reloaded
              this.set('disabled', 'true');

              // about to reload page, so remove any existing event handlers
              this.deleteConnections;

              // reload the page
              window.location.href = uri;
            }
          },

          postCreate: function(){
            // postCreate on the superclass should be called automatically - but it isn't.
            // Perhaps an issue with how the required Dojo scripts are being pulled in.
            // Regardless, calling directly: 
            dojox.form.HorizontalRangeSlider.prototype.postCreate.apply(this, arguments);

          }
        }, this.sliderNode);

        // hook up event handlers
        this.slider.addConnections();

        this.updateOnScreenValues(this.slider.currentMinValue, this.slider.currentMaxValue);
    },

      updateOnScreenValues: function(newMinPrice, newMaxPrice){
      // NOTE: assuming min/max label text is currency symbol followed by number
      // or number followed by currency symbol. eg $120 or 120€ The regex below
      // replaces only the number part and decimal/comma formatting of the string
      // with selected value, leaving the currency symbol in its current position
                 
      // update the min and max values, removing all formatting but currency symbol
      var minWithCurrencySymbol = dojo.trim(this.minPriceNode.innerHTML.replace(/[\d\.,]+/,  newMinPrice));
      var maxWithCurrencySymbol = dojo.trim(this.maxPriceNode.innerHTML.replace(/[\d\.,]+/,  newMaxPrice));

      // update the on screen min and max labels
      this.minPriceNode.innerHTML = minWithCurrencySymbol + " "; // append a single space to handle an IE8 bug
      this.maxPriceNode.innerHTML = maxWithCurrencySymbol;

      // update the min handle, range bar and max hande tooltip text
      dojo.attr(this.slider.sliderHandle, "title", minWithCurrencySymbol);
      dojo.attr(this.slider.progressBar, "title", minWithCurrencySymbol + " - " + maxWithCurrencySymbol);
      dojo.attr(this.slider.sliderHandleMax, "title", maxWithCurrencySymbol);

    }
  })