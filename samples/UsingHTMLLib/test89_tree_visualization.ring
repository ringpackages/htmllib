/*
	HTMLLib Demo 89 - 3D Tree Visualizer

	Takes a Ring nested list (tree data) and renders it as a
	3D interactive tree with nodes, labels, and connections.

	Tree format:  [ "name", [children] ]
	Each child is:  [ "name" ]              (leaf)
	                 [ "name", [children] ]  (branch)

	Demo 5 uses a procedurally generated 2000-node tree
	rendered with InstancedMesh for GPU performance.
*/

load "htmllib.ring"

# -------------------------------------------------------
# Global accumulators for the layout pass
# -------------------------------------------------------
aNodeList  = []
aEdgeList  = []
nNodeCount = 0

# -------------------------------------------------------
# Tree Data
# -------------------------------------------------------

# Example 1: Programming Language Family Tree
aTree1 = [
	"Programming" , [
		["Systems", [
			["C"],
			["C++", [
				["Rust"],
				["D"]
			]],
			["Assembly"]
		]],
		["Scripting", [
			["Python", [
				["NumPy"],
				["Django"]
			]],
			["Ring", [
				["RingQt"],
				["RingAllegro"],
				["HTMLLib"]
			]],
			["JavaScript", [
				["Node.js"],
				["React"]
			]]
		]],
		["Functional", [
			["Haskell"],
			["Lisp", [
				["Scheme"],
				["Clojure"]
			]],
			["Erlang"]
		]]
	]
]

# Example 2: Company Organization
aTree2 = [
	"CEO", [
		["CTO", [
			["Dev Lead", [
				["Frontend"],
				["Backend"],
				["DevOps"]
			]],
			["QA Lead", [
				["Testing"],
				["Automation"]
			]]
		]],
		["CFO", [
			["Accounting"],
			["Finance", [
				["Budgets"],
				["Audits"]
			]]
		]],
		["COO", [
			["HR", [
				["Recruiting"],
				["Training"]
			]],
			["Operations"],
			["Legal"]
		]]
	]
]

# Example 3: File System
aTree3 = [
	"/home", [
		["Documents", [
			["Reports", [
				["Q1.pdf"],
				["Q2.pdf"]
			]],
			["Letters"]
		]],
		["Projects", [
			["HTMLLib", [
				["src", [
					["htmllib.ring"],
					["demos"]
				]],
				["docs"],
				["tests"]
			]],
			["WebApp", [
				["index.html"],
				["style.css"],
				["app.js"]
			]]
		]],
		["Photos", [
			["2024"],
			["2025"]
		]]
	]
]

# Example 4: Ring Language Features
aTree4 = [
	"Ring Language", [
		["Core", [
			["Variables", [
				["Numbers"],
				["Strings"],
				["Lists"],
				["Objects"]
			]],
			["Control", [
				["if/elseif/else"],
				["for/next"],
				["while/end"],
				["switch/on"]
			]],
			["Functions", [
				["User-Defined"],
				["Anonymous"],
				["Variadic"]
			]],
			["OOP", [
				["Classes"],
				["Inheritance"],
				["Polymorphism"],
				["Packages"]
			]]
		]],
		["Libraries", [
			["RingQt", [
				["Widgets"],
				["Dialogs"],
				["Graphics"]
			]],
			["RingAllegro", [
				["2D Games"],
				["Audio"],
				["Input"]
			]],
			["WebLib"],
			["HTMLLib", [
				["HTML5/CSS3"],
				["Bootstrap"],
				["Three.js"],
				["JavaScript"]
			]]
		]],
		["Tools", [
			["Ring Notepad"],
			["Form Designer"],
			["Package Manager"]
		]]
	]
]


# ============================================================
# Generate Demos 1-4 (normal-sized trees)
# ============================================================

# ---- Demo 1: Programming Languages ----
? "Building Demo 1: Programming Language Family Tree..."

oHTML1 = new HTMLWriter
oHTML1.setTitle("3D Tree - Programming Languages")
oHTML1.enableThreeJS()
oHTML1.enableOrbitControls()
oHTML1.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

buildTreeViz(oHTML1, "tv1", aTree1, "Programming Languages", 3.2)
oHTML1.save("tree_demo1_languages.html")
? "  Saved: tree_demo1_languages.html  (nodes: " + len(aNodeList) + ")"


# ---- Demo 2: Organization Chart ----
? "Building Demo 2: Organization Chart..."

oHTML2 = new HTMLWriter
oHTML2.setTitle("3D Tree - Organization")
oHTML2.enableThreeJS()
oHTML2.enableOrbitControls()
oHTML2.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

buildTreeViz(oHTML2, "tv2", aTree2, "Organization Chart", 3.0)
oHTML2.save("tree_demo2_org.html")
? "  Saved: tree_demo2_org.html  (nodes: " + len(aNodeList) + ")"


# ---- Demo 3: File System ----
? "Building Demo 3: File System Tree..."

oHTML3 = new HTMLWriter
oHTML3.setTitle("3D Tree - File System")
oHTML3.enableThreeJS()
oHTML3.enableOrbitControls()
oHTML3.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

buildTreeViz(oHTML3, "tv3", aTree3, "File System", 3.0)
oHTML3.save("tree_demo3_filesystem.html")
? "  Saved: tree_demo3_filesystem.html  (nodes: " + len(aNodeList) + ")"


# ---- Demo 4: Ring Language Features ----
? "Building Demo 4: Ring Language Features..."

oHTML4 = new HTMLWriter
oHTML4.setTitle("3D Tree - Ring Language")
oHTML4.enableThreeJS()
oHTML4.enableOrbitControls()
oHTML4.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

buildTreeViz(oHTML4, "tv4", aTree4, "Ring Language", 2.6)
oHTML4.save("tree_demo4_ring.html")
? "  Saved: tree_demo4_ring.html  (nodes: " + len(aNodeList) + ")"


# ============================================================
# Demo 5: MASSIVE 2000-NODE TREE
# ============================================================
# Uses InstancedMesh for GPU-efficient rendering
# Tree is generated procedurally in JS from data built in Ring
# ============================================================

? "Building Demo 5: Large Tree (2000 nodes)..."

oHTML5 = new HTMLWriter
oHTML5.setTitle("3D Tree - 2000 Nodes")
oHTML5.enableThreeJS()
oHTML5.enableOrbitControls()
oHTML5.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

# Build a large tree in Ring: 2000+ nodes
# Structure: Root -> 8 departments -> each has 5 teams -> each has 5 groups -> each has ~10 items
aBigTree = ["World", []]
aDepts = ["Science", "Technology", "Engineering", "Arts", "Mathematics", "Medicine", "Business", "Education"]

for nDept = 1 to len(aDepts)
	aDept = [aDepts[nDept], []]
	aTeams = ["Division-A", "Division-B", "Division-C", "Division-D", "Division-E"]
	for nTeam = 1 to len(aTeams)
		aTeam = [aDepts[nDept] + "-" + aTeams[nTeam], []]
		aGroups = ["Unit-1", "Unit-2", "Unit-3", "Unit-4", "Unit-5"]
		for nGroup = 1 to len(aGroups)
			aGroup = [aTeams[nTeam] + "-" + aGroups[nGroup], []]
			for nItem = 1 to 10
				add(aGroup[2], ["Item-" + nDept + "" + nTeam + "" + nGroup + "" + nItem])
			next
			add(aTeam[2], aGroup)
		next
		add(aDept[2], aTeam)
	next
	add(aBigTree[2], aDept)
next

# Count nodes in the big tree
nBigCount = countTreeNodes(aBigTree)
? "  Big tree has " + nBigCount + " nodes"

# Layout the tree in Ring (VERTICAL layout for large tree)
aNodeList  = []
aEdgeList  = []
nNodeCount = 0
layoutTreeVertical(aBigTree, 0, 0, 0, 0, 0, 1.2)

? "  Layout complete: " + len(aNodeList) + " nodes, " + len(aEdgeList) + " edges"

# Build JSON arrays of node data for JS to consume
# Instead of creating 2000 individual meshes, pass data to JS
# and use InstancedMesh + BufferGeometry lines

cNodeDataJS = "var treeNodes = [" + char(10)
for nIndex = 1 to len(aNodeList)
	nNX = aNodeList[nIndex][2]
	nNY = aNodeList[nIndex][3]
	nNZ = aNodeList[nIndex][4]
	nDepth = aNodeList[nIndex][5]
	nPIdx = aNodeList[nIndex][6]
	cNm = aNodeList[nIndex][1]
	cNodeDataJS += "  [" + nNX + "," + nNY + "," + nNZ + "," + nDepth + "," + nPIdx + "]"
	if nIndex < len(aNodeList)
		cNodeDataJS += ","
	ok
	cNodeDataJS += char(10)
next
cNodeDataJS += "];" + char(10)

cEdgeDataJS = "var treeEdges = [" + char(10)
for nIndex = 1 to len(aEdgeList)
	cEdgeDataJS += "  [" + aEdgeList[nIndex][1] + "," + aEdgeList[nIndex][2] + "]"
	if nIndex < len(aEdgeList)
		cEdgeDataJS += ","
	ok
	cEdgeDataJS += char(10)
next
cEdgeDataJS += "];" + char(10)

# Now build the scene (camera positioned to see tall vertical tree)
oHTML5.threeJSScene("big", [
	:fullscreen = true,
	:bg = "0x050510",
	:camX = "0", :camY = "0", :camZ = "100"
])

oHTML5.threeJSAmbientLight("big", [:intensity = "0.5"])
oHTML5.threeJSDirectionalLight("big", "bigLt1", [
	:x = "30", :y = "30", :z = "30", :intensity = "0.6"
])
oHTML5.threeJSDirectionalLight("big", "bigLt2", [
	:x = "-30", :y = "20", :z = "-15", :intensity = "0.3"
])

oHTML5.threeJSOrbitControls("big", [:damping = true])

# Inject the node/edge data
oHTML5.addBodyScript(cNodeDataJS)
oHTML5.addBodyScript(cEdgeDataJS)

# Depth color palette for JS
oHTML5.addBodyScript("
var depthColors = [
  0xff4466, 0xff8833, 0xffcc00, 0x44dd66,
  0x33aaff, 0xaa66ff, 0xff66aa
];
function getDepthColor(d) {
  return depthColors[d % depthColors.length];
}
")

# Build nodes using InstancedMesh (one draw call for all 2000 spheres)
oHTML5.addBodyScript("
var nodeCount = treeNodes.length;

// InstancedMesh for all nodes
var nodeGeo = new THREE.SphereGeometry(0.25, 10, 8);
var nodeMat = new THREE.MeshStandardMaterial({metalness:0.4, roughness:0.3});
var nodeIM = new THREE.InstancedMesh(nodeGeo, nodeMat, nodeCount);
var _dummy = new THREE.Object3D();
var _color = new THREE.Color();

for(var i = 0; i < nodeCount; i++) {
  var nd = treeNodes[i];
  var px = nd[0], py = nd[1], pz = nd[2], depth = nd[3];
  
  _dummy.position.set(px, py, pz);
  // Scale by depth level
  var sc = depth === 0 ? 6.0 : depth === 1 ? 4.0 : depth === 2 ? 2.5 : depth === 3 ? 1.5 : 1.0;
  _dummy.scale.set(sc, sc, sc);
  _dummy.updateMatrix();
  nodeIM.setMatrixAt(i, _dummy.matrix);
  
  _color.setHex(getDepthColor(depth));
  nodeIM.setColorAt(i, _color);
}
nodeIM.instanceMatrix.needsUpdate = true;
nodeIM.instanceColor.needsUpdate = true;
scene_big.add(nodeIM);
")

# Build all edges as a single LineSegments geometry (one draw call)
oHTML5.addBodyScript("
var edgeVerts = [];
for(var i = 0; i < treeEdges.length; i++) {
  var pIdx = treeEdges[i][0] - 1;  // Ring is 1-based
  var cIdx = treeEdges[i][1] - 1;
  var pn = treeNodes[pIdx];
  var cn = treeNodes[cIdx];
  
  var px = pn[0], py = pn[1], pz = pn[2];
  var cx = cn[0], cy = cn[1], cz = cn[2];
  var my = (py + cy) / 2;
  
  // L-shaped: parent down -> across -> child down
  // Segment 1: parent to mid-Y
  edgeVerts.push(px, py, pz, px, my, pz);
  // Segment 2: mid across
  edgeVerts.push(px, my, pz, cx, my, cz);
  // Segment 3: mid down to child
  edgeVerts.push(cx, my, cz, cx, cy, cz);
}

var edgeGeo = new THREE.BufferGeometry();
edgeGeo.setAttribute('position', new THREE.Float32BufferAttribute(edgeVerts, 3));
var edgeMat = new THREE.LineBasicMaterial({color:0x445577, transparent:true, opacity:0.5});
var edgeMesh = new THREE.LineSegments(edgeGeo, edgeMat);
scene_big.add(edgeMesh);
")

# Add labels for ALL nodes - node number and name
# Build name data as JS array from Ring
cNodeNamesJS = "var treeNames = [" + char(10)
for nIndex = 1 to len(aNodeList)
	cNm = aNodeList[nIndex][1]
	cNodeNamesJS += '  "' + cNm + '"'
	if nIndex < len(aNodeList)
		cNodeNamesJS += ","
	ok
	cNodeNamesJS += char(10)
next
cNodeNamesJS += "];" + char(10)
oHTML5.addBodyScript(cNodeNamesJS)

oHTML5.addBodyScript("
// Label helpers
function makeLabelTexture(text, color, fs) {
  var canvas = document.createElement('canvas');
  var ctx = canvas.getContext('2d');
  ctx.font = 'bold ' + fs + 'px monospace';
  var tw = ctx.measureText(text).width + 16;
  canvas.width = Math.max(tw, 48);
  canvas.height = fs + 12;
  ctx.fillStyle = 'rgba(0,0,0,0.85)';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.strokeStyle = color;
  ctx.lineWidth = 2;
  ctx.strokeRect(1, 1, canvas.width-2, canvas.height-2);
  ctx.font = 'bold ' + fs + 'px monospace';
  ctx.fillStyle = color;
  ctx.textBaseline = 'middle';
  ctx.fillText(text, 8, canvas.height/2);
  return {canvas: canvas, tex: new THREE.CanvasTexture(canvas), w: canvas.width, h: canvas.height};
}

var labelColors = ['#ff4466','#ff8833','#ffcc00','#44dd66','#33aaff','#aa66ff','#ff66aa'];

for(var i = 0; i < nodeCount; i++) {
  var nd = treeNodes[i];
  var depth = nd[3];
  var labelText = '#' + (i+1) + ' ' + treeNames[i];
  var col = labelColors[depth % labelColors.length];
  var fs = depth <= 1 ? 36 : 28;
  var info = makeLabelTexture(labelText, col, fs);
  
  if(depth >= 3) {
    // Deep labels: use a Plane mesh rotated 90 degrees (vertical text)
    var sc = depth === 3 ? 0.5 : 0.4;
    var pw = info.w / info.h * sc;
    var ph = sc;
    var geo = new THREE.PlaneGeometry(pw, ph);
    var mat = new THREE.MeshBasicMaterial({map: info.tex, transparent: true, side: THREE.DoubleSide});
    var mesh = new THREE.Mesh(geo, mat);
    mesh.position.set(nd[0], nd[1] - pw/2 - 0.4, nd[2]);
    // Rotate 90 degrees so the label reads top-to-bottom
    mesh.rotation.z = -Math.PI / 2;
    scene_big.add(mesh);
  } else {
    // Shallow labels: use Sprite (always faces camera)
    var mat = new THREE.SpriteMaterial({map: info.tex, transparent: true});
    var sprite = new THREE.Sprite(mat);
    var sc = depth === 0 ? 2.0 : depth === 1 ? 1.4 : 0.9;
    sprite.scale.set(info.w / info.h * sc, sc, 1);
    var yOff = depth === 0 ? -2.0 : depth === 1 ? -1.2 : -0.8;
    sprite.position.set(nd[0], nd[1] + yOff, nd[2]);
    scene_big.add(sprite);
  }
}
")


# HUD
nNodeTotal = len(aNodeList)
nEdgeTotal = len(aEdgeList)
nLeafCount = 0
nMaxD = 0
for nIndex = 1 to len(aNodeList)
	if aNodeList[nIndex][5] > nMaxD nMaxD = aNodeList[nIndex][5] ok
	lIsLeaf = true
	for nEdge = 1 to len(aEdgeList)
		if aEdgeList[nEdge][1] = nIndex lIsLeaf = false exit ok
	next
	if lIsLeaf nLeafCount++ ok
next

cHudTxt = "<div style='background:rgba(0,0,0,0.8);padding:15px 20px;border-radius:10px;font-family:monospace'>"
cHudTxt += "<div style='color:#ff4466;font-weight:bold;font-size:1.2rem'>MASSIVE TREE</div>"
cHudTxt += "<div style='color:#aaa;font-size:0.75rem;margin-top:8px;line-height:1.7'>"
cHudTxt += "Nodes: <span style='color:#fff'>" + nNodeTotal + "</span><br>"
cHudTxt += "Edges: <span style='color:#fff'>" + nEdgeTotal + "</span><br>"
cHudTxt += "Leaves: <span style='color:#fff'>" + nLeafCount + "</span><br>"
cHudTxt += "Depth: <span style='color:#fff'>" + nMaxD + "</span><br>"
cHudTxt += "<br><span style='color:#33aaff'>InstancedMesh rendering</span><br>"
cHudTxt += "<span style='color:#33aaff'>LineSegments (one draw call)</span><br>"
cHudTxt += "<br><span style='color:#666'>Mouse: orbit / zoom</span><br>"
cHudTxt += "<span style='color:#666'>Arrows: scroll up/down/left/right</span><br>"
cHudTxt += "<span style='color:#666'>W/S: zoom in/out</span>"
cHudTxt += "</div></div>"

oHTML5.threeJSOverlay("big", cHudTxt, [:position = "top-left"])

# Keyboard navigation - arrows to scroll, W/S to zoom
oHTML5.addBodyScript("
var navKeys = {};
window.addEventListener('keydown', function(e) { 
  navKeys[e.key.toLowerCase()] = true; 
  if(['arrowup','arrowdown','arrowleft','arrowright'].indexOf(e.key.toLowerCase()) >= 0) {
    e.preventDefault();
  }
});
window.addEventListener('keyup', function(e) { navKeys[e.key.toLowerCase()] = false; });
")

oHTML5.threeJSOnAnimate("big", "
  var scrollSpeed = 80 * delta;
  var zoomSpeed = 60 * delta;
  var k = navKeys;
  
  // Arrow keys move camera + target together (scroll/pan)
  if(k['arrowup']) {
    camera_big.position.y += scrollSpeed;
    controls_big.target.y += scrollSpeed;
  }
  if(k['arrowdown']) {
    camera_big.position.y -= scrollSpeed;
    controls_big.target.y -= scrollSpeed;
  }
  if(k['arrowleft']) {
    camera_big.position.x -= scrollSpeed;
    controls_big.target.x -= scrollSpeed;
  }
  if(k['arrowright']) {
    camera_big.position.x += scrollSpeed;
    controls_big.target.x += scrollSpeed;
  }
  
  // W/S to zoom in/out (move camera along Z)
  if(k['w']) {
    camera_big.position.z -= zoomSpeed;
  }
  if(k['s']) {
    camera_big.position.z += zoomSpeed;
    camera_big.position.z = Math.min(camera_big.position.z, 500);
  }
  
  controls_big.update();
")

oHTML5.threeJSAnimate("big")
oHTML5.save("tree_demo5_large_2000.html")
? "  Saved: tree_demo5_large_2000.html"


# ---- Summary ----
? ""
? "All tree visualizations generated!"
? "  1. tree_demo1_languages.html     - Programming language families"
? "  2. tree_demo2_org.html           - Company organization chart"
? "  3. tree_demo3_filesystem.html    - File system hierarchy"
? "  4. tree_demo4_ring.html          - Ring language features"
? "  5. tree_demo5_large_2000.html    - 2000+ node massive tree"
? ""
? "Features used:"
? "  Demos 1-4: threeJSSphere, threeJSBox, threeJSLine, threeJSTextSprite"
? "  Demo 5:    InstancedMesh, LineSegments, sprite labels (GPU-optimized)"


# ============================================================
# ALL FUNCTIONS BELOW
# (Ring requires: statements first, then functions/classes)
# ============================================================

# -------------------------------------------------------
# Count leaves in a subtree (for width calculation)
# -------------------------------------------------------
func countLeaves aTree
	if len(aTree) = 1
		return 1
	ok
	aChildren = aTree[2]
	nTotal = 0
	for nIndex = 1 to len(aChildren)
		nTotal += countLeaves(aChildren[nIndex])
	next
	return nTotal

# -------------------------------------------------------
# Count all nodes in a tree
# -------------------------------------------------------
func countTreeNodes aTree
	nCount = 1
	if len(aTree) > 1
		aChildren = aTree[2]
		for nIndex = 1 to len(aChildren)
			nCount += countTreeNodes(aChildren[nIndex])
		next
	ok
	return nCount

# -------------------------------------------------------
# Recursively layout the tree - assigns X, Y positions
# -------------------------------------------------------
func layoutTree aTree, nCX, nCY, nCZ, nDepth, nParentIdx, nSpacing
	nNodeCount++
	nIdx = nNodeCount
	cName = aTree[1]

	add(aNodeList, [cName, nCX, nCY, nCZ, nDepth, nParentIdx])

	if nParentIdx > 0
		add(aEdgeList, [nParentIdx, nIdx])
	ok

	if len(aTree) > 1
		aChildren = aTree[2]
		nChildren = len(aChildren)

		aChildWidths = []
		nTotalLeaves = 0
		for nIndex = 1 to nChildren
			nLeaves = countLeaves(aChildren[nIndex])
			add(aChildWidths, nLeaves)
			nTotalLeaves += nLeaves
		next

		nChildY = nCY - 3
		nChildSpacing = nSpacing * 0.82
		nTotalWidth = nTotalLeaves * nChildSpacing
		nCurrentX = nCX - nTotalWidth / 2

		for nIndex = 1 to nChildren
			nChildWidth = aChildWidths[nIndex] * nChildSpacing
			nChildCX = nCurrentX + nChildWidth / 2
			nChildCZ = nCZ

			layoutTree(aChildren[nIndex], nChildCX, nChildY, nChildCZ, nDepth + 1, nIdx, nChildSpacing)

			nCurrentX += nChildWidth
		next
	ok

# -------------------------------------------------------
# Vertical layout for large trees
# Grows DOWNWARD with large Y gaps, tight X spread
# -------------------------------------------------------
func layoutTreeVertical aTree, nCX, nCY, nCZ, nDepth, nParentIdx, nSpacing
	nNodeCount++
	nIdx = nNodeCount
	cName = aTree[1]

	add(aNodeList, [cName, nCX, nCY, nCZ, nDepth, nParentIdx])

	if nParentIdx > 0
		add(aEdgeList, [nParentIdx, nIdx])
	ok

	if len(aTree) > 1
		aChildren = aTree[2]
		nChildren = len(aChildren)

		aChildWidths = []
		nTotalLeaves = 0
		for nIndex = 1 to nChildren
			nLeaves = countLeaves(aChildren[nIndex])
			add(aChildWidths, nLeaves)
			nTotalLeaves += nLeaves
		next

		# Very large vertical gap (tree grows TALL)
		nChildY = nCY - 80
		# Tight horizontal spacing (tree stays NARROW)
		nChildSpacing = nSpacing * 0.9
		nTotalWidth = nTotalLeaves * nChildSpacing
		nCurrentX = nCX - nTotalWidth / 2

		for nIndex = 1 to nChildren
			nChildWidth = aChildWidths[nIndex] * nChildSpacing
			nChildCX = nCurrentX + nChildWidth / 2
			nChildCZ = nCZ

			layoutTreeVertical(aChildren[nIndex], nChildCX, nChildY, nChildCZ, nDepth + 1, nIdx, nChildSpacing)

			nCurrentX += nChildWidth
		next
	ok

# -------------------------------------------------------
# Depth-based color palettes
# -------------------------------------------------------
func getNodeColor nDepth
	aColors = [
		"0xff4466", "0xff8833", "0xffcc00", "0x44dd66",
		"0x33aaff", "0xaa66ff", "0xff66aa"
	]
	nIdx = (nDepth % len(aColors)) + 1
	return aColors[nIdx]

func getEmissiveColor nDepth
	aColors = [
		"0x661122", "0x663311", "0x665500", "0x116622",
		"0x114466", "0x442266", "0x662244"
	]
	nIdx = (nDepth % len(aColors)) + 1
	return aColors[nIdx]

func getEdgeColor nDepth
	aColors = [
		"0xff6688", "0xffaa55", "0xffdd44", "0x66ee88",
		"0x55bbff", "0xbb88ff", "0xff88bb"
	]
	nIdx = (nDepth % len(aColors)) + 1
	return aColors[nIdx]

# -------------------------------------------------------
# Max helper
# -------------------------------------------------------
func myMax nA, nB
	if nA > nB return nA ok
	return nB

# -------------------------------------------------------
# Build tree visualization for normal-sized trees (< 200 nodes)
# Uses individual meshes, lines, and text sprites
# -------------------------------------------------------
func buildTreeViz oHTML, cCanvasId, aTree, cTitle, nSpacing

	# Reset globals
	aNodeList  = []
	aEdgeList  = []
	nNodeCount = 0

	# Layout the tree
	layoutTree(aTree, 0, 8, 0, 0, 0, nSpacing)

	# Scene setup
	oHTML.threeJSScene(cCanvasId, [
		:fullscreen = true,
		:bg = "0x0a0a1a",
		:camX = "0", :camY = "5", :camZ = "25"
	])

	# Lights
	oHTML.threeJSAmbientLight(cCanvasId, [:intensity = "0.4"])
	oHTML.threeJSDirectionalLight(cCanvasId, cCanvasId + "Lt1", [
		:x = "10", :y = "15", :z = "10", :intensity = "0.6"
	])
	oHTML.threeJSDirectionalLight(cCanvasId, cCanvasId + "Lt2", [
		:x = "-10", :y = "10", :z = "-5", :intensity = "0.3"
	])

	# Draw edges (L-shaped connectors)
	for nIndex = 1 to len(aEdgeList)
		nPIdx = aEdgeList[nIndex][1]
		nCIdx = aEdgeList[nIndex][2]

		nPX = "" + aNodeList[nPIdx][2]
		nPY = "" + aNodeList[nPIdx][3]
		nPZ = "" + aNodeList[nPIdx][4]

		nChildX = "" + aNodeList[nCIdx][2]
		nChildY = "" + aNodeList[nCIdx][3]
		nChildZ = "" + aNodeList[nCIdx][4]

		nMidY = "" + ( (0+aNodeList[nPIdx][3] + 0+aNodeList[nCIdx][3]) / 2 )

		cEdgeName = cCanvasId + "e" + nIndex
		cEdgeCol = getEdgeColor(aNodeList[nPIdx][5])

		oHTML.threeJSLine(cCanvasId, cEdgeName + "a", [
			[nPX, nPY, nPZ],
			[nPX, nMidY, nPZ]
		], [:color = cEdgeCol])

		oHTML.threeJSLine(cCanvasId, cEdgeName + "b", [
			[nPX, nMidY, nPZ],
			[nChildX, nMidY, nChildZ]
		], [:color = cEdgeCol])

		oHTML.threeJSLine(cCanvasId, cEdgeName + "c", [
			[nChildX, nMidY, nChildZ],
			[nChildX, nChildY, nChildZ]
		], [:color = cEdgeCol])
	next

	# Draw nodes
	for nIndex = 1 to len(aNodeList)
		cName  = aNodeList[nIndex][1]
		nNX    = "" + aNodeList[nIndex][2]
		nNY    = "" + aNodeList[nIndex][3]
		nNZ    = "" + aNodeList[nIndex][4]
		nDepth = aNodeList[nIndex][5]

		cNodeName = cCanvasId + "n" + nIndex
		cNodeCol = getNodeColor(nDepth)
		cNodeEmis = getEmissiveColor(nDepth)

		if nDepth = 0
			oHTML.threeJSSphere(cCanvasId, cNodeName, [
				:x = nNX, :y = nNY, :z = nNZ,
				:radius = "0.6", :segments = "20",
				:color = cNodeCol,
				:emissive = cNodeEmis, :emissiveIntensity = "0.4",
				:metalness = "0.4", :roughness = "0.3"
			])
		but nDepth = 1
			oHTML.threeJSBox(cCanvasId, cNodeName, [
				:x = nNX, :y = nNY, :z = nNZ,
				:w = "0.9", :h = "0.9", :d = "0.9",
				:color = cNodeCol,
				:emissive = cNodeEmis, :emissiveIntensity = "0.3",
				:metalness = "0.3", :roughness = "0.4"
			])
		else
			cSize = "" + myMax(0.3, 0.55 - nDepth * 0.06)
			oHTML.threeJSSphere(cCanvasId, cNodeName, [
				:x = nNX, :y = nNY, :z = nNZ,
				:radius = cSize, :segments = "12",
				:color = cNodeCol,
				:emissive = cNodeEmis, :emissiveIntensity = "0.3",
				:metalness = "0.5", :roughness = "0.3"
			])
		ok

		# Text label below node
		cLabelName = cCanvasId + "lbl" + nIndex
		nLabelY = "" + (0+aNodeList[nIndex][3] - 0.6)
		oHTML.threeJSTextSprite(cCanvasId, cLabelName, cName, [
			:x = nNX, :y = nLabelY, :z = nNZ,
			:color = "#ffffff",
			:bgColor = "rgba(0,0,0,0.6)",
			:fontSize = "32",
			:scale = "0.8",
			:padding = "8"
		])
	next

	# Orbit controls
	oHTML.threeJSOrbitControls(cCanvasId, [:damping = true])

	# Gentle float animation
	oHTML.threeJSOnAnimate(cCanvasId, "
        var t = elapsed;
        for(var i = 0; i < scene_" + cCanvasId + ".children.length; i++) {
            var obj = scene_" + cCanvasId + ".children[i];
            if(obj.isMesh && obj.geometry.type && obj.geometry.type.indexOf('Sphere') >= 0) {
                obj.position.y += Math.sin(t * 1.5 + i * 0.3) * 0.001;
            }
        }
    ")

	# HUD with stats
	nNodeTotal = len(aNodeList)
	nEdgeTotal = len(aEdgeList)
	nLeafCount = 0
	nMaxDepth = 0
	for nIndex = 1 to len(aNodeList)
		if aNodeList[nIndex][5] > nMaxDepth nMaxDepth = aNodeList[nIndex][5] ok
		lIsLeaf = true
		for nEdge = 1 to len(aEdgeList)
			if aEdgeList[nEdge][1] = nIndex lIsLeaf = false exit ok
		next
		if lIsLeaf nLeafCount++ ok
	next

	cHudHTML = "<div style='background:rgba(0,0,0,0.75);padding:15px 20px;border-radius:10px;font-family:monospace'>"
	cHudHTML += "<div style='color:" + getNodeColor(0) + ";font-weight:bold;font-size:1.2rem'>" + cTitle + "</div>"
	cHudHTML += "<div style='color:#aaa;font-size:0.75rem;margin-top:8px;line-height:1.7'>"
	cHudHTML += "Root: <span style='color:#fff'>" + aTree[1] + "</span><br>"
	cHudHTML += "Nodes: <span style='color:#fff'>" + nNodeTotal + "</span><br>"
	cHudHTML += "Edges: <span style='color:#fff'>" + nEdgeTotal + "</span><br>"
	cHudHTML += "Leaves: <span style='color:#fff'>" + nLeafCount + "</span><br>"
	cHudHTML += "Depth: <span style='color:#fff'>" + nMaxDepth + "</span><br>"
	cHudHTML += "<br><span style='color:#666'>Mouse: orbit / zoom</span>"
	cHudHTML += "</div></div>"

	oHTML.threeJSOverlay(cCanvasId, cHudHTML, [:position = "top-left"])

	# Animate
	oHTML.threeJSAnimate(cCanvasId)

	return oHTML
