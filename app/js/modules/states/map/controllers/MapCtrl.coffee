angular.module('app.modules.states.map.controllers', [])



.controller('MapCtrl', ($scope, $ionicLoading, $compile)->

  initialize = ()->
    map
    service
    infowindow

    myLatlng = new google.maps.LatLng(43.07493,-89.381388)

    mapOptions =
      center: myLatlng,
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById("map"), mapOptions)

    # //Marker + infowindow + angularjs compiled ng-click
    contentString = "<div><a ng-click='clickTest()'>Click me!</a></div>"
    compiled = $compile(contentString)($scope)

    infowindow = new google.maps.InfoWindow({
      content: compiled[0]
    })

    marker = new google.maps.Marker({
      position: myLatlng,
      map: map,
      title: 'Uluru (Ayers Rock)'
    })

    google.maps.event.addListener(marker, 'click', ()->
      infowindow.open(map,marker)
    )


    # initialize = ()->


    request = {
      location: myLatlng,
      radius: '500',
      types: ['store']
    }

    service = new google.maps.places.PlacesService(map)
    service.nearbySearch(request, callback)





    $scope.map = map

  callback = (results, status)->
    if status is google.maps.places.PlacesServiceStatus.OK
      for item in results
        place = item
        console.log item
        createMarker(item)
  createMarker = (place)->
    placeLoc = place.geometry.location;
    marker = new google.maps.Marker({
      map: map,
      position: place.geometry.location
    })

    google.maps.event.addListener(marker, 'click', ()->
      infowindow.setContent(place.name)
      infowindow.open(map, this)
    )



  ionic.Platform.ready(initialize)

  $scope.centerOnMe = ()->
    unless $scope.map then return

    $ionicLoading.show({
      content: 'Getting current location...',
      showBackdrop: false
    })

    navigator.geolocation.getCurrentPosition( (pos)->
      $scope.map.setCenter(new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude))
      $ionicLoading.hide()
      # $scope.loading.hide()
    , (error)->
      alert('Unable to get location: ' + error.message)
    )


  $scope.clickTest = ()->
    alert('Example of infowindow with ng-click')

)
