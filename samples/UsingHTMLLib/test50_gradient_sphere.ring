/*
	HTMLLib Demo 50 - Gradient Sphere
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 50: Gradient Sphere
# ------------------------------------------------------------------
? "Demo 50: Gradient Sphere..."

oHTML = new HTMLWriter
oHTML.setTitle("Gradient Sphere")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a1a"], ["overflow", "hidden"]])

oHTML.threeJSScene("d1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "4", :camY = "0"])

oHTML.threeJSShaderGradient("d1", "gradSphere", "sphere", "1.5, 64, 64", [
	:color1 = "0x6c5ce7", :color2 = "0x00cec9", :direction = "vertical",
	:animate = true, :speed = "0.8"
])
oHTML.threeJSAutoRotate("d1", "gradSphere", [:speedY = "0.3", :speedX = "0.1"])

# Background particles
oHTML.threeJSParticles("d1", "stars", [:count = "1000", :spread = "40", :size = "0.04", :color = "0x6c5ce7", :opacity = "0.5"])

oHTML.threeJSMouseLook("d1", [])
oHTML.threeJSOverlay("d1", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#6c5ce7;font-weight:bold'>Gradient Shader</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Animated vertical color blend</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d1")
oHTML.save("shader_demo1_gradient.html")
? "  Created: shader_demo1_gradient.html"
