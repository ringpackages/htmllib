/*
	HTMLLib Demo 66 - Physics - Falling Boxes
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 66: Physics - Falling Boxes
# ------------------------------------------------------------------
? "Demo 66: Physics - Falling Boxes..."

oHTML = new HTMLWriter
oHTML.setTitle("Physics - Falling Boxes")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enablePhysics()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("phys1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "12", :camY = "8"])

# Physics world
oHTML.threeJSPhysicsWorld("phys1", [:gravityY = "-9.82"])

# Ground
oHTML.threeJSPhysicsGround("phys1", [:visible = true, :color = "0x2c3e50", :size = "40", :friction = "0.6", :restitution = "0.3"])
oHTML.threeJSGridHelper("phys1", [:size = "40", :divisions = "40", :color1 = "0x333344", :color2 = "0x444455"])

# Stack of boxes
oHTML.threeJSBox("phys1", "pb1", [:x = "0", :y = "1", :z = "0", :color = "0xe74c3c", :w = "2", :h = "2", :d = "2"])
oHTML.threeJSPhysicsBody("phys1", "pb1", "box", [:mass = "1", :restitution = "0.4", :sx = "2", :sy = "2", :sz = "2"])

oHTML.threeJSBox("phys1", "pb2", [:x = "0.3", :y = "3.5", :z = "0.1", :color = "0x2ecc71", :w = "2", :h = "2", :d = "2"])
oHTML.threeJSPhysicsBody("phys1", "pb2", "box", [:mass = "1", :restitution = "0.4", :sx = "2", :sy = "2", :sz = "2"])

oHTML.threeJSBox("phys1", "pb3", [:x = "-0.2", :y = "6", :z = "-0.15", :color = "0x3498db", :w = "2", :h = "2", :d = "2"])
oHTML.threeJSPhysicsBody("phys1", "pb3", "box", [:mass = "1", :restitution = "0.4", :sx = "2", :sy = "2", :sz = "2"])

oHTML.threeJSBox("phys1", "pb4", [:x = "0.1", :y = "8.5", :z = "0.25", :color = "0xf39c12", :w = "2", :h = "2", :d = "2"])
oHTML.threeJSPhysicsBody("phys1", "pb4", "box", [:mass = "1", :restitution = "0.4", :sx = "2", :sy = "2", :sz = "2"])

oHTML.threeJSSphere("phys1", "pBall", [:x = "0", :y = "14", :z = "0", :color = "0x9b59b6", :radius = "1", :segments = "32"])
oHTML.threeJSPhysicsBody("phys1", "pBall", "sphere", [:mass = "3", :restitution = "0.6", :radius = "1"])

# Lights
oHTML.threeJSAmbientLight("phys1", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("phys1", "phLt1", [:x = "5", :y = "10", :z = "5", :intensity = "0.8"])

oHTML.threeJSOrbitControls("phys1", [:damping = true])

oHTML.threeJSOverlay("phys1", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#e74c3c;font-weight:bold;font-size:1.1rem'>Physics - Falling Objects</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Cannon.js rigid body simulation<br>4 boxes + 1 heavy ball<br>Gravity, friction, bounce</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("phys1")
oHTML.save("phys_demo1_falling.html")
? "  Created: phys_demo1_falling.html"
