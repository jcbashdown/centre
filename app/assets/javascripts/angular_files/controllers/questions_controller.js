'use strict';

function QuestionsCtrl($scope, $routeParams, $http) {
  $http.get('/questions/1.json').success(function(data) {
    alert($routeParams.questionId);
    $scope.question = data;
  });
};
