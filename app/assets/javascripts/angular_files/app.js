'use strict';

angular.module('centre', ["ngResource"]).
  config(['$routeProvider', function($routeProvider) {
  $routeProvider.
//this isn't loading, so controller directive no on page, so controller no called. 
//undefined because not matching id
    //alert($routeProvider);
    when('/questions/:questionId', {templateUrl: '/assets/angular_files/templates/argument.html', controller: QuestionsCtrl}).
    otherwise({redirectTo: '/'});
  }]);


