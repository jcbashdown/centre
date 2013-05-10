@QuestionsCtrl = ($scope) ->
  $scope.question = [
    {
      title: "Larry",
      for: [{title: "Go Larry!", for:[{title:"Nooo"}]}],
      against: [{title: "Booo Larry!"}]
    }
    {
      title: "Curly",
      for: [{title: "Go!", for:[{title:"Nooo"}]}],
      against: [{title: "Booo!"}]
    }
    {
      title: "Moe",
      for: [{title: "Yaay!", for:[{title:"Nooo"}]}],
      against: [{title: "Nooo!"}]
    }
  ]
