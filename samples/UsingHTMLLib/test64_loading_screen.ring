/*
	HTMLLib Demo 64 - Loading Screen with Model
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 64: Loading Screen with Model
# ------------------------------------------------------------------
? "Demo 64: Loading Screen..."

oHTML = new HTMLWriter
oHTML.setTitle("Loading Screen Demo")
oHTML.enableThreeJS()
oHTML.enableGLTFLoader()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#000"], ["overflow", "hidden"]])

# Loading screen
oHTML.threeJSLoadingScreen("scene5", [:text = "Loading 3D Model...", :bg = "#0a0a1a", :spinnerColor = "#6c5ce7"])

# Scene
oHTML.threeJSScene("scene5", [:fullscreen = true, :bg = "0x1a1a2e", :camY = "2", :camZ = "5", :camFov = "50", :shadows = true])

oHTML.threeJSAmbientLight("scene5", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("scene5", "light5", [:x = "5", :y = "8", :z = "5", :intensity = "1", :castShadow = true])

oHTML.threeJSPlane("scene5", "floor5", [:w = "20", :h = "20", :color = "0x222233", :rx = "-1.5708", :receiveShadow = true])
oHTML.threeJSGridHelper("scene5", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Load model with onLoad that hides loading screen
cHideLoadJS = oHTML.threeJSHideLoading("scene5")

oHTML.threeJSLoadGLTF("scene5", "model5",
	"https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Duck/glTF-Binary/Duck.glb",
	[:y = "0", :autoFit = "2", :castShadow = true,
	 :onLoad = cHideLoadJS])

oHTML.threeJSOnAnimate("scene5", "if(model5) model5.rotation.y += 0.5 * delta;")

oHTML.threeJSMouseLook("scene5", [])

oHTML.threeJSOverlay("scene5", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='font-size:1rem;font-weight:bold;color:#6c5ce7'>Loading Screen Demo</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Model appears after loading overlay fades</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("scene5")

oHTML.save("model_demo5_loading.html")
? "  Created: model_demo5_loading.html"
