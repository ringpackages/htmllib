/*
	HTMLLib Demo 63 - Model Showcase
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 63: Model Showcase
# ------------------------------------------------------------------
? "Demo 63: Model Showcase..."

oHTML = new HTMLWriter
oHTML.setTitle("Model Showcase")
oHTML.enableThreeJS()
oHTML.enableGLTFLoader()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a1a"], ["font-family", "Arial, sans-serif"], ["color", "#fff"], ["overflow", "hidden"]])

# Scene
oHTML.threeJSScene("showcase", [:fullscreen = true, :bg = "0x0a0a1a", :camY = "3", :camZ = "8", :camFov = "50"])

# Lights
oHTML.threeJSAmbientLight("showcase", [:intensity = "0.5"])
oHTML.threeJSDirectionalLight("showcase", "key", [:x = "5", :y = "10", :z = "5", :intensity = "0.8"])
oHTML.threeJSPointLight("showcase", "accent1", [:x = "-4", :y = "3", :z = "2", :color = "0xff6b6b", :intensity = "0.5"])
oHTML.threeJSPointLight("showcase", "accent2", [:x = "4", :y = "3", :z = "-2", :color = "0x6c5ce7", :intensity = "0.5"])

# Grid floor
oHTML.threeJSPlane("showcase", "floor", [:w = "30", :h = "30", :color = "0x111122", :rx = "-1.5708"])
oHTML.threeJSGridHelper("showcase", [:size = "30", :divisions = "30", :color1 = "0x222233", :color2 = "0x333344"])

# Load several GLTF models
# Model 1: Duck
oHTML.threeJSLoadGLTF("showcase", "duck",
	"https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Duck/glTF-Binary/Duck.glb",
	[:x = "-3", :y = "0", :autoFit = "2", :castShadow = true])

# Model 2: Animated Fox
oHTML.threeJSLoadGLTF("showcase", "fox",
	"https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Fox/glTF-Binary/Fox.glb",
	[:x = "3", :y = "0", :autoFit = "2", :autoPlay = true, :castShadow = true])

# Add primitive markers/pedestals
oHTML.threeJSCylinder("showcase", "ped1", [:radiusTop = "1.2", :radiusBottom = "1.3", :height = "0.15", :color = "0x333344", :x = "-3", :y = "0.07"])
oHTML.threeJSCylinder("showcase", "ped2", [:radiusTop = "1.2", :radiusBottom = "1.3", :height = "0.15", :color = "0x333344", :x = "3", :y = "0.07"])

# Labels (3D text-style markers using HTML overlay)
oHTML.threeJSOverlay("showcase",
	"<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'>" +
	"<div style='font-size:1.2rem;font-weight:bold;color:#6c5ce7'>Model Gallery</div>" +
	"<div style='font-size:0.8rem;color:#888;margin-top:8px;line-height:1.6'>" +
	"Left: Duck (static glTF)<br>" +
	"Right: Fox (animated glTF)<br>" +
	"</div>" +
	"<div style='font-size:0.7rem;color:#555;margin-top:8px'>Drag to orbit</div></div>",
	[:position = "top-left"])

# Rotate models slowly
oHTML.threeJSOnAnimate("showcase", "if(duck) duck.rotation.y += 0.3 * delta;")
oHTML.threeJSOnAnimate("showcase", "if(fox) fox.rotation.y += 0.2 * delta;")

# Particles
oHTML.threeJSParticles("showcase", "bgStars", [:count = "1500", :spread = "80", :size = "0.05", :color = "0x6c5ce7", :opacity = "0.4"])
oHTML.threeJSAutoRotate("showcase", "bgStars", [:speedY = "0.02"])

oHTML.threeJSMouseLook("showcase", [])
oHTML.threeJSAnimate("showcase")

oHTML.save("model_demo4_showcase.html")
? "  Created: model_demo4_showcase.html"
