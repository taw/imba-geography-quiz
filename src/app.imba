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

tag Markers < svg:svg
  prop city
  prop clicked

  def y(lat)
    "{ (- lat + 90) / 180 * 50 }vw"

  def x(lon)
    "{ (lon + 180) / 360 * 100 }vw"

  def render
    let y1 = y(city:lat)
    let x1 = x(city:lon)
    let y2 = y(clicked[0])
    let x2 = x(clicked[1])
    <self>
      <svg:line x1=x1 y1=y1 x2=x2 y2=y2>
      <svg:circle.actual cx=x1 cy=y1>
      <svg:circle.clicked cx=x2 cy=y2>

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
      <div.map_container>
        <Map>
        if @state === "result"
          <Markers city=@city clicked=@guess_latlon>
      <div.instructions>
        "Where is "
        <b>
          @city:name
        "?"
      if @state === "result"
        <div.result>
          <b>
            @distance
          "km off"
        <div.result>
          if @distance < 500
            "Amazing!"
          else if @distance < 2000
            "Pretty good."
          else if @distance < 5000
            "Pretty poor. {@city:pop} people living there are all disappointed in you."
          else
            "Seriously? {@city:pop} people living there are all disappointed in you."
        <div.result>
          "Click anywhere to start again"

Imba.mount <App>
