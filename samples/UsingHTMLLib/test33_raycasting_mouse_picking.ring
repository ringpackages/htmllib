/*
	HTMLLib Demo 33 - Raycasting / Mouse Picking
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 33: Raycasting / Mouse Picking
# ------------------------------------------------------------------
? "Demo 33: Raycasting..."

oHTML = new HTMLWriter
oHTML.setTitle("Raycasting - Click Objects")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("ray", [:fullscreen = true, :bg = "0x1a1a2e", :camZ = "8", :camY = "3"])

# Create clickable objects
oHTML.threeJSBox("ray", "box1", [:x = "-3", :y = "1", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSSphere("ray", "sph1", [:x = "0", :y = "1", :color = "0x2ecc71", :radius = "0.8", :segments = "32"])
oHTML.threeJSCylinder("ray", "cyl1", [:x = "3", :y = "1", :color = "0x3498db", :radiusTop = "0.7", :radiusBottom = "0.7", :height = "1.5"])

# Floor
oHTML.threeJSPlane("ray", "floor1", [:w = "20", :h = "20", :color = "0x2c3e50", :rx = "-1.5708"])

# Lighting
oHTML.threeJSAmbientLight("ray", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("ray", "light1", [:x = "5", :y = "8", :z = "5", :intensity = "0.8"])

# Raycast — click to change color
oHTML.threeJSRaycast("ray", ["box1", "sph1", "cyl1"],
	"hit.object.material.color.set(Math.random() * 0xffffff);",
	[:event = "click"])

# Hover — scale up on hover
oHTML.threeJSHover("ray", ["box1", "sph1", "cyl1"],
	"hit.object.scale.set(1.2, 1.2, 1.2); document.body.style.cursor='pointer';",
	"hit.object.scale.set(1, 1, 1); document.body.style.cursor='default';",
	[])

oHTML.threeJSOrbitControls("ray", [:damping = true, :minDistance = "3", :maxDistance = "20"])

oHTML.threeJSOverlay("ray", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#e74c3c;font-weight:bold;font-size:1.1rem'>Raycasting Demo</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Click &mdash; Random color<br>Hover &mdash; Scale up<br>Drag &mdash; Orbit camera</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("ray")
oHTML.save("adv_demo1_raycast.html")
? "  Created: adv_demo1_raycast.html"
