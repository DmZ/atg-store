/**
 * Javascript functions used in the mobile page template (mobile page cartridge, page header, and page footer).
 * @ignore
 */
CRSMA = window.CRSMA || {};

/**
 * @namespace 
 *  "Mobile Page Template" Javascript module of "Commerce Reference Store Mobile Application"
 * @description 
 *  Contains methods used in the mobile page template (mobile page cartridge, page header, and page footer).   
 */
CRSMA.mobilepage = function() {
  /**
   * Array of possible search bar states.
   * @private
   */
  var states = [];

  /**
   * Zero-based index of active state.
   * @private
   */
  var activeStateIndex;

  /**
   * Links to jquery selector results for perfomance.
   * @private
   */
  var $blockTitle, $blockNavigation;

  /**
   * Hides popup.
   * @public
   */
  var hidePopup = function() {
    $("#messagePopup").addClass("hidden");
  };

  /**
   * Shows 'Contact Us' page.
   *
   * @return {boolean} 
   *  always returns false.
   *
   * @public
   */
  var showContactUsPage = function() {
    var $contactInfo = $("#contactInfo").show();
    CRSMA.common.toggleModal(true);
    return false;
  };

  /**
   * Refreshes search bar titles according to the new state index.
   *
   * @param {integer} stateIndex
   *  New state index.
   *
   * @private
   */
  var adjustStateTo = function(stateIndex) {
    if (typeof activeStateIndex !== "undefined") {
      $('#' + states[activeStateIndex].id).hide();
    }

    var state = states[stateIndex];
    $blockTitle.html(state.buttonTitle);
    $blockNavigation.html(state.buttonNavigation);
    $('#' + state.id).show();

    activeStateIndex = stateIndex;
  };

  /**
   * Registers possible search bar states in the internal var.
   *
   * @param pStates 
   *  Array of second states (see usage in code).
   *  
   * @private
   */
  var registerStates = function(pStates) {
    states = pStates;

    for (var i = 0; i < states.length; i++) {
      if (states[i].active) {
        adjustStateTo(i);
        return;
      }
    }
  };
  
  /**
   * Recalculates activeStateIndex and adjusts search bar.
   * 
   * @public
   */
  var toggleSections = function() {
    adjustStateTo(activeStateIndex == 0 ? 1 : 0);
    $("#switchBar").toggleClass("refine");
  };
  
  /**
   * Initializes Endeca "MobilePage" cartridge renderer.
   * Creates bar with 2 blocks:
   * the 1-st one contains information about visible content,
   * the 2-nd one hides active content and shows the next content.
   * 
   * @public
   */
  var initMobilePage = function() {
    $blockTitle = $("<button role='rowheader'></button>");
    $blockNavigation = $('<a href="javascript:void(0)" onclick="CRSMA.mobilepage.toggleSections()"></a>');

    $("#switchBar")
      .addClass("switchBar")
      .append($blockTitle)
      .append($("<button role='button'>").append($blockNavigation))
      .append('<span class="dividerBar"/>');

    var params = CRSMA.common.getURLParams();
    var isRefinementRequest = (params["nav"] != null);
    var isBrowseOrBrandRequest = (params["Ntt"] == null);

    // The "div.searchResults" (the "Results List" cartridge) is NOT present in BLP and in CLP content
    var resultsListCount = -1;
    var searchResults = $("div.searchResults");
    if (searchResults.length > 0) {
      resultsListCount = searchResults[0].dataset["resultsListCount"];
    }

    var navGroupsCount = 0;
    var guidedNav = $("div.guidedNavigation");
    var guidedNavExists = (guidedNav.length > 0);
    if (guidedNavExists) {
      navGroupsCount = guidedNav[0].dataset["navigationGroupsCount"];
    }

    var isMainActive = !isRefinementRequest || (navGroupsCount == 0);
    registerStates([{
      // ResultList
      id: "main",
      buttonTitle: (isBrowseOrBrandRequest ? getCategoryOrBrandName() : getSearchTerm()),
      buttonNavigation: CRSMA.i18n.getMessage("mobile.js.search.refine"),
      active: isMainActive
    },{
      // Breadcrumbs, GuidedNavigation
      id: "secondary",
      buttonTitle: (guidedNavExists ? (isBrowseOrBrandRequest ? CRSMA.i18n.getMessage("mobile.js.search.shop.by") : CRSMA.i18n.getMessage("mobile.js.search.refine.by")) : ""),
      buttonNavigation: CRSMA.i18n.getMessage("mobile.js.common.done"),
      active: !isMainActive
    }]);
    $("#switchBar").toggleClass("refine", isRefinementRequest);
    
    // check if further subcategories exist among refinements
    var areCategoryRefinements = $('div.refinementFacetGroupContainer[data-is-category="true"]').length > 0;
    
    // Show popup with "No search results" info 
    // if we are on the refinement's page and there are no search results.
    // Note, that we also check if are category facets for further refinements:
    // It's for situation when user selects Root-category, that hasn't any products, but has subcategories, that have own products."
    if (activeStateIndex == 1 /* secondary*/ && !areCategoryRefinements && resultsListCount == 0) {
      $('#noSearchResultsPopup').show();
      CRSMA.common.toggleModal(true);
    }
  };
  
  /**
   * Returns search term
   * 
   * @private
   */
  var getSearchTerm = function() {
    var escapedTerm = CRSMA.common.getURLParams()["Ntt"];
    var unescapedTerm = "";
    if (escapedTerm) {
      unescapedTerm = '\"' + unescape(escapedTerm.replace(/\+/g, " ")) + '\"';
    }
    return unescapedTerm;
  };
  
  /**
   * Returns selected category on CategoryBrowse page.
   * 
   * @private
   */
  var getCategoryOrBrandName = function() {
    //Try to get Category name
    var categoriesAndSubcategories = $('#product_category .crumbContent .crumbContentText span');
    var lastItemIndex = categoriesAndSubcategories.length - 1;
    //If there are no any Categories - try to get Brand name
    if (lastItemIndex == -1 ) {
      categoriesAndSubcategories = $('#product_brand .crumbContent .crumbContentText span');
      lastItemIndex = categoriesAndSubcategories.length - 1;
    }
    //If still have no smth. to show - return empty string 
    return lastItemIndex != -1 ? categoriesAndSubcategories[lastItemIndex].innerHTML : "";
  };
  
  /**
   * Saves count of items in cart and timestamp for the history.back() handling.
   * 
   * @private
   */
  var saveBadgeData = function(pNewCount) {
    localStorage.setObject("badgeCount", pNewCount);
    localStorage.setObject("badgeTs", new Date());
  }

  /**
   * Takes count of items in cart and call saveBadgeData()
   * 
   * @public
   */
  var saveCartItems = function() {
    var currentBadgeData = $("#cartBadge")[0].innerText;
    saveBadgeData(parseInt(currentBadgeData));
  }
  
  /**
   * Checks if cart items count or cart content changed
   * and refreshes page if necessary.
   * 
   * @public
   */
  var refreshCartDataIfExpired = function(renderTs) {
    if (renderTs) {
      var currentBadgeData = $("#cartBadge")[0].innerText;
      var lsBadgeData = localStorage.getObject("badgeCount");
      var lsBadgeTs = new Date(localStorage.getObject("badgeTs"));

      if (renderTs < lsBadgeTs) {
        var isCartPageOpened = !!$(".cartContainer").length;
        if (isCartPageOpened) {
          location.reload();
        } else {
          refreshCartBadge(lsBadgeData);
        }
      }
    }
  };
  
  /**
   * Chain together multiple animations.<br>
   * Usage: chainAnimations([function, duration],...);
   * 
   * @private
   */
  var chainAnimations = function() {
    var args = Array.prototype.slice.call(arguments);
    var f = args.shift();
    var delay = args.shift();
    var tail = args;
    var callee = arguments.callee;
    if (f) {
      f();
      if (delay) {
        setTimeout(function() {callee.apply(this, tail);}, delay);
      }
    }
  };
  
  /**
   * Refreshes badge count on shopping cart.
   *
   * @param {number} pNewCount
   *  New count.
   *  
   * @see {@link chainAnimations}
   * 
   * @public
   */
  var refreshCartBadge = function(pNewCount) {
    if (pNewCount > 0) {
      var $cartBadge = $("#cartBadge");
      $cartBadge.show(); // in case it's currently hidden
      chainAnimations(
        function(){$cartBadge.toggleClass("highlight").toggleClass("textFade");}, 500,
        function(){$cartBadge.text(pNewCount).toggleClass("textFade");}, 900,
        function(){$cartBadge.toggleClass("highlight")}
      );
    }
    saveBadgeData(pNewCount);
  };

  /**
   * List of public "CRSMA.mobilepage" methods
   */
  return {
    // methods
    'initMobilePage'    : initMobilePage,
    'hidePopup'         : hidePopup,
    'showContactUsPage' : showContactUsPage,
    'refreshCartDataIfExpired' : refreshCartDataIfExpired,
    'refreshCartBadge'  : refreshCartBadge,
    'saveCartItems'     : saveCartItems,
    'toggleSections'    : toggleSections
  }
}();

/* Handling history.back added */
window.onpopstate = function(event) {
  CRSMA.mobilepage.refreshCartDataIfExpired(event.state);
};
