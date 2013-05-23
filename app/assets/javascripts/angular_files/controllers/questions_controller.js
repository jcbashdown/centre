'use strict';

function QuestionsCtrl($scope, $routeParams, $http, $compile, $rootScope) {
  $http.get('/questions/'+$routeParams.questionId+'.json').success(function(data) {
    $scope.question = data;
  });

  $scope.checkForMatch = function(point, depth, limit, data){
    if(point.id == data.parent[depth]){
      if(depth == limit){
        alert(point);
        alert($scope.question);
        point.for = data.for;
        point.against = data.against;
        alert($scope.question);
        alert(point);
        return point;
      }
      else{
        var new_depth = depth + 1;
        angular.forEach(point.for.concat(point.against), function(point, i){
          return $scope.checkForMatch(point, new_depth, limit, data);
        });
      };
    };
  };

  $scope.subPoint = function(node_id, guid, the_parent, template) {
    $http.get('/nodes/'+node_id+'.json?parent='+the_parent).success(function(data) {
      var depth = 0;
      var limit = data.parent.length-1;
      angular.forEach($scope.question, function(conclusion, i) {
        if(conclusion.id == data.parent[depth]){
          if(depth == limit){
            conclusion.for = data.for;
            conclusion.against = data.against;
            return conclusion;
          }
          else{
            var new_depth = depth + 1;
            angular.forEach(conclusion.for.concat(conclusion.against), function(point, i){
              return $scope.checkForMatch(point, new_depth, limit, data);
            });
          };
        };
      });
    });
  };
};
