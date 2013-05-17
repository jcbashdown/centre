'use strict';

function QuestionsCtrl($scope, $routeParams, $http) {
  $http.get('/questions/1.json').success(function(data) {
    $scope.question = data;
  });
};
