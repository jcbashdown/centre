'use strict';

function QuestionsCtrl($scope, $routeParams, $http) {
  $http.get('/questions/'+$routeParams.questionId+'.json').success(function(data) {
    $scope.question = data;
  });
  $scope.subPoint = function(node_id) {
    $http.get('/nodes/'+node_id+'.json').success(function(data) {
      //http://www.cheatography.com/proloser/cheat-sheets/angularjs/
      //get partial
      //partial has controller declaration
      //controller has nodes show
      //nodes show called for node and partial scope done...
      return data; 
    });
  };
};
