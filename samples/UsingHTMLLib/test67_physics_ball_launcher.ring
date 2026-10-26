/*
	HTMLLib Demo 67 - Physics - Ball Launcher
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 67: Physics - Ball Launcher
# ------------------------------------------------------------------
? "Demo 67: Physics - Ball Launcher..."

oHTML = new HTMLWriter
oHTML.setTitle("Physics - Ball Launcher")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enablePhysics()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("phys2", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "18", :camY = "8"])

oHTML.threeJSPhysicsWorld("phys2", [:gravityY = "-9.82", :broadphase = "sap"])

# Ground
oHTML.threeJSPhysicsGround("phys2", [:visible = true, :color = "0x2c3e50", :size = "60", :friction = "0.6", :restitution = "0.4"])
oHTML.threeJSGridHelper("phys2", [:size = "60", :divisions = "60", :color1 = "0x333344", :color2 = "0x444455"])

# Wall of boxes (4x3)
oHTML.threeJSBox("phys2", "w00", [:x = "-3", :y = "0.75", :z = "-8", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w00", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])
oHTML.threeJSBox("phys2", "w01", [:x = "-1", :y = "0.75", :z = "-8", :color = "0x2ecc71", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w01", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])
oHTML.threeJSBox("phys2", "w02", [:x = "1", :y = "0.75", :z = "-8", :color = "0x3498db", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w02", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])
oHTML.threeJSBox("phys2", "w03", [:x = "3", :y = "0.75", :z = "-8", :color = "0xf39c12", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w03", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])

oHTML.threeJSBox("phys2", "w10", [:x = "-2", :y = "2.25", :z = "-8", :color = "0x9b59b6", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w10", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])
oHTML.threeJSBox("phys2", "w11", [:x = "0", :y = "2.25", :z = "-8", :color = "0x1abc9c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w11", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])
oHTML.threeJSBox("phys2", "w12", [:x = "2", :y = "2.25", :z = "-8", :color = "0xe67e22", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w12", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])

oHTML.threeJSBox("phys2", "w20", [:x = "-1", :y = "3.75", :z = "-8", :color = "0x2ecc71", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w20", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])
oHTML.threeJSBox("phys2", "w21", [:x = "1", :y = "3.75", :z = "-8", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("phys2", "w21", "box", [:mass = "0.5", :sx = "1.5", :sy = "1.5", :sz = "1.5", :restitution = "0.2"])

# Ball spawner - click to launch
oHTML.threeJSPhysicsSpawn("phys2", "cannonball", "sphere", "sphere", [], [:mass = "4", :color = "0xffd700", :restitution = "0.5", :radius = "0.6"])

# Procedural sound for impact
oHTML.threeJSTone("phys2", "boom", [:waveform = "sine", :volume = "0.2", :frequency = "100", :duration = "0.2"])

oHTML.threeJSRaw("
document.addEventListener('keydown', function(e) {
  if(e.code === 'Space') {
    var b = spawn_cannonball(0, 3, 8, 0, 2, -20);
    boom_play(80 + Math.random()*60, 0.2);
  }
});
renderer_phys2.domElement.addEventListener('click', function() {
  var b = spawn_cannonball(0, 3, 8, (Math.random()-0.5)*4, 3, -22);
  boom_play(80 + Math.random()*60, 0.2);
});
")

oHTML.threeJSAmbientLight("phys2", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("phys2", "ph2Lt", [:x = "5", :y = "10", :z = "8", :intensity = "0.8"])

oHTML.threeJSOrbitControls("phys2", [:damping = true])

oHTML.threeJSOverlay("phys2", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#ffd700;font-weight:bold;font-size:1.1rem'>Ball Launcher</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.8'><span style='color:#fff'>Click</span> or <span style='color:#fff'>Space</span> to launch balls<br>Knock down the box wall!<br><br>Cannon.js physics with<br>dynamic spawning</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("phys2")
oHTML.save("phys_demo2_launcher.html")
? "  Created: phys_demo2_launcher.html"
