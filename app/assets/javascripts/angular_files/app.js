'use strict';

angular.module('centre', []).
  config(['$locationProvider', function($locationProvider) {    
    $locationProvider.html5Mode(true);  
  }]).
  config(['$routeProvider', function($routeProvider) {
    $routeProvider.
      when('/questions/:questionId', {templateUrl: '/assets/angular_files/templates/argument.html', controller: QuestionsCtrl})
  }]);


