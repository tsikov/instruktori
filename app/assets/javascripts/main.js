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
    url: "/?goto?page",
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
      var d3 = $window.d3;
      var rawSvg = element.find("svg")[0];
      var svg = d3.select(rawSvg);

      function render(data) {
        var margin = 2;
        var resultsPerRow = 10;
        var tip = d3.tip()
          .attr('class', 'd3-tip')
          .offset([-10, 0])
          .html(function(d) {
            return "<strong>Frequency:</strong> <span style='color:red'>" + d.student_name + "</span>";
          });

        svg.call(tip);

        svg.selectAll('rect')
        .data(data).enter()
          .append('rect')
          .attr({
            height: 10,
            width: 10,
            x: function(d, i) { return (i * 12) % (resultsPerRow * 12); },
            y: function(d, i) { return i === 0 ? 0 : Math.floor(i/resultsPerRow)*12; },
            fill: function(d) { return d.result === 0 ? "green" : "red"; }
          })
          .on("mouseover", tip.show)
          .on("mouseout", tip.hide);
      };

      scope.resultsData.$promise.then(function(data) {
        render(data.results);
      });

    }
  }
}]);

instruktori.controller("InstructorsIndexController", ["$scope", "$state", "Instructor", function($scope, $state, Instructor) {

  $scope.params = {
    page: $state.params.page,
    city: "all"
  }

  $scope.instructorsData = Instructor.query({ page: $state.params.page });
  $scope.pageChanged = function(page) {
    $scope.params.page = page;
    $state.go("instructors", $scope.params);
  };

  $scope.cityChanged = function(city) {
    $scope.params.city = city;
    $state.go("instructors", $scope.params);
  }

}]);

instruktori.controller("InstructorsShowController", ["$scope", "$stateParams", "Instructor", "Result",
                       function($scope, $stateParams, Instructor, Result) {

  $scope.instructor = Instructor.get({ id: $stateParams.instructorId });
  $scope.resultsData = Result.query({ instructor_id: $stateParams.instructorId });

}]);


