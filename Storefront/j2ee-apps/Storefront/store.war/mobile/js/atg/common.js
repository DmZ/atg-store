/**
 * Common Javascript functions.
 * @ignore
 */
CRSMA = window.CRSMA || {};

/**
 * @namespace "Common" Javascript Module of "Commerce Reference Store Mobile Application"
 * @description Holds common functionality related to all parts in CRSMA.
 */
CRSMA.common = function() {
  /**
   * Shows or hides html element with 'modalOverlay' id.
   *
   * @param {boolean} showOrHide 
   *  a flag indicating whether to show (true) or hide (false).
   *  
   * @public
   */
  var toggleModal = function(showOrHide) {
    $("#modalOverlay").toggle(showOrHide);
    // If hiding the modal overlay, also hide all direct children
    if (showOrHide == false) {
      $("#modalOverlay > :not(.shadow)").hide();
    }
  };

  /**
   * For every element, catched by selector, adds click handler
   * that makes submit of form after some delay.<br>
   * Called when user clicks on any list item, except border & action ones.
   *
   * @param {string} selectorText 
   *  jquery selector rule.
   * @param {number} pDelay 
   *  Timeout in msec before submitting form (default - 200ms).
   *  
   * @public
   */
  var delayedSubmitSetup = function(selectorText, pDelay) {
    var pDelay = (typeof pDelay === "undefined") ? 200 : pDelay;

    $(selectorText).each(function() {
      var $container = $(this);

      $("li", $container).not("#newItemLI").click(function(event) {
        var target = event.target || event.srcElement;
        if (target.localName === "a") {
          return;
        }

        var $radio = $("input:radio", $(this));
        $radio.attr("checked", "checked");
        $radio.change();

        setTimeout(function() {
          $container.parents("form").submit();
        }, pDelay);
      });
    });
  };

  /**
   * Goes to specified url with delay 500 ms.
   *
   * @param {string} url 
   *  URL.
   *  
   * @returns {boolean} 
   *  always returns true.
   *  
   * @public
   */
  var gotoURL = function(url) {
    setTimeout(
      function() {
        window.location.href = url;
      },
      500);
    return true;
  };

  /**
   * Parses the specified URL or current page URL (if URL is undefined)
   * and returns a dictionary Object that maps decoded parameter names to decoded values.
   *
   * @param {string} url 
   *  the specified URL with params to map.
   *  
   * @return An object with keys and values where keys are the parameter names from the URL.
   * 
   * @public
   */
  var getURLParams = function(url) {
    if (!url) {
      url = window.location.href;
    }

    var params = decodeURI(url);
    var indexOfQuestionMark = params.indexOf('?');
    if (indexOfQuestionMark !== -1) { // if this is whole url, not search part
      params = params.slice(indexOfQuestionMark);
    }

    // A state machine to parse the param string in one pass
    var state = false;
    var key = '';
    var value = '';
    var paramsObject = {};
    // The first character will always be '?', so we skip it
    for (var i = 1; i < params.length; i++) {
      var current = params.charAt(i);
      switch (current) {
        case '=':
          state = !state;
          break;
        case '&':
          state = !state;
          paramsObject[key] = value;
          key = value = '';
          break;
        default:
          if (state) {
            value += current;
          } else {
            key += current;
          }
          break;
      }
    }
    if (key) {
      paramsObject[key] = value; // put the last pair on the "paramsObject"
    }
    return paramsObject;
  };

  /**
   * Hides the "Loading..." message box.
   * 
   * @public
   */
  var hideLoadingWindow = function() {
    $("#modalMessageBox").hide().removeClass("refineOverlay");
    CRSMA.common.toggleModal(false);
  };

  /**
   * Shows modal dialog to confirm delete operation.<br>
   * The dialog position is calculated based on this container element.
   *
   * @param pOffsetContainer 
   *  Container with delete link, clicking on it shows modal dialog.
   *  
   * @public
   */
  var removeItemDialog = function(pOffsetContainer) {
    var $offsetContainer = $(pOffsetContainer);
    var top = $offsetContainer.offset().top - $("#pageContainer").offset().top;
    var right = $(document).width() - $offsetContainer.offset().left - $offsetContainer.outerWidth() - 1; // -1px for the left border

    $("div.moveDialog div.moveItems").css({top: top, right: right, display: "block"});

    // Hide dialog by clicking outside the dialog items box
    $("div.moveDialog").click(function() {
      $(this).hide();
    });

    $("div.moveDialog").show();
    CRSMA.common.toggleModal(true);
  };
  
  /**
   * List of public "CRSMA.common" 
   */
  return {
    // methods
    'delayedSubmitSetup': delayedSubmitSetup,
    'getURLParams'      : getURLParams,
    'gotoURL'           : gotoURL,
    'removeItemDialog'  : removeItemDialog,
    'toggleModal'       : toggleModal,
    'hideLoadingWindow' : hideLoadingWindow
  }
}();


$(window).one("load", function() {
  window.scrollTo(0, 1);
  history.replaceState(new Date());
});

/**
 * Javascript Global Objects extensions.
 */
(function() {
  /**
   * Formats string, replacing parameters {0} {1} etc. by arguments in the specified order. <br>
   * May be used with different quantity of arguments.
   *
   * @example
   * var s = 'May name is {0} {1}';
   * s.format('John', 'Smith'); // My name is John Smith
   */
  String.prototype.format = function() {
    var formatted = ""; // this will be our formatted string
    var split = this.split('');
    var inParam = false; // state variable
    var paramNumber = '';
    for (var i = 0; i < split.length; i++) {
      var current = split[i];
      switch (current) {
        case '{': // begin specifying a parameter
          inParam = true;
          break;
        case '}': // done specifying parameter
          inParam = false;
          // Insert the parameter or, if it doesn't exist, leave it as it is
          var param = arguments[parseInt(paramNumber, 10)] || "{" + paramNumber + "}";
          formatted += param; // Insert the parameter into the formatted string
          paramNumber = ""; // make sure to reset the paramNumber
          break;
        default:
          if (inParam) {
            paramNumber += current;
          } else {
            formatted += current;
          }
          break;
      }
    }
    return formatted;
  };

  /**
   * This adds a setObject method to the Storage interface so that we can add our
   * HTML fragments into local storage. <br>
   *
   * We should be able to do this without doing this, according to the
   * localstorage spec, but no browser has added support for it yet.
   *
   * @param {string} key 
   *  key
   * @param value 
   *  any object
   *  
   * @memberOf Storage
   * 
   * @namespace
   */
  Storage.prototype.setObject = function(key, value) {
    this.setItem(key, JSON.stringify(value));
  };

  /**
   * This adds a getObject method to the Storage interface so that we can get our
   * HTML fragments out of local storage. <br>
   *
   * We should be able to do this without doing this, according to the
   * localstorage spec, but no browser has added support for it yet.
   *
   * @param {string} key 
   *  key
   *  
   * @memberOf Storage
   * 
   * @namespace
   */
  Storage.prototype.getObject = function(key) {
    return this.getItem(key) && JSON.parse(this.getItem(key));
  };
})();
