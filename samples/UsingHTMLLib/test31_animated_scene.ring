/*
	HTMLLib Demo 31 - Animated Scene
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 31: Animated Scene
# ------------------------------------------------------------------
? "Demo 31: Animated Scene..."

oHTML = new HTMLWriter
oHTML.setTitle("Animated Scene")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0d0d1a"], ["display", "flex"], ["flex-direction", "column"], ["align-items", "center"], ["min-height", "100vh"], ["font-family", "Arial, sans-serif"], ["color", "#fff"]])

oHTML.addRawHTML('<h1 style="text-align:center;margin:20px 0 5px;color:#fd79a8">Animation Showcase</h1>')
oHTML.addRawHTML('<p style="text-align:center;color:#666;margin-bottom:15px">Bobbing, pulsing, orbiting, and rotating</p>')

oHTML.threeJSScene("anim", [:width = "900", :height = "550", :bg = "0x0d0d1a", :camY = "6", :camZ = "15", :camFov = "55"])

oHTML.threeJSAmbientLight("anim", [:intensity = "0.3"])
oHTML.threeJSPointLight("anim", "centerLight", [:x = "0", :y = "3", :z = "0", :color = "0xffffff", :intensity = "1.5"])

# Grid
oHTML.threeJSGridHelper("anim", [:size = "20", :divisions = "20", :color1 = "0x1a1a2e", :color2 = "0x2a2a3e"])

# Central torus knot
oHTML.threeJSTorusKnot("anim", "centerKnot", [:radius = "1.5", :tube = "0.4", :color = "0xfd79a8", :y = "3", :metalness = "0.8", :roughness = "0.1"])
oHTML.threeJSAutoRotate("anim", "centerKnot", [:speedY = "0.5", :speedX = "0.2"])
oHTML.threeJSBob("anim", "centerKnot", [:speed = "1", :amplitude = "0.5", :baseY = "3"])

# Orbiting spheres
oHTML.threeJSSphere("anim", "orb1", [:radius = "0.4", :color = "0xe74c3c", :material = "standard", :emissive = "0xe74c3c", :emissiveIntensity = "0.5", :metalness = "0.8"])
oHTML.threeJSSphere("anim", "orb2", [:radius = "0.4", :color = "0x3498db", :material = "standard", :emissive = "0x3498db", :emissiveIntensity = "0.5", :metalness = "0.8"])
oHTML.threeJSSphere("anim", "orb3", [:radius = "0.4", :color = "0x2ecc71", :material = "standard", :emissive = "0x2ecc71", :emissiveIntensity = "0.5", :metalness = "0.8"])

oHTML.threeJSOrbit("anim", "orb1", [:speed = "1.2", :radius = "4", :y = "3"])
oHTML.threeJSOrbit("anim", "orb2", [:speed = "0.8", :radius = "5", :y = "4"])
oHTML.threeJSOrbit("anim", "orb3", [:speed = "1.5", :radius = "3", :y = "2"])

# Pulsing boxes in corners
oHTML.threeJSBox("anim", "pBox1", [:color = "0xf39c12", :x = "-5", :y = "1", :z = "-5", :metalness = "0.6"])
oHTML.threeJSBox("anim", "pBox2", [:color = "0x9b59b6", :x = "5", :y = "1", :z = "-5", :metalness = "0.6"])
oHTML.threeJSBox("anim", "pBox3", [:color = "0x1abc9c", :x = "-5", :y = "1", :z = "5", :metalness = "0.6"])
oHTML.threeJSBox("anim", "pBox4", [:color = "0xe74c3c", :x = "5", :y = "1", :z = "5", :metalness = "0.6"])

oHTML.threeJSPulse("anim", "pBox1", [:speed = "2", :min = "0.6", :max = "1.4"])
oHTML.threeJSPulse("anim", "pBox2", [:speed = "2.5", :min = "0.5", :max = "1.5"])
oHTML.threeJSPulse("anim", "pBox3", [:speed = "1.8", :min = "0.7", :max = "1.3"])
oHTML.threeJSPulse("anim", "pBox4", [:speed = "3", :min = "0.6", :max = "1.4"])

oHTML.threeJSAutoRotate("anim", "pBox1", [:speedX = "1", :speedY = "1.5"])
oHTML.threeJSAutoRotate("anim", "pBox2", [:speedY = "2", :speedZ = "0.5"])
oHTML.threeJSAutoRotate("anim", "pBox3", [:speedX = "0.5", :speedZ = "1.5"])
oHTML.threeJSAutoRotate("anim", "pBox4", [:speedX = "1.5", :speedY = "1"])

# Stars background
oHTML.threeJSParticles("anim", "bgStars", [:count = "2000", :spread = "100", :size = "0.08", :color = "0xffffff", :opacity = "0.6"])
oHTML.threeJSAutoRotate("anim", "bgStars", [:speedY = "0.02"])

oHTML.threeJSMouseLook("anim", [])
oHTML.threeJSAnimate("anim")

oHTML.save("three_demo7_animated.html")
? "  Created: three_demo7_animated.html"
