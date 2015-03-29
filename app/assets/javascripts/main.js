instruktori = angular.module("instruktori", ["ngResource", "ui.router", "templates"]);

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
  });
}]);

instruktori.controller("InstructorsController", ["$scope", "Instructors", function($scope, Instructors) {

  $scope.instructors = Instructors.query();

}]);


