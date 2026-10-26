/*
	HTMLLib Demo 52 - Hologram
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 52: Hologram
# ------------------------------------------------------------------
? "Demo 52: Hologram..."

oHTML = new HTMLWriter
oHTML.setTitle("Hologram Effect")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#000"], ["overflow", "hidden"]])

oHTML.threeJSScene("d3", [:fullscreen = true, :bg = "0x000000", :camZ = "4", :camY = "1"])

# Hologram torus knot
oHTML.threeJSShaderHologram("d3", "holo", "torusknot", "1, 0.35, 100, 16", [
	:color = "0x00cec9", :scanSpeed = "3.0", :scanDensity = "50.0",
	:glitchIntensity = "0.03", :y = "1"
])
oHTML.threeJSAutoRotate("d3", "holo", [:speedY = "0.5"])

# Platform
oHTML.threeJSCylinder("d3", "platform", [:radiusTop = "1.5", :radiusBottom = "1.6", :height = "0.1", :color = "0x111111", :metalness = "0.9", :roughness = "0.1"])

# Glow ring on platform
oHTML.threeJSShaderFresnel("d3", "glowRing", "torus", "1.5, 0.02, 32, 8", [
	:color = "0x001111", :glowColor = "0x00cec9", :power = "1.0", :intensity = "2.0",
	:y = "0.05"
])

oHTML.threeJSParticles("d3", "dust", [:count = "500", :spread = "20", :size = "0.03", :color = "0x00cec9", :opacity = "0.3"])
oHTML.threeJSAutoRotate("d3", "dust", [:speedY = "0.05"])

oHTML.threeJSMouseLook("d3", [])
oHTML.threeJSOverlay("d3", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#00cec9;font-weight:bold'>Hologram Shader</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Scan lines + fresnel + glitch</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d3")
oHTML.save("shader_demo3_hologram.html")
? "  Created: shader_demo3_hologram.html"
