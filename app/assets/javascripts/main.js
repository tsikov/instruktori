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
    url: "/?goto?page?city",
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

instruktori.controller("InstructorsIndexController", ["$scope", "$state", "$http", "Instructor", function($scope, $state, $http, Instructor) {

  // the params for quering instructors
  $scope.params = {
    // TODO: add some typeof "undefined"
    page: $state.params.page,
    city: $state.params.city
  };

  // we store ui related variables in here
  $scope.ui = {
    showCities: false,
  };

  // TODO: move in a service, because it makes on every controller initialization
  // cities are not yet collected from the server
  // this may very well never happen if the user
  // doesn't want to filter by city
  $scope.cities = [];

  $scope.instructorsData = Instructor.query($state.params);

  $scope.pageChanged = function(page) {
    $scope.params.page = page;
    $state.go("instructors", $scope.params);
  };

  $scope.getCities = function() {
    $scope.ui.showCities = !$scope.ui.showCities;

    // don't collect cities for the second time
    if ($scope.cities.length === 0) {
      $http.get("/api/v1/instructors/cities").
        success(function(data, status, headers, config) {
          $scope.cities = data;
        }).
        error(function(data, status, headers, config) {
          // TODO
        });
    }

  };

  $scope.selectCity = function(city) {
    $scope.ui.showCities = false;
    $scope.params.city = city;
    $state.go("instructors", $scope.params);
  };

}]);

instruktori.controller("InstructorsShowController", ["$scope", "$stateParams", "Instructor", "Result",
                       function($scope, $stateParams, Instructor, Result) {

  $scope.instructor = Instructor.get({ id: $stateParams.instructorId });
  $scope.resultsData = Result.query({ instructor_id: $stateParams.instructorId });

}]);


