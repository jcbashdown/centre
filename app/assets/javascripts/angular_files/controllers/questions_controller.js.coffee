@QuestionsCtrl = ($scope) ->
  $scope.question = [
    {
      title: "Larry",
      for: [
        {
          title: "Go Larry!", 
          for:[
            {
              title:"Nooo"
            }
          ]
        },
        {
          title: "Go Larry!", 
          for:[
            {
              title:"Nooo"
              against:[
                {
                  title:"ahainst!"
                }
              ]
            }
          ]
        }
      ],
      against: [
        {
          title: "Booo Larry!"
        }
      ]
    }
    {
      title: "Curly",
      for: [
        {
          title: "Go!",
          for:[
            {
              title:"Nooo"
            }
          ]
        }
      ],
      against: [
        {
          title: "Booo!"
        }
      ]
    }
  ]
