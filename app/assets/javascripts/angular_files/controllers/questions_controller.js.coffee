@QuestionsCtrl = ($scope) ->
  $scope.question = [
    {
      title: "Larry",
      for: [{title: "Go Larry!", for:[{title:"Nooo"}]}],
      against: [{title: "Booo Larry!"}]
    }
    {
      title: "Curly",
      for: [{title: "Go!"}],
      against: [{title: "Booo!"}]
    }
    {
      title: "Moe",
      for: [{title: "Yaaay!"}],
      against: [{title: "Nooo!"}]
    }
  ]
