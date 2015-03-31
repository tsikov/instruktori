instruktori = angular.module("instruktori", ["ngResource", "ui.router", "templates", "ui.bootstrap"]);

instruktori.config(["$stateProvider", "$urlRouterProvider", "$locationProvider",
                   function($stateProvider, $urlRouterProvider, $locationProvider) {

  $stateProvider.
  state("instructors", {
    url: "/",
    templateUrl: "instructors.html",
    controller: "InstructorsController"
  });

  // default fall back route
  $urlRouterProvider.otherwise('/');

  // enable HTML5 Mode for SEO
  $locationProvider.html5Mode({
    enabled: true,
    requireBase: false
  });

}]);

instruktori.factory("Instructors", ["$resource", function($resource) {
  return $resource('/api/v1/instructors/:id', null, {
    'query': {
      method: "GET",
      isArray: false,

      transformResponse: function(data) {
        data = JSON.parse(data);

        data.instructors = data.instructors.map(function(i) {
          return {
            id: i.id,
            name: i.name
          }
        });

        return data;
      }
    }
  });
}]);

instruktori.controller("InstructorsController", ["$scope", "Instructors", function($scope, Instructors) {

  $scope.instructorsData = Instructors.query();

  $scope.pageChanged = function() {
    $scope.instructorsData = Instructors.query({ page: $scope.instructorsData.page });
  };

}]);


