/**
 * Javascript functions used to support Returns.
 * @ignore
 */
CRSMA = window.CRSMA || {};

/**
 * @namespace 
 *  "Stores" Javascript module of "Commerce Reference Store Mobile Application"
 * @description 
 *  Contains methods used in Return functionality 
 */
CRSMA.returns = function() {

  var $universalReasonSlct;  
  var $continueBtn;  
  var $returnAllCheckbox;  
  var $reasonSelects;  
  var $quantitySelects;
  
  /**
   * Checks if variables are not initted and inits them.
   * 
   * @public
   */
  var init = function() {
    $universalReasonSlct = $(".universalReasonSlct");
    $continueBtn = $("#continueBtn");
    $returnAllCheckbox = $("#selectAll");
    $reasonSelects = $(".reasonSlct");
    $quantitySelects = $(".quantitySlct");
    
    $returnAllCheckbox.change(onSelectAllChecked);
    $reasonSelects.change(checkSelectsData);
    $quantitySelects.change(checkSelectsData);
    $universalReasonSlct.change(onSelectAllChanged);
    checkSelectsData();
  };
  
  /**
   * Sets max value for quantity selects
   * 
   * @private
   */  
  var selectQuantityMaxValues = function() {
    $quantitySelects.each(function() {
      $(this).children('option:last-child').attr('selected', 'true');
    });
  };
  
  /**
   * Sets initial values for reason selects
   * 
   * @private
   */
  var selectReasonInitialValues = function() {
    $reasonSelects.each(function() {
      $(this).children('option:first-child').attr('selected', 'true');
    });
    $universalReasonSlct.children('option:first-child').attr('selected', 'true');
  };
  
  /**
   * Sets param value for all reason selects
   * 
   * @param
   *  selectedOptionValue - option value for selecting
   * @private
   */
  var selectReasonSetValues = function(selectedOptionValue) {
    $reasonSelects.each(function() {
      $(this).children("option[value=" + selectedOptionValue + "]").attr('selected', 'true');
    });
  };
  
  /**
   * Sets initial values for quantity selects
   * 
   * @private
   */
  var selectQuantityInitialValues = function() {
    $quantitySelects.each(function() {
      $(this).children('option:first-child').attr('selected', 'true');
    });
  };

  /**
   * Check if select has selected value
   * 
   * @private
   * @param
   *  obj - select to check
   */
  var isSelected = function(obj) {
    return !($(obj).children('option:first-child').attr('selected'));
  };

  /**
   * Checks all selects for correct data
   * For each return item quantity select and reason select 
   * should be both selected or unselected 
   * 
   * @private
   */
  var checkSelectsData = function() {
    var brokenPairExists = false;
    var checkedPairExists = false;
    $reasonSelects.each(function() {
      var isReasonSelected = isSelected(this);
      /* if both are in one state (selected or not) */
      if ( isReasonSelected !== isSelected($(this).siblings(".quantitySlct")) ) {
        brokenPairExists = true;
      }
      if (isReasonSelected) {checkedPairExists = true};
    });
    if (!brokenPairExists && checkedPairExists) {
      $continueBtn.removeAttr('disabled');
    } else {
      $continueBtn.attr("disabled", "disabled");
    }
  };

  /**
   * Checks states after every change and makes
   * changes in layout
   * 
   * @private
   */
  var onSelectAllChecked = function() {
    if ($(this).attr('checked') === 'checked') {
      $universalReasonSlct.removeClass("hidden");
      $reasonSelects.attr("disabled", "disabled");
      $quantitySelects.attr("disabled", "disabled");
      selectReasonInitialValues();
      selectQuantityMaxValues();
      if (!isSelected($universalReasonSlct)) {$continueBtn.attr("disabled", "disabled");};
    } else {
      selectQuantityInitialValues();
      selectReasonInitialValues();
      $universalReasonSlct.addClass("hidden");
      $reasonSelects.removeAttr('disabled');
      $quantitySelects.removeAttr('disabled');
      $continueBtn.attr("disabled", "disabled");
    }
  };

  /**
   * Checks states after UniversalReasonSelect changed and
   * changes in layout
   * 
   * @private
   */
  var onSelectAllChanged = function() {
    if ($returnAllCheckbox.attr('checked') === 'checked' && isSelected(this)) {
      $continueBtn.removeAttr('disabled');
      var selectedOptionValue = $(this).children('option:selected').attr("value");
      selectReasonSetValues(selectedOptionValue);
    } else {
      selectReasonInitialValues();
      $continueBtn.attr("disabled", "disabled");
    }
  };
  
  /**
   * List of public "CRSMA.returns" methods
   */
  return {
    // methods
    "init"                : init
  }
}();
