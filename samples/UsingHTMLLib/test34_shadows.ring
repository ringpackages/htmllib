/*
	HTMLLib Demo 34 - Shadows
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 34: Shadows
# ------------------------------------------------------------------
? "Demo 34: Shadows..."

oHTML = new HTMLWriter
oHTML.setTitle("Shadows")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("shd", [:fullscreen = true, :bg = "0x87CEEB", :camZ = "10", :camY = "6"])

# Enable shadows on renderer
oHTML.threeJSEnableShadows("shd", [:type = "pcfsoft"])

# Ground plane to receive shadows
oHTML.threeJSPlane("shd", "ground", [:w = "30", :h = "30", :color = "0x90B77D", :rx = "-1.5708"])
oHTML.threeJSMeshShadow("ground", false, true)

# Shapes that cast shadows
oHTML.threeJSBox("shd", "cube", [:x = "-3", :y = "1", :color = "0xe74c3c", :w = "2", :h = "2", :d = "2"])
oHTML.threeJSMeshShadow("cube", true, true)

oHTML.threeJSSphere("shd", "ball", [:x = "0", :y = "1.5", :color = "0xf1c40f", :radius = "1.2", :segments = "32"])
oHTML.threeJSMeshShadow("ball", true, true)

oHTML.threeJSTorusKnot("shd", "knot", [:x = "3.5", :y = "2", :color = "0x9b59b6", :radius = "0.8", :tube = "0.3"])
oHTML.threeJSMeshShadow("knot", true, true)

# Directional light with shadow
oHTML.threeJSDirectionalLight("shd", "sun", [:x = "5", :y = "10", :z = "5", :intensity = "1.0", :color = "0xffffff"])
oHTML.threeJSShadowConfig("sun", [:mapSize = "2048", :far = "30", :left = "-10", :right = "10", :top = "10", :bottom = "-10"])

oHTML.threeJSAmbientLight("shd", [:intensity = "0.4"])

# Animate knot
oHTML.threeJSAutoRotate("shd", "knot", [:speedY = "0.5", :speedX = "0.3"])
oHTML.threeJSBob("shd", "ball", [:speed = "1.5", :height = "0.5", :baseY = "1.5"])

oHTML.threeJSOrbitControls("shd", [:damping = true])

oHTML.threeJSOverlay("shd", "<div style='background:rgba(0,0,0,0.6);padding:12px 18px;border-radius:10px'><div style='color:#f1c40f;font-weight:bold'>Shadow Demo</div><div style='font-size:0.7rem;color:#aaa;margin-top:5px'>PCF Soft shadows from directional light</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("shd")
oHTML.save("adv_demo2_shadows.html")
? "  Created: adv_demo2_shadows.html"
