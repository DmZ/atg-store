/**
 * I18n Javascript functions.
 * @ignore
 */
CRSMA = window.CRSMA || {};

/**
 * @namespace "Internationalization" module of "Commerce Reference Store Mobile Application"
 * @description Holds methods for handling of string resources on different languages.   
 */
CRSMA.i18n = function() {
  /**
   * Map for localization messages.
   *
   * @private
   */
  var messages = {};

  /**
   * Returns registered message by key.
   * If there are no such message key is returned.
   *
   * @example
   * CRSMA.i18n.getMessage('agent007'); // My name is {1}, {0} {1}
   * CRSMA.i18n.getMessage('agent007', 'James', 'Bond'); // 'My name is Bond, James Bond'
   *
   * @param {string} key
   *  key.
   * @return {string} 
   *  localized message.
   *  
   * @public
   */
  var getMessage = function(key) {
    var message = messages[key];
    if (!message) {
      return key;
    }
    if (arguments.length > 1) {
      message = message.format(Array.prototype.slice.call(arguments, 1));
    }
    return message;
  };

  /**
   * Registers localized message with specified key.
   *
   * @param data
   *  object with messages('key' : 'value').
   *  
   * @public
   */
  var register = function(data) {
    for (var key in data) {
      if (data.hasOwnProperty(key)) {
        messages[key] = data[key];
      }
    }
  };

  return {
    // methods
    'getMessage' : getMessage,
    'register'   : register
  }
}();
