/*
	HTMLLib Demo 65 - API Reference Card
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 65: API Reference Card
# ------------------------------------------------------------------
? "Demo 65: API Reference..."

oHTML = new HTMLWriter
oHTML.setTitle("Model Loading API Reference")
oHTML.setTheme("dark")

oHTML.addRawHTML('<div style="max-width:900px;margin:0 auto;padding:30px">')

oHTML.addHeading(1, "3D Model Loading API Reference")
oHTML.addParagraph("HTMLLib supports loading 3D models in GLTF/GLB, OBJ, FBX, and Collada formats with full animation control.")
oHTML.addHR()

# GLTF Loading
oHTML.addHeading(2, "GLTF / GLB Models")
oHTML.addCodeBlock(
	'load "htmllib.ring"' + char(10) + char(10) +
	'oHTML = new HTMLWriter' + char(10) +
	'oHTML.enableThreeJS()' + char(10) +
	'oHTML.enableGLTFLoader()' + char(10) + char(10) +
	'# Create scene' + char(10) +
	'oHTML.threeJSScene("scene", [:fullscreen = true, :shadows = true])' + char(10) +
	'oHTML.threeJSAmbientLight("scene", [:intensity = "0.5"])' + char(10) +
	'oHTML.threeJSDirectionalLight("scene", "sun", [:castShadow = true])' + char(10) + char(10) +
	'# Load model' + char(10) +
	'oHTML.threeJSLoadGLTF("scene", "myModel", "model.glb", [' + char(10) +
	'    :scale = "1", :x = "0", :y = "0", :z = "0",' + char(10) +
	'    :autoPlay = true,      # Play first animation' + char(10) +
	'    :castShadow = true' + char(10) +
	'])' + char(10) + char(10) +
	'oHTML.threeJSAnimate("scene")' + char(10) +
	'oHTML.save("output.html")', "ring")

oHTML.addSpacer("20px")

# Animation Control
oHTML.addHeading(2, "Animation Control")
oHTML.addCodeBlock(
	'# Play a specific animation with crossfade' + char(10) +
	'oHTML.threeJSPlayAnimation("hero", "Run", [' + char(10) +
	'    :fadeDuration = "0.5",' + char(10) +
	'    :loop = true,' + char(10) +
	'    :timeScale = "1.5"' + char(10) +
	'])' + char(10) + char(10) +
	'# Speed control' + char(10) +
	'oHTML.threeJSAnimationSpeed("hero", "2.0")' + char(10) + char(10) +
	'# Pause / Resume' + char(10) +
	'oHTML.threeJSPauseAnimation("hero")' + char(10) +
	'oHTML.threeJSResumeAnimation("hero")' + char(10) + char(10) +
	'# Stop all animations' + char(10) +
	'oHTML.threeJSStopAnimations("hero")' + char(10) + char(10) +
	'# Load separate animation files' + char(10) +
	'oHTML.threeJSLoadAnimation("hero", "dance", "dance.fbx", [:format = "fbx"])' + char(10) + char(10) +
	'# Run code when animation finishes' + char(10) +
	'oHTML.threeJSOnAnimationFinished("hero", "console.log(' + char(39) + 'Done!' + char(39) + ')")', "ring")

oHTML.addSpacer("20px")

# State Machine
oHTML.addHeading(2, "Animation State Machine")
oHTML.addCodeBlock(
	'# Define states and transitions for keyboard-driven character' + char(10) +
	'oHTML.threeJSAnimStateMachine("scene", "hero", [' + char(10) +
	'    ["idle", "Idle", [:loop = true, :fadeDuration = "0.3"]],' + char(10) +
	'    ["walk", "Walk", [:loop = true, :fadeDuration = "0.3"]],' + char(10) +
	'    ["run",  "Run",  [:loop = true, :timeScale = "1.2"]]' + char(10) +
	'], [' + char(10) +
	'    # [fromState, toState, jsCondition]' + char(10) +
	"    [" + char(34) + "idle" + char(34) + ", " + char(34) + "walk" + char(34) + ", " + char(34) + "k['w']||k['a']||k['s']||k['d']" + char(34) + "]," + char(10) +
	"    [" + char(34) + "walk" + char(34) + ", " + char(34) + "idle" + char(34) + ", " + char(34) + "!k['w']&&!k['a']&&!k['s']&&!k['d']" + char(34) + "]," + char(10) +
	"    [" + char(34) + "walk" + char(34) + ", " + char(34) + "run" + char(34) + ", " + char(34) + "k['shift']" + char(34) + "]," + char(10) +
	"    [" + char(34) + "run" + char(34) + ", " + char(34) + "walk" + char(34) + ", " + char(34) + "!k['shift']" + char(34) + "]" + char(10) +
	'])', "ring")

oHTML.addSpacer("20px")

# Supported Formats
oHTML.addHeading(2, "Supported Model Formats")

oHTML.addTableStyled([
	["Format", "Extensions", "Enable Method", "Load Method", "Animations"],
	["GLTF/GLB", ".gltf, .glb", "enableGLTFLoader()", "threeJSLoadGLTF()", "Yes (skeletal)"],
	["OBJ", ".obj (+.mtl)", "enableOBJLoader()", "threeJSLoadOBJ()", "No"],
	["FBX", ".fbx", "enableFBXLoader()", "threeJSLoadFBX()", "Yes (skeletal)"],
	["Collada", ".dae", "enableColladaLoader()", "threeJSLoadCollada()", "Yes"]
], [:class = "table"])

oHTML.addSpacer("20px")

# Complete method list
oHTML.addHeading(2, "Complete Method Reference")

oHTML.addTableStyled([
	["Method", "Description"],
	["enableGLTFLoader()", "Load GLTF/GLB loader from CDN"],
	["enableOBJLoader()", "Load OBJ loader from CDN"],
	["enableMTLLoader()", "Load MTL material loader"],
	["enableFBXLoader()", "Load FBX loader + fflate decompressor"],
	["enableColladaLoader()", "Load Collada loader"],
	["enableDracoDecoder()", "Enable Draco mesh compression"],
	["threeJSLoadGLTF()", "Load a GLTF/GLB model with options"],
	["threeJSLoadOBJ()", "Load an OBJ model (optional MTL)"],
	["threeJSLoadFBX()", "Load an FBX model with animations"],
	["threeJSLoadCollada()", "Load a Collada (.dae) model"],
	["threeJSPlayAnimation()", "Play/crossfade to named animation"],
	["threeJSStopAnimations()", "Stop all animations"],
	["threeJSAnimationSpeed()", "Set playback speed"],
	["threeJSPauseAnimation()", "Pause current animation"],
	["threeJSResumeAnimation()", "Resume paused animation"],
	["threeJSAnimStateMachine()", "Keyboard-driven animation states"],
	["threeJSLoadAnimation()", "Load additional animation file"],
	["threeJSOnAnimationFinished()", "Callback when animation ends"],
	["threeJSLogAnimations()", "Log animation names to console"],
	["threeJSLoadingScreen()", "Add loading overlay with spinner"],
	["threeJSHideLoading()", "Fade out loading overlay"]
], [:class = "table"])

oHTML.addRawHTML('</div>')

oHTML.save("model_demo6_reference.html")
? "  Created: model_demo6_reference.html"
