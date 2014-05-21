/**
 * Javascript functions used in productsHorizontaList.jsp.
 * @ignore
 */
CRSMA = window.CRSMA || {};

/**
 * @namespace 
 *  "Products Horizontal List" Javascript module of "Commerce Reference Store Mobile Application"
 * @description 
 *  Contains methods used in productsHorizontaList.jsp.   
 */
CRSMA.horizontallist = function() {
  /**
   *  This method initializes the sliders in productsHorizontalList.jsp.
   *  
   *  @public
   */
  var initHorizontalListSliders = function() {
    // Set the width of itemContainer to the width of the entire screen. The slider will then takes care
    // of figuring out the appropriate width for the cells inside it
    var doItemsExist = $(".itemsContainer").length > 0;
    if (doItemsExist) {
      var screenWidth = $(window).width() - 1;
      $(".itemsContainer").css({
        "width": screenWidth
      });
    }

    // Initialize all sliders on the page
    $("div[id^='horizontalContainer']").each(function(){
      var id = $(this).attr("id");
      var numberOfCells = 3;
      CRSMA.sliders.createSlider({
        gridid: "#" + id,
        numberOfCells: numberOfCells,
        onTouchEventException: function(el) {
          $(el).css({
            "height": "70px",
            "overflow": "auto"
          });
        }
      });
      
      // Mark items that are off screen as hidden so that VoiceOver won't read them (accessibility)
      var $cells = $(this).children(".cell");
      $cells.each(function(index) {
        if (index >= numberOfCells) {
          $(this).css({
            display: "none"
          });
        }
      });
    });

    // Now that the slider has been initialized, let itemContainer inherits its parent's width. 
    // This will let the browser figure out the right value when the user switches between portrait 
    // and landscape views
    if (doItemsExist) {
      $(".itemsContainer").css({
        "width": "inherit"
      });
    }
  };

  /**
   * List of public "CRSMA.horizontallist" methods
   */
  return {
    // methods
    'initHorizontalListSliders' : initHorizontalListSliders
  }
}();
