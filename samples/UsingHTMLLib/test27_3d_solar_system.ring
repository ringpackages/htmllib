/*
	HTMLLib Demo 27 - Solar System
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 27: Solar System
# ------------------------------------------------------------------
? "Demo 27: Solar System..."

oHTML = new HTMLWriter
oHTML.setTitle("Solar System")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#000"], ["overflow", "hidden"]])

# Fullscreen scene
oHTML.threeJSScene("solar", [:fullscreen = true, :bg = "0x000005", :camY = "15", :camZ = "25", :camFov = "60", :lookY = "0"])

# Lights
oHTML.threeJSAmbientLight("solar", [:intensity = "0.1"])
oHTML.threeJSPointLight("solar", "sunLight", [:x = "0", :y = "0", :z = "0", :color = "0xffffff", :intensity = "2", :distance = "100"])

# Sun (emissive, glowing)
oHTML.threeJSSphere("solar", "sun", [:radius = "2", :color = "0xffaa00", :material = "basic", :x = "0", :y = "0", :z = "0"])

# Planets
oHTML.threeJSSphere("solar", "mercury", [:radius = "0.3", :color = "0xaaaaaa", :x = "4", :metalness = "0.5", :roughness = "0.5"])
oHTML.threeJSSphere("solar", "venus", [:radius = "0.5", :color = "0xe8a735", :x = "6", :metalness = "0.3", :roughness = "0.7"])
oHTML.threeJSSphere("solar", "earth", [:radius = "0.55", :color = "0x2e86de", :x = "9", :metalness = "0.4", :roughness = "0.6"])
oHTML.threeJSSphere("solar", "mars", [:radius = "0.4", :color = "0xc0392b", :x = "12", :metalness = "0.3", :roughness = "0.8"])
oHTML.threeJSSphere("solar", "jupiter", [:radius = "1.2", :color = "0xd4a356", :x = "17", :metalness = "0.2", :roughness = "0.7"])
oHTML.threeJSSphere("solar", "saturn", [:radius = "1.0", :color = "0xf0d58e", :x = "22", :metalness = "0.3", :roughness = "0.6"])

# Saturn ring
oHTML.threeJSRing("solar", "saturnRing", [:innerRadius = "1.3", :outerRadius = "2.2", :color = "0xd4a356", :x = "22", :side = "double", :opacity = "0.6", :transparent = true])
oHTML.threeJSRaw("saturnRing.rotation.x = -Math.PI / 2.5;")

# Stars
oHTML.threeJSParticles("solar", "stars", [:count = "3000", :spread = "200", :size = "0.15", :color = "0xffffff"])

# Orbits
oHTML.threeJSOrbit("solar", "mercury", [:speed = "1.8", :radius = "4"])
oHTML.threeJSOrbit("solar", "venus", [:speed = "1.3", :radius = "6"])
oHTML.threeJSOrbit("solar", "earth", [:speed = "1.0", :radius = "9"])
oHTML.threeJSOrbit("solar", "mars", [:speed = "0.8", :radius = "12"])
oHTML.threeJSOrbit("solar", "jupiter", [:speed = "0.5", :radius = "17"])
oHTML.threeJSOrbit("solar", "saturn", [:speed = "0.35", :radius = "22"])
oHTML.threeJSOrbit("solar", "saturnRing", [:speed = "0.35", :radius = "22"])

# Self-rotation
oHTML.threeJSAutoRotate("solar", "sun", [:speedY = "0.2"])
oHTML.threeJSAutoRotate("solar", "earth", [:speedY = "2"])
oHTML.threeJSAutoRotate("solar", "jupiter", [:speedY = "3"])

# Mouse control
oHTML.threeJSMouseLook("solar", [:sensitivity = "0.003"])

# HUD
oHTML.threeJSOverlay("solar", "<h2 style='margin:0 0 5px'>Solar System</h2><div style='font-size:0.8rem;opacity:0.7'>Drag to orbit &bull; Scroll to zoom</div>", [:position = "top-left", :style = "text-shadow:0 0 10px rgba(0,0,0,0.8)"])

oHTML.threeJSAnimate("solar")

oHTML.save("three_demo3_solar.html")
? "  Created: three_demo3_solar.html"
