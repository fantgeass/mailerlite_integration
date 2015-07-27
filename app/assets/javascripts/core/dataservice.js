(function() {
  'use strict';

  angular
    .module('app.core')
    .factory('dataservice', dataservice);

  function dataservice(Restangular) {
    return {
      getIntegrations: getIntegrations,
      getIntegration: getIntegration,
      getLists: getLists,
      createIntegration: createIntegration,
      updateIntegration: updateIntegration,
      deleteIntegration: deleteIntegration
    };

    function getIntegrations() {
      return Restangular.all('integrations').getList();
    }

    function getIntegration(integrationId) {
      return Restangular.one('integrations', integrationId).get();
    }

    function getLists(service, api_key) {
      return Restangular.all('integrations/lists/' + service).getList({api_key: api_key});
    }

    function createIntegration(integration) {
      return Restangular.all('integrations').post(integration);
    }

    function updateIntegration(integration) {
      return Restangular.one('integrations', integration.id).put(integration);
    }

    function deleteIntegration(integration) {
      return Restangular.one('integrations', integration.id).remove();
    }
  }

})();