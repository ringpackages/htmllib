/*
	HTMLLib Demo 62 - Animation State Machine
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 62: Animation State Machine
# ------------------------------------------------------------------
? "Demo 62: Animation State Machine..."

oHTML = new HTMLWriter
oHTML.setTitle("Animation State Machine")
oHTML.enableThreeJS()
oHTML.enableGLTFLoader()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#111"], ["overflow", "hidden"]])

# Scene
oHTML.threeJSScene("sm", [:fullscreen = true, :bg = "0x87ceeb", :camY = "2", :camZ = "6", :camFov = "50", :shadows = true])

oHTML.threeJSHemisphereLight("sm", [:skyColor = "0x87ceeb", :groundColor = "0x444444", :intensity = "0.6"])
oHTML.threeJSDirectionalLight("sm", "sun", [:x = "5", :y = "10", :z = "5", :intensity = "1", :castShadow = true])

# Ground
oHTML.threeJSPlane("sm", "ground", [:w = "50", :h = "50", :color = "0x4a7c59", :rx = "-1.5708", :receiveShadow = true])

# Load Soldier (has Idle, Walk, Run animations)
oHTML.threeJSLoadGLTF("sm", "hero",
	"https://raw.githubusercontent.com/mrdoob/three.js/dev/examples/models/gltf/Soldier.glb",
	[:y = "0", :scale = "1", :castShadow = true])

# Keyboard input
oHTML.threeJSKeyboardControls("sm", "hero", [:speed = "4", :wasd = true, :jump = true, :jumpForce = "7", :gravity = "18", :groundY = "0"])

# Camera follow
oHTML.threeJSCameraFollow("sm", "hero", [:offsetY = "3", :offsetZ = "6", :smooth = "3"])

# Animation state machine
# States: [stateName, clipName, options]
# Transitions: [fromState, toState, condition]
oHTML.threeJSAnimStateMachine("sm", "hero", [
	["idle", "Idle", [:loop = true, :fadeDuration = "0.3"]],
	["walk", "Walk", [:loop = true, :fadeDuration = "0.3"]],
	["run", "Run", [:loop = true, :fadeDuration = "0.2", :timeScale = "1.2"]]
], [
	["idle", "walk", "k['w']||k['s']||k['a']||k['d']||k['arrowup']||k['arrowdown']||k['arrowleft']||k['arrowright']"],
	["idle", "run", "(k['w']||k['arrowup'])&&k['shift']"],
	["walk", "idle", "!k['w']&&!k['s']&&!k['a']&&!k['d']&&!k['arrowup']&&!k['arrowdown']&&!k['arrowleft']&&!k['arrowright']"],
	["walk", "run", "k['shift']"],
	["run", "walk", "!k['shift']&&(k['w']||k['s']||k['a']||k['d']||k['arrowup']||k['arrowdown']||k['arrowleft']||k['arrowright'])"],
	["run", "idle", "!k['shift']&&!k['w']&&!k['s']&&!k['a']&&!k['d']&&!k['arrowup']&&!k['arrowdown']&&!k['arrowleft']&&!k['arrowright']"]
])

# HUD
oHTML.threeJSOverlay("sm", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='font-size:1.1rem;font-weight:bold;color:#f39c12'>State Machine Demo</div><div style='font-size:0.8rem;color:#ccc;margin-top:8px;line-height:1.6'>WASD &mdash; Walk<br>Shift+W &mdash; Run<br>Space &mdash; Jump<br>Release &mdash; Idle</div><div style='margin-top:8px;font-size:0.85rem'>State: <span id='stateDisplay' style='color:#2ecc71;font-weight:bold'>idle</span></div></div>", [:position = "top-left"])

# Update state display
oHTML.threeJSUpdateHUD("sm", "stateDisplay", "hero_state")

oHTML.threeJSAnimate("sm")

oHTML.save("model_demo3_statemachine.html")
? "  Created: model_demo3_statemachine.html"
