@QuestionsCtrl = ($scope, $routeParams, $http) ->
  $http.get('/questions/1.json').success (data) ->
    alert($routeParams.questionId)
    $scope.question = data
