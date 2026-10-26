/*
	HTMLLib Demo 51 - Ocean Waves
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 51: Ocean Waves
# ------------------------------------------------------------------
? "Demo 51: Ocean Waves..."

oHTML = new HTMLWriter
oHTML.setTitle("Ocean Waves")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#001", "overflow", "hidden"]])

oHTML.threeJSScene("d2", [:fullscreen = true, :bg = "0x001122", :camY = "3", :camZ = "6", :camFov = "60"])

# Water plane
oHTML.threeJSShaderWater("d2", "ocean", "plane", "20, 20, 128, 128", [
	:color1 = "0x006994", :color2 = "0x00b4d8",
	:waveHeight = "0.2", :waveFreq = "3.0", :speed = "1.5",
	:rx = "-1.2", :y = "0"
])

# Sky sphere
oHTML.threeJSShaderGradient("d2", "sky", "sphere", "30, 32, 32", [
	:color1 = "0x001122", :color2 = "0x0a3d62", :direction = "vertical",
	:animate = false, :side = "back"
])

oHTML.threeJSAmbientLight("d2", [:intensity = "0.5"])
oHTML.threeJSDirectionalLight("d2", "sun2", [:x = "5", :y = "8", :z = "-3", :intensity = "0.8"])

oHTML.threeJSMouseLook("d2", [])
oHTML.threeJSOverlay("d2", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#00b4d8;font-weight:bold'>Water Shader</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Vertex displacement + fresnel + foam</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d2")
oHTML.save("shader_demo2_ocean.html")
? "  Created: shader_demo2_ocean.html"
