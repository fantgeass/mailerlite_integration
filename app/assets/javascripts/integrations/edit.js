(function() {
  'use strict';

  angular
    .module('app.integrations')
    .controller('edit', edit);

  function edit(dataservice, $routeParams, services_list, Flash) {
    var vm = this;

    vm.services_list = services_list;
    vm.integration = {};
    vm.lists = [];

    vm.save = save;
    vm.setListName = setListName;
    vm.uploadLists = uploadLists;

    activate();

    //////////////////


    function activate() {
      getIntegration();
    }

    function setListName(name) {
      vm.integration.list_name = name;
    }


    function uploadLists() {
      dataservice.getLists(vm.integration.service, vm.integration.api_key).then(success, fail);

      function success(lists) {
        vm.lists = lists;
        clearList();
        Flash.create('success', 'Lists uploaded!');
      }

      function fail() {
        vm.lists = [];
        clearList();
        Flash.create('danger', "Can't upload lists: wrong API KEY");
      }
    }

    function clearList() {
      vm.integration.list_id = '';
      vm.integration.list_name = '';
    }



    function getIntegration() {
      dataservice.getIntegration($routeParams.integrationId).then(success);

      function success(integration) {
        vm.integration = integration;
        vm.lists = dataservice.getLists(vm.integration.service, vm.integration.api_key).$object
      }
    }

    function save() {
      dataservice.updateIntegration(vm.integration);
      Flash.create('success', 'Integration has been updated!');
    }
  }
})();