/*
	HTMLLib Demo 37 - Post-Processing Effects
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 37: Post-Processing Effects
# ------------------------------------------------------------------
? "Demo 37: Post-Processing Effects..."

oHTML = new HTMLWriter
oHTML.setTitle("Post-Processing Effects")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enablePostProcessing()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("ppx", [:fullscreen = true, :bg = "0x1a1a2e", :camZ = "6", :camY = "2"])

# Scene content
oHTML.threeJSBox("ppx", "bx1", [:x = "-2", :y = "1", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSSphere("ppx", "sp1", [:x = "0", :y = "1.2", :color = "0x2ecc71", :radius = "0.8", :segments = "32"])
oHTML.threeJSTorus("ppx", "tr1", [:x = "2.5", :y = "1.2", :color = "0x3498db", :radius = "0.7", :tube = "0.3"])
oHTML.threeJSAutoRotate("ppx", "bx1", [:speedY = "0.3", :speedX = "0.2"])
oHTML.threeJSAutoRotate("ppx", "tr1", [:speedY = "0.5"])

oHTML.threeJSPlane("ppx", "flr", [:w = "20", :h = "20", :color = "0x222233", :rx = "-1.5708"])
oHTML.threeJSGridHelper("ppx", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSAmbientLight("ppx", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("ppx", "dl", [:x = "3", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("ppx", [:damping = true])

# Post-processing: Film + Vignette
oHTML.threeJSPostProcessing("ppx")
oHTML.threeJSFilmGrain("ppx", [:noise = "0.3", :scanlines = "0.04", :scanCount = "648"])
oHTML.threeJSVignette("ppx", [:offset = "0.95", :darkness = "1.5"])

oHTML.threeJSOverlay("ppx", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:10px'><div style='color:#e74c3c;font-weight:bold'>Film + Vignette</div><div style='font-size:0.7rem;color:#aaa;margin-top:5px'>Film grain, scanlines, vignette</div></div>", [:position = "top-left"])

oHTML.threeJSPostProcessAnimate("ppx")
oHTML.save("adv_demo5_postfx.html")
? "  Created: adv_demo5_postfx.html"
