'use strict';

function QuestionsCtrl($scope, $routeParams, $http, $compile, $rootScope) {
  $http.get('/questions/'+$routeParams.questionId+'.json').success(function(data) {
    $scope.question = data;
  });
  var html;
  var new_scope;
  $scope.subPoint = function(node_id, guid, the_parent, template) {
    $http.get('/nodes/'+node_id+'.json?parent='+the_parent).success(function(data) {
      //edit existing json object
      //http://jsfiddle.net/vojtajina/7cpbF/7/
      //angular.forEach($scope.question, function(conclusion, i) {
      //  if(conclusion.id == data.id){
      //    conclusion = data;
      //  };
      //});
      //new_scope = $rootScope.$new();
      $scope.point = data;
      //with parent and for/against we can now find right point to replace. what else for parent though?
      $http.get('/assets/angular_files/templates/'+template).success(function(data1) {
        html = $compile(data1)($scope);
        $('#'+guid).html(html);
      });
    });
  };
};
