/*
	HTMLLib Demo 60 - GLTF Model Viewer
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 60: GLTF Model Viewer
# ------------------------------------------------------------------
? "Demo 60: GLTF Model Viewer..."

oHTML = new HTMLWriter
oHTML.setTitle("3D Model Viewer")
oHTML.enableThreeJS()
oHTML.enableGLTFLoader()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#1a1a2e"], ["font-family", "monospace"], ["color", "#fff"], ["overflow", "hidden"]])

# Fullscreen scene
oHTML.threeJSScene("viewer", [:fullscreen = true, :bg = "0x1a1a2e", :camY = "2", :camZ = "5", :camFov = "50", :shadows = true])

# Lighting
oHTML.threeJSAmbientLight("viewer", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("viewer", "mainLight", [:x = "5", :y = "8", :z = "5", :intensity = "1", :castShadow = true])
oHTML.threeJSPointLight("viewer", "fillLight", [:x = "-3", :y = "3", :z = "-3", :color = "0x6c5ce7", :intensity = "0.4"])

# Floor
oHTML.threeJSPlane("viewer", "floor", [:w = "20", :h = "20", :color = "0x222233", :rx = "-1.5708", :receiveShadow = true])
oHTML.threeJSGridHelper("viewer", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Load a free GLTF model (Duck from Khronos samples)
oHTML.threeJSLoadGLTF("viewer", "duck",
	"https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Duck/glTF-Binary/Duck.glb",
	[:y = "0", :autoFit = "2", :castShadow = true, :receiveShadow = true,
	 :onLoad = "console.log('Duck model loaded!');"])

# Rotate the model
oHTML.threeJSOnAnimate("viewer", "if(duck) duck.rotation.y += 0.5 * delta;")

# Mouse controls
oHTML.threeJSMouseLook("viewer", [])

# HUD
oHTML.threeJSOverlay("viewer", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='font-size:1.2rem;color:#6c5ce7;font-weight:bold'>GLTF Model Viewer</div><div style='font-size:0.8rem;color:#888;margin-top:5px'>Format: glTF-Binary (.glb)</div><div style='font-size:0.7rem;color:#666;margin-top:8px'>Drag to orbit &bull; Scroll to zoom</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("viewer")

oHTML.save("model_demo1_viewer.html")
? "  Created: model_demo1_viewer.html"
