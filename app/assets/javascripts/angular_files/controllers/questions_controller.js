'use strict';

function QuestionsCtrl($scope, $routeParams, $http) {
  $http.get('/questions/'+$routeParams.questionId+'.json').success(function(data) {
    $scope.question = data;
  });
  $scope.subPoint = function(node_id) {
    $http.get('/nodes/'+node_id+'.json').success(function(data) {
      return data; 
    });
  };
};
