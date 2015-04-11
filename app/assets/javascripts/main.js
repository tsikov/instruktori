instruktori = angular.module("instruktori", ["ngResource", "ui.router", "templates", "ui.bootstrap"]);

instruktori.run(["$rootScope", "$location", function($rootScope, $location) {

  $rootScope.$on('$stateChangeStart', function(e, toState, toParams, fromState, fromParams) {
    if (typeof toParams.goto !== "undefined") {
      $location.url(toParams.goto);
    }
    return;
  });

}]);

instruktori.config(["$stateProvider", "$urlRouterProvider", "$locationProvider",
                   function($stateProvider, $urlRouterProvider, $locationProvider) {

  $stateProvider
  .state("instructors", {
    url: "/?goto",
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
    enabled: true
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

instruktori.factory("Result", ["$resource", function($resource) {
  return $resource('/api/v1/results/:id', null, {
    'query': {
      method: "GET",
      isArray: false,
    }
  });
}]);

instruktori.directive("resultsList", ["$window", "Result", "$stateParams", function($window, Result, $stateParams) {
  return {
    restrict: "E",
    template: "<svg width='850' height='200'></svg>",
    scope: {
      resultsData: "="
    },
    link: function(scope, element, attrs) {

      var width = parseInt(attrs.width) || 400,
          height = parseInt(attrs.barHeight) || 400,
          margin = parseInt(attrs.margin) || 2;
      var d3 = $window.d3;
      var rawSvg = element.find("svg")[0];
      var svg = d3.select(rawSvg);

      function render(data) {
        svg.selectAll('rect')
        .data(data).enter()
          .append('rect')
          .attr({
            height: 10,
            width: 10,
            x: 0,
            y: function(d, i) {
              return i * (10 + margin);
            },
            fill: function(d) {
              if(d.result === 0) {
                return "green";
              } else {
                return "red";
              }
            }
          });
      };

      scope.resultsData.$promise.then(function(data) {
        render(data.results)
      });

    }
  }
}]);

instruktori.controller("InstructorsIndexController", ["$scope", "Instructor", function($scope, Instructor) {

  $scope.instructorsData = Instructor.query();
  $scope.pageChanged = function() {
    $scope.instructorsData = Instructor.query({ page: $scope.instructorsData.page });
  };

}]);

instruktori.controller("InstructorsShowController", ["$scope", "$stateParams", "Instructor", "Result",
                       function($scope, $stateParams, Instructor, Result) {

  $scope.instructor = Instructor.get({ id: $stateParams.instructorId });
  $scope.resultsData = Result.query({ instructor_id: $stateParams.instructorId });

}]);


