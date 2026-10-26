/*
	HTMLLib Demo 85 - Maze Runner (Top-Down) Game
*/

load "htmllib.ring"

# ==================================================================
# Demo 85: Maze Runner (Top-Down) Game
# Navigate through a 3D maze to reach the exit
# Controls: WASD / Arrow keys
# ==================================================================
? "Demo 85: Maze Runner..."

oHTML = new HTMLWriter
oHTML.setTitle("Maze Runner")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

# Top-down camera
oHTML.threeJSScene("g2", [:fullscreen = true, :bg = "0x111122", :camY = "18", :camZ = "0.01"])

# Game variables
oHTML.threeJSGameVar("mazeTime", "0")
oHTML.threeJSGameVar("mazeWin", "false")
oHTML.threeJSGameVar("coins", "0")
oHTML.threeJSGameVar("totalCoins", "0")

# Player
oHTML.threeJSSphere("g2", "runner", [
	:x = "-6", :y = "0.5", :z = "-6",
	:radius = "0.35", :segments = "16",
	:color = "0x00ddff",
	:emissive = "0x004466", :emissiveIntensity = "0.6"
])

# Exit marker
oHTML.threeJSBox("g2", "exitMark", [
	:x = "6", :y = "0.3", :z = "6",
	:w = "1", :h = "0.6", :d = "1",
	:color = "0x00ff44",
	:emissive = "0x00ff44", :emissiveIntensity = "0.5",
	:transparent = true, :opacity = "0.7"
])

# Lights
oHTML.threeJSAmbientLight("g2", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("g2", "mzLt", [:x = "5", :y = "15", :z = "5", :intensity = "0.6"])
oHTML.threeJSPointLight("g2", "runnerLight", [:x = "-6", :y = "2", :z = "-6", :color = "0x00ddff", :intensity = "0.8"])

# Floor
oHTML.threeJSPlane("g2", "mzFloor", [
	:w = "16", :h = "16", :rx = "-1.5708",
	:color = "0x1a1a30"
])

# Build maze walls with JS
oHTML.addBodyScript("
var walls_g2 = [];
var wallMat = new THREE.MeshStandardMaterial({color:0x4444aa, roughness:0.8});
function addWall(x, z, w, d) {
  var geo = new THREE.BoxGeometry(w, 1.5, d);
  var wall = new THREE.Mesh(geo, wallMat);
  wall.position.set(x, 0.75, z);
  scene_g2.add(wall);
  walls_g2.push(wall);
}

// Outer walls
addWall(0, -7.5, 16, 1);  // top
addWall(0, 7.5, 16, 1);   // bottom
addWall(-7.5, 0, 1, 16);  // left
addWall(7.5, 0, 1, 16);   // right

// Internal maze walls
addWall(-4, -4, 4, 0.5);
addWall(-2, -2, 0.5, 5);
addWall(1, -5, 0.5, 4);
addWall(3, -3, 4, 0.5);
addWall(5, -1, 0.5, 4);
addWall(-5, 0, 4, 0.5);
addWall(-3, 2, 0.5, 4);
addWall(0, 1, 4, 0.5);
addWall(2, 3, 0.5, 4);
addWall(4, 2, 4, 0.5);
addWall(-5, 4, 4, 0.5);
addWall(0, 5, 0.5, 4);
addWall(-1, -1, 3, 0.5);
addWall(5, 5, 3, 0.5);
addWall(-6, 6, 0.5, 2);
addWall(3, -6, 0.5, 2);

// Coins
var coinMeshes = [];
var coinPositions = [
  [-4,-2], [-6,2], [0,-4], [4,-5], [6,0],
  [-2,4], [2,0], [-4,6], [4,4], [0,6]
];
var coinGeo = new THREE.CylinderGeometry(0.2, 0.2, 0.05, 16);
var coinMat = new THREE.MeshStandardMaterial({color:0xffdd00, emissive:0xffaa00, emissiveIntensity:0.6, metalness:0.8});
totalCoins = coinPositions.length;
for(var i = 0; i < coinPositions.length; i++) {
  var coin = new THREE.Mesh(coinGeo, coinMat);
  coin.position.set(coinPositions[i][0], 0.7, coinPositions[i][1]);
  coin.rotation.x = Math.PI/2;
  scene_g2.add(coin);
  coinMeshes.push(coin);
}
")

# Keyboard
oHTML.addBodyScript("
var mk = {};
window.addEventListener('keydown', function(e) { mk[e.key.toLowerCase()] = true; e.preventDefault(); });
window.addEventListener('keyup', function(e) { mk[e.key.toLowerCase()] = false; });
")

# Game loop
oHTML.threeJSOnAnimate("g2", "
  if(mazeWin) return;
  
  mazeTime += delta;
  
  var spd = 4 * delta;
  var nx = runner.position.x;
  var nz = runner.position.z;
  
  if(mk['w'] || mk['arrowup']) nz -= spd;
  if(mk['s'] || mk['arrowdown']) nz += spd;
  if(mk['a'] || mk['arrowleft']) nx -= spd;
  if(mk['d'] || mk['arrowright']) nx += spd;
  
  // Collision check with walls (simple AABB)
  var canMove = true;
  var pb = new THREE.Box3().setFromCenterAndSize(
    new THREE.Vector3(nx, 0.5, nz), new THREE.Vector3(0.6, 1, 0.6)
  );
  for(var i = 0; i < walls_g2.length; i++) {
    var wb = new THREE.Box3().setFromObject(walls_g2[i]);
    if(pb.intersectsBox(wb)) { canMove = false; break; }
  }
  
  if(canMove) {
    runner.position.x = nx;
    runner.position.z = nz;
  }
  
  // Light follows player
  runnerLight.position.set(runner.position.x, 2, runner.position.z);
  
  // Camera follows player (top-down)
  camera_g2.position.x = runner.position.x;
  camera_g2.position.z = runner.position.z + 0.01;
  camera_g2.lookAt(runner.position.x, 0, runner.position.z);
  
  // Collect coins
  for(var i = coinMeshes.length - 1; i >= 0; i--) {
    coinMeshes[i].rotation.z += 3 * delta;
    if(runner.position.distanceTo(coinMeshes[i].position) < 0.6) {
      scene_g2.remove(coinMeshes[i]);
      coinMeshes.splice(i, 1);
      coins++;
    }
  }
  
  // Exit pulse animation
  exitMark.rotation.y += 2 * delta;
  exitMark.scale.y = 1 + Math.sin(elapsed * 3) * 0.2;
  
  // Win check
  if(runner.position.distanceTo(exitMark.position) < 1) {
    mazeWin = true;
    document.getElementById('g2win').style.display = 'flex';
    document.getElementById('g2final').textContent = 
      'Time: ' + mazeTime.toFixed(1) + 's | Coins: ' + coins + '/' + totalCoins;
  }
  
  // Update HUD
  document.getElementById('g2time').textContent = 'Time: ' + mazeTime.toFixed(1) + 's';
  document.getElementById('g2coins').textContent = 'Coins: ' + coins + '/' + totalCoins;
")

# HUD
oHTML.threeJSOverlay("g2", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px;font-family:monospace'><div style='color:#00ddff;font-weight:bold;font-size:1.2rem'>MAZE RUNNER</div><div id='g2time' style='color:#aaa;margin-top:6px'>Time: 0.0s</div><div id='g2coins' style='color:#ffdd00;margin-top:4px'>Coins: 0/10</div><div style='color:#00ff44;font-size:0.7rem;margin-top:8px'>Reach the green exit!</div><div style='color:#555;font-size:0.7rem;margin-top:4px'>WASD / Arrows to move</div></div>", [:position = "top-left"])

# Win overlay
oHTML.addRawHTML("<div id='g2win' style='display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,50,0.85);z-index:100;justify-content:center;align-items:center'><div style='text-align:center;color:white;font-family:monospace'><div style='font-size:3rem;color:#00ff44'>YOU WIN!</div><div style='font-size:1.2rem;margin-top:10px;color:#ffdd00' id='g2final'></div><div style='margin-top:20px;color:#888;cursor:pointer' onclick='location.reload()'>Click to play again</div></div></div>")

oHTML.threeJSAnimate("g2")
oHTML.save("game2_maze_runner.html")
? "  Created: game2_maze_runner.html"
