/*
	HTMLLib Demo 30 - 3D Game (Keyboard Controlled)
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 30: 3D Game (Keyboard Controlled)
# ------------------------------------------------------------------
? "Demo 30: 3D Game..."

oHTML = new HTMLWriter
oHTML.setTitle("3D Platformer")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"], ["background", "#000"]])

# Fullscreen scene
oHTML.threeJSScene("game", [:fullscreen = true, :bg = "0x87ceeb", :camY = "8", :camZ = "12", :camFov = "60", :shadows = true, :lookY = "2"])

# Lights
oHTML.threeJSHemisphereLight("game", [:skyColor = "0x87ceeb", :groundColor = "0x444444", :intensity = "0.6"])
oHTML.threeJSDirectionalLight("game", "sunLight", [:x = "10", :y = "15", :z = "10", :intensity = "1", :castShadow = true, :shadowSize = "15"])

# Ground
oHTML.threeJSPlane("game", "ground", [:w = "30", :h = "30", :color = "0x3d8c40", :rx = "-1.5708", :receiveShadow = true])

# Player (a blue cube)
oHTML.threeJSBox("game", "player", [:w = "1", :h = "1", :d = "1", :color = "0x2e86de", :y = "0.5", :castShadow = true, :metalness = "0.3", :roughness = "0.5"])

# Platforms
oHTML.threeJSBox("game", "plat1", [:w = "3", :h = "0.5", :d = "3", :color = "0xe74c3c", :x = "5", :y = "1.5", :z = "-3", :castShadow = true, :receiveShadow = true])
oHTML.threeJSBox("game", "plat2", [:w = "3", :h = "0.5", :d = "3", :color = "0xf39c12", :x = "-4", :y = "3", :z = "-6", :castShadow = true, :receiveShadow = true])
oHTML.threeJSBox("game", "plat3", [:w = "3", :h = "0.5", :d = "3", :color = "0x9b59b6", :x = "2", :y = "4.5", :z = "-9", :castShadow = true, :receiveShadow = true])

# Collectible coins (golden spheres)
oHTML.threeJSSphere("game", "coin1", [:radius = "0.3", :color = "0xffd700", :x = "5", :y = "3", :z = "-3", :emissive = "0xffa000", :emissiveIntensity = "0.5"])
oHTML.threeJSSphere("game", "coin2", [:radius = "0.3", :color = "0xffd700", :x = "-4", :y = "4.5", :z = "-6", :emissive = "0xffa000", :emissiveIntensity = "0.5"])
oHTML.threeJSSphere("game", "coin3", [:radius = "0.3", :color = "0xffd700", :x = "2", :y = "6", :z = "-9", :emissive = "0xffa000", :emissiveIntensity = "0.5"])

# Obstacles (red cylinders)
oHTML.threeJSCylinder("game", "obs1", [:radiusTop = "0.3", :radiusBottom = "0.3", :height = "2", :color = "0xff0000", :x = "2", :y = "1", :z = "0", :castShadow = true])
oHTML.threeJSCylinder("game", "obs2", [:radiusTop = "0.3", :radiusBottom = "0.3", :height = "2", :color = "0xff0000", :x = "-2", :y = "1", :z = "-3", :castShadow = true])

# Trees (simple cones on cylinders)
oHTML.threeJSCylinder("game", "trunk1", [:radiusTop = "0.2", :radiusBottom = "0.3", :height = "1.5", :color = "0x8B4513", :x = "-8", :y = "0.75", :z = "5", :castShadow = true])
oHTML.threeJSCone("game", "leaves1", [:radius = "1.2", :height = "2.5", :color = "0x228B22", :x = "-8", :y = "2.8", :z = "5", :castShadow = true])
oHTML.threeJSCylinder("game", "trunk2", [:radiusTop = "0.2", :radiusBottom = "0.3", :height = "1.5", :color = "0x8B4513", :x = "8", :y = "0.75", :z = "-5", :castShadow = true])
oHTML.threeJSCone("game", "leaves2", [:radius = "1", :height = "2", :color = "0x228B22", :x = "8", :y = "2.5", :z = "-5", :castShadow = true])

# Game state
oHTML.threeJSGameVar("score", "0")

# Keyboard controls with jump
oHTML.threeJSKeyboardControls("game", "player", [:speed = "6", :wasd = true, :jump = true, :jumpForce = "8", :gravity = "20", :groundY = "0.5"])

# Camera follow
oHTML.threeJSCameraFollow("game", "player", [:offsetY = "6", :offsetZ = "10", :smooth = "3"])

# Coin rotation + collection
oHTML.threeJSAutoRotate("game", "coin1", [:speedY = "3"])
oHTML.threeJSAutoRotate("game", "coin2", [:speedY = "3"])
oHTML.threeJSAutoRotate("game", "coin3", [:speedY = "3"])

oHTML.threeJSBob("game", "coin1", [:speed = "3", :amplitude = "0.3", :baseY = "3"])
oHTML.threeJSBob("game", "coin2", [:speed = "3", :amplitude = "0.3", :baseY = "4.5"])
oHTML.threeJSBob("game", "coin3", [:speed = "3", :amplitude = "0.3", :baseY = "6"])

# Collision with coins
oHTML.threeJSCollisionCheck("game", "player", "coin1", "if(coin1.visible){coin1.visible=false;score++;document.getElementById('scoreVal').textContent=score}")
oHTML.threeJSCollisionCheck("game", "player", "coin2", "if(coin2.visible){coin2.visible=false;score++;document.getElementById('scoreVal').textContent=score}")
oHTML.threeJSCollisionCheck("game", "player", "coin3", "if(coin3.visible){coin3.visible=false;score++;document.getElementById('scoreVal').textContent=score}")

# HUD
oHTML.threeJSOverlay("game", "<div style='font-size:1.2rem;background:rgba(0,0,0,0.5);padding:10px 20px;border-radius:10px'><b>Score:</b> <span id='scoreVal'>0</span> / 3<br><span style='font-size:0.7rem;opacity:0.7'>WASD = Move &bull; Space = Jump</span></div>", [:position = "top-left"])

oHTML.threeJSAnimate("game")

oHTML.save("three_demo6_game.html")
? "  Created: three_demo6_game.html"
