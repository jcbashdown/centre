angular.module('centre', []).
  config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/questions/:questionId', {templateUrl: '/questions/1', controller: QuestionsCtrl}).
    otherwise({redirectTo: '/'});
  }]);
