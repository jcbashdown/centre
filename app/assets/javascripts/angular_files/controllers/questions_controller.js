'use strict';

function QuestionsCtrl($scope, $routeParams, $http, $compile, $rootScope) {
  $http.get('/questions/'+$routeParams.questionId+'.json').success(function(data) {
    $scope.question = data;
  });

  $scope.checkForMatch = function(point, depth, limit, data){
    if(point.id == data.parent[depth]){
      if(depth == limit){
        point.for = data.for;
        point.against = data.against;
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

  $scope.conclusionForm = function(point) {
    $scope.closeForms();
    $scope.loadForm(point, 'conclusion')
  };

  $scope.forForm = function(point) {
    $scope.closeForms();
    $scope.loadForm(point, 'point_for')
  };

  $scope.againstForm = function(point) {
    $scope.closeForms();
    $scope.loadForm(point, 'point_against')
  };

  $scope.closeFroms = function() {
    $('.new-conclusion').remove();
    $('.node-through-link').remove();
  };

  $scope.loadForm = function(point, type) {
//<div ng:include='' src="'/assets/angular_files/templates/point_for_form.html'"></div>
  }

  $scope.subPoint = function(node_id, the_parent) {
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
