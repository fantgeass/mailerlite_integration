(function() {
  'use strict';

  angular
    .module('app.integrations')
    .controller('index', index);

  function index(dataservice, services_list, Flash) {
    var vm = this;

    vm.services_list = services_list;
    vm.remove = remove;
    vm.integrations = [];

    activate();

    //////////

    function activate() {
      vm.integrations = dataservice.getIntegrations().$object;
    }

    function remove(integration) {
      if (confirm("Are you sure want to delete this integration?")) {
        dataservice.deleteIntegration(integration);
        Flash.create('danger', 'Integration has been deleted!');
      }
    }

  }
})();