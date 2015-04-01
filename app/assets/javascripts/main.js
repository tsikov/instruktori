instruktori = angular.module("instruktori", ["ngResource", "ui.router", "templates", "ui.bootstrap"]);

instruktori.config(["$stateProvider", "$urlRouterProvider", "$locationProvider",
                   function($stateProvider, $urlRouterProvider, $locationProvider) {

  $stateProvider
  .state("instructors", {
    url: "/",
    templateUrl: "instructors.html",
    controller: "InstructorsIndexController"
  })
  .state("instructor", {
    url: "/instructors/:instructorId",
    templateUrl: "instructor.html",
    controller: "InstructorsShowController"
  });

  // default fall back route
  $urlRouterProvider.otherwise('/');

  // enable HTML5 Mode for SEO
  $locationProvider.html5Mode({
    enabled: true,
    requireBase: false
  });

}]);

instruktori.factory("Instructor", ["$resource", function($resource) {
  return $resource('/api/v1/instructors/:id', null, {
    'query': {
      method: "GET",
      isArray: false,
    }
  });
}]);

instruktori.controller("InstructorsIndexController", ["$scope", "Instructor", function($scope, Instructor) {

  $scope.instructorsData = Instructor.query();

  $scope.pageChanged = function() {
    $scope.instructorsData = Instructor.query({ page: $scope.instructorsData.page });
  };

}]);

instruktori.controller("InstructorsShowController", ["$scope", "$stateParams", "Instructor",
                       function($scope, $stateParams, Instructor) {

  $scope.instructor = Instructor.get({ id: $stateParams.instructorId });

}]);


