/*
	HTMLLib Demo 73 - 3D Text - Multiple Fonts
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 73: 3D Text - Multiple Fonts
# ------------------------------------------------------------------
? "Demo 73: 3D Text - Multiple Fonts..."

oHTML = new HTMLWriter
oHTML.setTitle("3D Text - Font Gallery")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableTextGeometry()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("txt2", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "12", :camY = "4"])

# Different fonts
oHTML.threeJSText3D("txt2", "fontA", "Helvetiker", [:font = "helvetiker", :fontStyle = "bold", :size = "0.7", :height = "0.2", :color = "0xe74c3c", :metalness = "0.5", :y = "4"])

oHTML.threeJSText3D("txt2", "fontB", "Optimer", [:font = "optimer", :fontStyle = "regular", :size = "0.7", :height = "0.2", :color = "0x2ecc71", :metalness = "0.5", :y = "2"])

oHTML.threeJSText3D("txt2", "fontC", "Gentilis", [:font = "gentilis", :fontStyle = "bold", :size = "0.7", :height = "0.2", :color = "0x3498db", :metalness = "0.5", :y = "0"])

oHTML.threeJSText3D("txt2", "fontD", "Droid Sans", [:font = "droid_sans", :fontStyle = "regular", :size = "0.7", :height = "0.2", :color = "0xf39c12", :metalness = "0.5", :y = "-2"])

oHTML.threeJSText3D("txt2", "fontE", "Droid Serif", [:font = "droid_serif", :fontStyle = "bold", :size = "0.7", :height = "0.2", :color = "0x9b59b6", :metalness = "0.5", :y = "-4"])

oHTML.threeJSPlane("txt2", "txt2Floor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708", :y = "-6"])

oHTML.threeJSAmbientLight("txt2", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("txt2", "txt2Lt", [:x = "5", :y = "8", :z = "5", :intensity = "0.8"])

oHTML.threeJSOrbitControls("txt2", [:damping = true])

oHTML.threeJSOverlay("txt2", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#f39c12;font-weight:bold;font-size:1.1rem'>Font Gallery</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>5 built-in Three.js fonts:<br><span style='color:#e74c3c'>Helvetiker Bold</span><br><span style='color:#2ecc71'>Optimer Regular</span><br><span style='color:#3498db'>Gentilis Bold</span><br><span style='color:#f39c12'>Droid Sans</span><br><span style='color:#9b59b6'>Droid Serif Bold</span></div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("txt2")
oHTML.save("text_demo2_fonts.html")
? "  Created: text_demo2_fonts.html"
