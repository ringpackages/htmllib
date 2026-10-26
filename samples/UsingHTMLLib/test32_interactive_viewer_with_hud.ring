/*
	HTMLLib Demo 32 - Interactive Viewer with HUD
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 32: Interactive Viewer with HUD
# ------------------------------------------------------------------
? "Demo 32: Interactive Viewer with HUD..."

oHTML = new HTMLWriter
oHTML.setTitle("3D Viewer")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#111"], ["overflow", "hidden"]])

oHTML.threeJSScene("viewer", [:fullscreen = true, :bg = "0x1a1a2e", :camY = "4", :camZ = "8", :shadows = true])

# Lights
oHTML.threeJSAmbientLight("viewer", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("viewer", "mainLight", [:x = "5", :y = "10", :z = "5", :intensity = "1", :castShadow = true])
oHTML.threeJSPointLight("viewer", "accent", [:x = "-3", :y = "5", :z = "-3", :color = "0x6c5ce7", :intensity = "0.8"])

# Floor with grid
oHTML.threeJSPlane("viewer", "floor", [:w = "20", :h = "20", :color = "0x222233", :rx = "-1.5708", :receiveShadow = true])
oHTML.threeJSGridHelper("viewer", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Showcase object: torus knot
oHTML.threeJSTorusKnot("viewer", "model", [:radius = "1.5", :tube = "0.5", :color = "0x6c5ce7", :y = "2.5", :castShadow = true, :metalness = "0.7", :roughness = "0.2"])
oHTML.threeJSAutoRotate("viewer", "model", [:speedY = "0.5"])

# Fog for atmosphere
oHTML.threeJSFog("viewer", [:color = "0x1a1a2e", :near = "8", :far = "30"])

# Axes
oHTML.threeJSAxesHelper("viewer", "3")

# Mouse controls
oHTML.threeJSMouseLook("viewer", [])

# HUD with live stats
oHTML.threeJSOverlay("viewer", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px;border:1px solid rgba(108,92,231,0.3);min-width:200px'><div style='font-size:1.1rem;font-weight:bold;color:#6c5ce7;margin-bottom:8px'>3D Viewer</div><div style='font-size:0.8rem;line-height:1.8'><div>FPS: <span id='fpsVal' style='color:#2ecc71'>0</span></div><div>Time: <span id='timeVal' style='color:#3498db'>0.0</span>s</div><div>Objects: <span style='color:#f39c12'>5</span></div></div><div style='margin-top:8px;font-size:0.7rem;opacity:0.5'>Drag to orbit &bull; Scroll to zoom</div></div>", [:position = "top-right"])

# Update HUD
oHTML.threeJSGameVar("frameCount", "0")
oHTML.threeJSGameVar("lastFPSTime", "0")
oHTML.threeJSGameVar("currentFPS", "0")
oHTML.threeJSOnAnimate("viewer", "frameCount++;if(elapsed-lastFPSTime>=1){currentFPS=frameCount;frameCount=0;lastFPSTime=elapsed}")
oHTML.threeJSUpdateHUD("viewer", "fpsVal", "currentFPS")
oHTML.threeJSUpdateHUD("viewer", "timeVal", "elapsed.toFixed(1)")

oHTML.threeJSAnimate("viewer")

oHTML.save("three_demo8_viewer.html")
? "  Created: three_demo8_viewer.html"
