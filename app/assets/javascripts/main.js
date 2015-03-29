instruktori = angular.module("instruktori", ["ui.router", "templates"]);

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

//instruktori.factory("Instructor", ["$resource", function($resource) {
  //return $resource('/api/v1/instructors/:id', null, {
    //"query": {
      //method: "GET",
      //isArray: false,

      //transformResponse: function(data) {
        //data = JSON.parse(data);

        //data.comments = data.comments.map(function(c) {
          //return {
            //id: c.id,
          //}
        //});

        //return data;
      //}
    //},
  //});
//}]);

instruktori.controller("InstructorsController", ["$scope", function($scope) {

  $scope.test = "dsdasd";

}]);
