angular.module('centre', []).
  config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/questions/:questionId', {templateUrl: '/assets/angular_files/templates/argument.html', controller: QuestionsCtrl}).
    otherwise({redirectTo: '/'});
  }]);
