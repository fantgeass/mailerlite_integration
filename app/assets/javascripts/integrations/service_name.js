(function() {
  'use strict';

  angular
    .module('app.integrations')
    .filter('service_name', service_name);

  function service_name(services_list) {
    return function(input) {
      if (input) {
        var service = _.find(services_list, function(service){
          return service.id == input;
        });


        return service.name;
      }
    };
  }
})();