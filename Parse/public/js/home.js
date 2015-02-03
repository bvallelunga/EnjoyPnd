$(function() {
  if($('.map').length > 0) {
    localLatLng(function(latLng) {
      return setUpMap({
        latLng: new google.maps.LatLng(latLng.latitude, latLng.longitude)
      })
    })
  }

  $(".simulateJob").click(function() {
    var button = $(this).text("creating job...")

    $.post("/jobs/simulate", function(response) {
      if(response.success) {
        window.location.reload()
      } else {
         button.text("Failed to create job")
      }
    })
  })

  $(".search-form").submit(function(e) {
    e.preventDefault()
    e.stopPropagation()

    setUpMap({
      address: $(this).find(".search").val()
    })
  })

  if($(".search").length > 0) {
    new google.maps.places.Autocomplete($(".search").get(0));
  }
})

function localLatLng(cb) {
  return navigator.geolocation.getCurrentPosition(function(search) {
    return cb(search.coords)
  })
}

function toRad(num) {
  return num * Math.PI / 180
}

function haversine(start, end, options) {
  var R, a, c, dLat, dLon, km, lat1, lat2, mile
  km = 6371
  mile = 3960
  if (options == null) {
    options = {}
  }
  R = options.unit === 'mile' ? mile : km
  dLat = toRad(end.latitude - start.latitude)
  dLon = toRad(end.longitude - start.longitude)
  lat1 = toRad(start.latitude)
  lat2 = toRad(end.latitude)
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  if (options.threshold) {
    return options.threshold > (R * c)
  } else {
    return R * c
  }
}

function setUpMap(options) {
  var geocoder = new google.maps.Geocoder()

  return geocoder.geocode(options, function(results, status) {
    var pin = {
      url: "/images/pin.png",
      size: new google.maps.Size(50, 74),
      scaledSize: new google.maps.Size(25, 37),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(0, 32)
    }

    var pin_hover = {
      url: "/images/pin_hover.png",
      size: new google.maps.Size(50, 74),
      scaledSize: new google.maps.Size(25, 37),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(0, 32)
    }

    if(!window.gMap) {
      window.gMap = new google.maps.Map($('.map').get(0), {
        zoom: 14,
        center: results[0].geometry.location,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDefaultUI: true,
        zoomControl: true,
        zoomControlOptions: {
          style: google.maps.ZoomControlStyle.SMALL
        }
      })


      $(".search-form").show()
    } else {
      window.gMap.setCenter(results[0].geometry.location)
    }

    $(".item").each(function() {
      var lat = parseFloat($(this).data("lat"))
      var ln = parseFloat($(this).data("lng"))
      var latLng = new google.maps.LatLng(lat, ln)
      var marker = new google.maps.Marker({
        position: latLng,
        map: window.gMap,
        icon: pin
      })

      $(this).mouseover(function() {
        return marker.setIcon(pin_hover)
      })

      $(this).mouseout(function() {
        return marker.setIcon(pin)
      })

      google.maps.event.addListener(marker, 'click', (function(_this) {
        return function() {
          return window.location.href = $(_this).attr("href")
        }
      })(this))

      google.maps.event.addListener(marker, 'mouseover', (function(_this) {
        return function() {
          $(_this).addClass("hover")
          return marker.setIcon(pin_hover)
        }
      })(this))

      google.maps.event.addListener(marker, 'mouseout', (function(_this) {
        return function() {
          $(_this).removeClass("hover")
          return marker.setIcon(pin)
        }
      })(this))
    })
  })
}
