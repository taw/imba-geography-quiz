let cities = require("./cities.json")

let def randint(min, max)
  min + Math.floor(Math.random() * (max - min + 1))

let def radians(degrees)
  degrees * Math:PI / 180

# https://www.movable-type.co.uk/scripts/latlong.html
let def distance(lat1, lat2, lon1, lon2)
  let r = 6371 # km
  let phi1 = radians(lat1)
  let phi2 = radians(lat2)
  let dphi = radians(lat2 - lat1)
  let dlambda = radians(lon2 - lon1)

  let a = Math.sin(dphi / 2) * Math.sin(dphi / 2) +
          Math.cos(phi1) * Math.cos(phi2) *
          Math.sin(dlambda / 2) * Math.sin(dlambda / 2)
  let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

  let d = r * c

tag Map < img
  def onclick(event)
    let native_event = event.event
    let el = native_event:target
    let rect = el.getBoundingClientRect()
    let offset_x = native_event:pageX - rect:left
    let offset_y = native_event:pageY - rect:top
    let perc_x = offset_x / rect:width
    let perc_y = offset_y / rect:height
    let lon = -180 + 360 * perc_x
    let lat = 90 - 180 * perc_y
    trigger("mapclick", [lat, lon])

  def render
    <self.map src="earth.jpg">

tag Marker
  prop lat
  prop lon

  def render
    let left = "{ (lon + 180) / 360 * 100 }vw"
    let top = "{ (- lat + 90) / 180 * 50 }vw"
    <self css:top=top css:left=left>

tag App
  def onmapclick(event, latlon)
    if @state === "guess"
      @state = "result"
      @guess_latlon = latlon
      @distance = Math.round(distance(
        @city:lat,
        @guess_latlon[0],
        @city:lon
        @guess_latlon[1]
      ))
    else
      @state = "guess"
      @city = random_city

  def random_city
    cities[randint(0, cities:length - 1)]

  def setup
    @state = "guess"
    @city = random_city

  def render
    <self>
      <header>
        "Geography Quiz"
      <div.map_container>
        <Map>
        if @state === "result"
          <Marker.actual lat=@city:lat lon=@city:lon>
          <Marker.clicked lat=@guess_latlon[0] lon=@guess_latlon[1]>
      <div.instructions>
        "Where is {@city:name}?"
      if @state === "result"
        <div.result>
          "You clicked {@distance} km away from real location."
        <div.result>
          if @distance < 500
            "Amazing!"
          else if @distance < 2000
            "Pretty goood."
          else if @distance < 5000
            "Pretty poor. {@city:pop} people living there are all disappointed in you."
          else
            "Seriously? {@city:pop} people living there are all disappointed in you."
        <div.result>
          "Click anywhere to start again"

Imba.mount <App>
