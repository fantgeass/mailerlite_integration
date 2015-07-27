(function() {
  'use strict';

  angular.module('app.integrations').config(routes);

  routes.$inject = ['$routeProvider'];

  function routes($routeProvider) {
    return $routeProvider.when('/', {
      templateUrl: "index.html",
      controller: "index",
      controllerAs: 'vm'
    }).when('/integrations/new', {
      templateUrl: "form.html",
      controller: "create",
      controllerAs: 'vm'
    }).when('/integrations/:integrationId/edit', {
      templateUrl: "form.html",
      controller: "edit",
      controllerAs: 'vm'
    }).when('/integrations/:integrationId', {
      templateUrl: "show.html",
      controller: "show",
      controllerAs: 'vm'
    }).otherwise({
      redirectTo: '/'
    })
  };

})();