/*
	HTMLLib Demo 54 - Fresnel Glow
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 54: Fresnel Glow
# ------------------------------------------------------------------
? "Demo 54: Fresnel Glow..."

oHTML = new HTMLWriter
oHTML.setTitle("Fresnel Glow")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a1a"], ["overflow", "hidden"]])

oHTML.threeJSScene("d5", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "5", :camY = "0"])

# Central glowing sphere
oHTML.threeJSShaderFresnel("d5", "glow1", "sphere", "1.2, 64, 64", [
	:color = "0x2d3436", :glowColor = "0x6c5ce7", :power = "2.0", :intensity = "1.5",
	:animate = true, :speed = "1.0"
])

# Orbiting glow objects
oHTML.threeJSShaderFresnel("d5", "glow2", "icosahedron", "0.4, 1", [
	:color = "0x2d3436", :glowColor = "0x00cec9", :power = "1.5", :intensity = "2.0",
	:x = "2.5"
])
oHTML.threeJSOrbit("d5", "glow2", [:speed = "0.8", :radius = "2.5", :y = "0.3"])

oHTML.threeJSShaderFresnel("d5", "glow3", "dodecahedron", "0.35, 0", [
	:color = "0x2d3436", :glowColor = "0xff6b6b", :power = "1.8", :intensity = "1.8",
	:x = "-2"
])
oHTML.threeJSOrbit("d5", "glow3", [:speed = "0.6", :radius = "2", :y = "-0.3"])

oHTML.threeJSAutoRotate("d5", "glow1", [:speedY = "0.2"])

oHTML.threeJSParticles("d5", "bg5", [:count = "800", :spread = "30", :size = "0.04", :color = "0x6c5ce7", :opacity = "0.4"])

oHTML.threeJSMouseLook("d5", [])
oHTML.threeJSOverlay("d5", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#6c5ce7;font-weight:bold'>Fresnel Glow</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Edge glow via view-angle dot product</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d5")
oHTML.save("shader_demo5_fresnel.html")
? "  Created: shader_demo5_fresnel.html"
