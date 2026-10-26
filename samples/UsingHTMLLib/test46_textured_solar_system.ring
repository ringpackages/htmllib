/*
	HTMLLib Demo 46 - Solar System with Textured Planets
*/

load "htmllib.ring"

# Free texture URLs (public domain images)
cTexEarth = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Blue_Marble_2002.png/512px-Blue_Marble_2002.png"
cTexMoon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/FullMoon2010.jpg/512px-FullMoon2010.jpg"
cTexMars  = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/OSIRIS_Mars_true_color.jpg/512px-OSIRIS_Mars_true_color.jpg"

# ------------------------------------------------------------------
# Demo 46: Solar System with Textured Planets
# ------------------------------------------------------------------
? "Demo 46: Solar System..."

oHTML = new HTMLWriter
oHTML.setTitle("Solar System")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("sol", [:fullscreen = true, :bg = "0x000005", :camZ = "15", :camY = "8"])

# Sun (emissive, no texture needed)
oHTML.threeJSSphere("sol", "sun", [
	:x = "0", :y = "0",
	:radius = "1.5", :segments = "32",
	:color = "0xffaa00",
	:material = "basic",
	:emissive = "0xffaa00",
	:emissiveIntensity = "1"
])

# Earth
oHTML.threeJSSphere("sol", "earthP", [
	:x = "5", :y = "0",
	:radius = "0.7", :segments = "48",
	:texture = cTexEarth,
	:color = "0xffffff"
])

# Moon orbiting Earth
oHTML.threeJSSphere("sol", "moonP", [
	:x = "6.5", :y = "0",
	:radius = "0.2", :segments = "24",
	:texture = cTexMoon,
	:color = "0xffffff"
])

# Mars
oHTML.threeJSSphere("sol", "marsP", [
	:x = "8.5", :y = "0",
	:radius = "0.5", :segments = "48",
	:texture = cTexMars,
	:color = "0xffffff"
])

# Point light at sun
oHTML.threeJSPointLight("sol", "sunLight", [:x = "0", :y = "0", :z = "0", :intensity = "1.5", :color = "0xffffff"])
oHTML.threeJSAmbientLight("sol", [:intensity = "0.15"])

# Orbits
oHTML.threeJSOnAnimate("sol", "
  var t = elapsed;
  // Earth orbit
  if(earthP) {
    earthP.position.x = Math.cos(t * 0.5) * 5;
    earthP.position.z = Math.sin(t * 0.5) * 5;
    earthP.rotation.y += delta;
  }
  // Moon orbit around Earth
  if(moonP && earthP) {
    moonP.position.x = earthP.position.x + Math.cos(t * 2) * 1.5;
    moonP.position.z = earthP.position.z + Math.sin(t * 2) * 1.5;
  }
  // Mars orbit
  if(marsP) {
    marsP.position.x = Math.cos(t * 0.3) * 8.5;
    marsP.position.z = Math.sin(t * 0.3) * 8.5;
    marsP.rotation.y += delta * 0.9;
  }
  // Sun glow
  if(sun) sun.rotation.y += delta * 0.1;
")

oHTML.threeJSOrbitControls("sol", [:damping = true])

oHTML.threeJSOverlay("sol", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#ffaa00;font-weight:bold;font-size:1.1rem'>Solar System</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'><span style='color:#ffaa00'>Sun</span> &mdash; emissive glow<br><span style='color:#4da6ff'>Earth</span> &mdash; NASA blue marble<br><span style='color:#ccc'>Moon</span> &mdash; orbiting Earth<br><span style='color:#c87533'>Mars</span> &mdash; outer orbit</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("sol")
oHTML.save("tex_demo2_solar.html")
? "  Created: tex_demo2_solar.html"
