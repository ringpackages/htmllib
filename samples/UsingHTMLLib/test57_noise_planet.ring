/*
	HTMLLib Demo 57 - Noise Planet
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 57: Noise Planet
# ------------------------------------------------------------------
? "Demo 57: Noise Planet..."

oHTML = new HTMLWriter
oHTML.setTitle("Noise Planet")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a0a"], ["overflow", "hidden"]])

oHTML.threeJSScene("d8", [:fullscreen = true, :bg = "0x0a0a0a", :camZ = "4"])

# Noise distorted sphere
oHTML.threeJSShaderNoise("d8", "planet", "sphere", "1.5, 128, 128", [
	:color1 = "0x2d3436", :color2 = "0x6c5ce7", :noiseScale = "2.0", :speed = "0.3",
	:distort = true, :distortAmount = "0.25"
])
oHTML.threeJSAutoRotate("d8", "planet", [:speedY = "0.15"])

# Atmosphere (fresnel glow around it)
oHTML.threeJSShaderFresnel("d8", "atmo", "sphere", "1.7, 64, 64", [
	:color = "0x000000", :glowColor = "0x6c5ce7", :power = "3.0", :intensity = "1.5",
	:animate = true, :speed = "0.5"
])

oHTML.threeJSParticles("d8", "stars8", [:count = "2000", :spread = "60", :size = "0.04", :color = "0xffffff", :opacity = "0.5"])

oHTML.threeJSMouseLook("d8", [])
oHTML.threeJSOverlay("d8", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#6c5ce7;font-weight:bold'>Noise Planet</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>3D simplex noise + vertex distortion</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d8")
oHTML.save("shader_demo8_noise.html")
? "  Created: shader_demo8_noise.html"
