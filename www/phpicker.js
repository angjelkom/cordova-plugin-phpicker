var exec = require('cordova/exec');

/**
 * This represents the device Locale, and provides properties for inspecting the region, language, preferredLanguages.
 * @constructor
 */
function PHPicker() {}

/**
 * Present PHPicker
 *
 */
 PHPicker.prototype.present = function () {
    return new Promise(function(resolve, reject){
        exec(resolve, reject, 'PHPicker', 'execute', []);
  });
};

module.exports = new PHPicker();