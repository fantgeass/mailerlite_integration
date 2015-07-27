(function() {
  'use strict';

  angular
    .module('app.integrations')
    .controller('create', create);

  function create(dataservice, services_list, $location, Flash) {
    var vm = this;

    vm.lists = [];
    vm.services_list = services_list;
    vm.uploadLists = uploadLists;
    vm.save = save;
    vm.setListName = setListName;

    vm.integration = {
      service: '',
      api_key: '',
      list_id: '',
      list_name: ''
    };

    activate();

    ///////

    function activate() {

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

    function save() {
      dataservice.createIntegration(vm.integration).then(success, fail);

      function success() {
        Flash.create('success', 'Integration has been created!');
        $location.path('/integrations');
      }

      function fail() {

      }
    }
  }
})();