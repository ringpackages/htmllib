/*
	HTMLLib Demo 61 - Animated Character
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 61: Animated Character
# ------------------------------------------------------------------
? "Demo 61: Animated Character..."

oHTML = new HTMLWriter
oHTML.setTitle("Animated Character")
oHTML.enableThreeJS()
oHTML.enableGLTFLoader()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#111"], ["font-family", "Arial, sans-serif"], ["color", "#fff"], ["overflow", "hidden"]])

# Scene
oHTML.threeJSScene("char", [:fullscreen = true, :bg = "0x87ceeb", :camY = "1.5", :camZ = "4", :camFov = "50", :shadows = true])

# Sky-like lighting
oHTML.threeJSHemisphereLight("char", [:skyColor = "0x87ceeb", :groundColor = "0x444444", :intensity = "0.6"])
oHTML.threeJSDirectionalLight("char", "sun", [:x = "5", :y = "10", :z = "5", :intensity = "1", :castShadow = true, :shadowSize = "10"])

# Ground
oHTML.threeJSPlane("char", "ground", [:w = "30", :h = "30", :color = "0x4a7c59", :rx = "-1.5708", :receiveShadow = true])

# Load animated GLTF character (Soldier from Three.js examples)
oHTML.threeJSLoadGLTF("char", "soldier",
	"https://raw.githubusercontent.com/mrdoob/three.js/dev/examples/models/gltf/Soldier.glb",
	[:y = "0", :scale = "1", :autoPlay = true, :castShadow = true])

# Log animation names for debugging
oHTML.threeJSLogAnimations("soldier")

# Animation control buttons (HTML overlay)
cBtnStyle = "padding:8px 16px;margin:4px;border:none;border-radius:6px;cursor:pointer;font-size:0.85rem;font-weight:bold;transition:background 0.2s"
cControls = '<div style="background:rgba(0,0,0,0.7);padding:15px;border-radius:10px;pointer-events:auto">' + HTML_LF
cControls += '<div style="font-size:1rem;font-weight:bold;color:#2ecc71;margin-bottom:10px">Animation Controls</div>' + HTML_LF
cControls += '<button style="' + cBtnStyle + ';background:#2ecc71;color:#fff" onclick="soldier_playAnim(' + char(39) + 'Idle' + char(39) + ',0.5,true,false,1)">Idle</button>' + HTML_LF
cControls += '<button style="' + cBtnStyle + ';background:#3498db;color:#fff" onclick="soldier_playAnim(' + char(39) + 'Walk' + char(39) + ',0.5,true,false,1)">Walk</button>' + HTML_LF
cControls += '<button style="' + cBtnStyle + ';background:#e74c3c;color:#fff" onclick="soldier_playAnim(' + char(39) + 'Run' + char(39) + ',0.5,true,false,1)">Run</button>' + HTML_LF
cControls += '<div style="margin-top:10px;border-top:1px solid #333;padding-top:8px">' + HTML_LF
cControls += '<div style="font-size:0.75rem;color:#888;margin-bottom:5px">Speed</div>' + HTML_LF
cControls += '<button style="' + cBtnStyle + ';background:#555;color:#fff" onclick="soldier_playSpd(0.25)">0.25x</button>' + HTML_LF
cControls += '<button style="' + cBtnStyle + ';background:#555;color:#fff" onclick="soldier_playSpd(0.5)">0.5x</button>' + HTML_LF
cControls += '<button style="' + cBtnStyle + ';background:#555;color:#fff" onclick="soldier_playSpd(1)">1x</button>' + HTML_LF
cControls += '<button style="' + cBtnStyle + ';background:#555;color:#fff" onclick="soldier_playSpd(2)">2x</button>' + HTML_LF
cControls += '</div>' + HTML_LF
cControls += '<div style="font-size:0.65rem;color:#555;margin-top:8px">Drag to orbit camera</div>'
cControls += '</div>'
oHTML.threeJSOverlay("char", cControls, [:position = "top-left"])

# Speed change helper function
oHTML.threeJSRaw("function soldier_playSpd(s) { if(soldier_currentAction) soldier_currentAction.setEffectiveTimeScale(s); }")

# Mouse orbit
oHTML.threeJSMouseLook("char", [:sensitivity = "0.004"])

oHTML.threeJSAnimate("char")

oHTML.save("model_demo2_animated.html")
? "  Created: model_demo2_animated.html"
