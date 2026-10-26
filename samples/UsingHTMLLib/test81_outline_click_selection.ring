/*
	HTMLLib Demo 81 - Outline Click Selection
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 81: Outline Click Selection
# ------------------------------------------------------------------
? "Demo 81: Outline Click Select..."

oHTML = new HTMLWriter
oHTML.setTitle("Click Selection")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableOutlinePass()
oHTML.enableCSS2DRenderer()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("out2", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "12", :camY = "5"])

# Multiple objects in a grid
aColors = ["0xe74c3c", "0x2ecc71", "0x3498db", "0xf39c12", "0x9b59b6", "0x1abc9c"]
aMeshNames = []
for nRow = 0 to 1
	for nCol = 0 to 2
		nIdx = nRow * 3 + nCol + 1
		cNm = "obj" + string(nIdx)
		add(aMeshNames, cNm)
		nPX = string((nCol - 1) * 3.5)
		nPY = "1"
		nPZ = string((nRow - 0.5) * 3.5)
		if nIdx % 3 = 1
			oHTML.threeJSBox("out2", cNm, [:x = nPX, :y = nPY, :z = nPZ, :color = aColors[nIdx]])
		but nIdx % 3 = 2
			oHTML.threeJSSphere("out2", cNm, [:x = nPX, :y = nPY, :z = nPZ, :color = aColors[nIdx], :radius = "0.8", :segments = "24"])
		else
			oHTML.threeJSTorus("out2", cNm, [:x = nPX, :y = nPY, :z = nPZ, :color = aColors[nIdx], :radius = "0.7", :tube = "0.25"])
		ok
	next
next

oHTML.threeJSPlane("out2", "out2Floor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("out2", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# CSS2D for info display
oHTML.threeJSCSS2DInit("out2")

# Outline with click
oHTML.threeJSOutlineInit("out2", [
	:edgeStrength = "5",
	:edgeGlow = "0.3",
	:edgeThickness = "1.5",
	:visibleColor = "0x00ff88"
])

cMeshStr = ""
for nIndex = 1 to len(aMeshNames)
	if nIndex > 1 cMeshStr += ", " ok
	cMeshStr += aMeshNames[nIndex]
next

oHTML.threeJSRaw("
var _clickMeshes = [" + cMeshStr + "];
var _clickRC = new THREE.Raycaster();
var _clickM = new THREE.Vector2();
selectedMesh_out2 = null;
renderer_out2.domElement.addEventListener('click', function(e) {
  var rect = renderer_out2.domElement.getBoundingClientRect();
  _clickM.x = ((e.clientX - rect.left) / rect.width) * 2 - 1;
  _clickM.y = -((e.clientY - rect.top) / rect.height) * 2 + 1;
  _clickRC.setFromCamera(_clickM, camera_out2);
  var hits = _clickRC.intersectObjects(_clickMeshes);
  if(hits.length > 0) {
    selectedMesh_out2 = hits[0].object;
    outlinePass_out2.selectedObjects = [selectedMesh_out2];
    var gType = selectedMesh_out2.geometry.type;
    document.getElementById('infoText').innerHTML = '<b>Selected:</b> ' + gType;
  } else {
    selectedMesh_out2 = null;
    outlinePass_out2.selectedObjects = [];
    document.getElementById('infoText').innerHTML = 'Click an object';
  }
});
")

oHTML.threeJSAmbientLight("out2", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("out2", "out2Lt", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("out2", [:damping = true])

oHTML.threeJSOverlay("out2", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#00ff88;font-weight:bold;font-size:1.1rem'>Click Selection</div><div id='infoText' style='font-size:0.85rem;color:#aaa;margin-top:8px'>Click an object</div><div style='font-size:0.7rem;color:#666;margin-top:8px'>Click background to deselect</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("out2")
oHTML.save("feat_demo6_click_select.html")
? "  Created: feat_demo6_click_select.html"
