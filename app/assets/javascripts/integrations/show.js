(function() {
  'use strict';

  angular
    .module('app.integrations')
    .controller('show', show);

  function show(dataservice, $routeParams, services_list) {
    var vm = this;

    vm.services_list = services_list;
    vm.integration = {};

    activate();

    //////////////////

    function activate() {
      getIntegration();
    }

    function getIntegration() {
      dataservice.getIntegration($routeParams.integrationId).then(success);

      function success(integration) {
        vm.integration = integration;
      }
    }

  }
})();