/*
	HTMLLib Demo 87 - Ball Collector Game
*/

load "htmllib.ring"

# ==================================================================
# Demo 87: Ball Collector Game
# Roll a ball on terrain, collect gems, avoid holes
# Controls: WASD / Arrow keys
# ==================================================================
? "Demo 87: Ball Collector..."

oHTML = new HTMLWriter
oHTML.setTitle("Ball Collector")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("g4", [:fullscreen = true, :bg = "0x445566", :camX = "0", :camY = "12", :camZ = "10"])

# Game vars
oHTML.threeJSGameVar("bcScore", "0")
oHTML.threeJSGameVar("bcGems", "0")
oHTML.threeJSGameVar("bcTotal", "15")
oHTML.threeJSGameVar("bcTime", "60")
oHTML.threeJSGameVar("bcDone", "false")
oHTML.threeJSGameVar("bcVelX", "0")
oHTML.threeJSGameVar("bcVelZ", "0")

# Player ball
oHTML.threeJSSphere("g4", "ball", [
	:x = "0", :y = "0.5", :z = "0",
	:radius = "0.5", :segments = "24",
	:color = "0xff6644",
	:metalness = "0.4", :roughness = "0.3"
])

# Play area floor
oHTML.threeJSPlane("g4", "bcFloor", [
	:w = "20", :h = "20", :rx = "-1.5708",
	:color = "0x3a7a4a"
])

# Border walls
oHTML.addBodyScript("
var bwMat = new THREE.MeshStandardMaterial({color:0x666666, roughness:0.9});
function addBorderWall(x,z,w,d) {
  var g = new THREE.BoxGeometry(w, 0.8, d);
  var m = new THREE.Mesh(g, bwMat);
  m.position.set(x, 0.4, z);
  scene_g4.add(m);
}
addBorderWall(0, -10.3, 21, 0.6);
addBorderWall(0, 10.3, 21, 0.6);
addBorderWall(-10.3, 0, 0.6, 21);
addBorderWall(10.3, 0, 0.6, 21);
")

# Gems and holes created via JS
oHTML.addBodyScript("
var gems_g4 = [];
var holes_g4 = [];

// Spawn gems
var gemGeo = new THREE.OctahedronGeometry(0.3, 0);
var gemColors = [0x00ff88, 0xff44ff, 0x44aaff, 0xffdd00, 0xff4444];
for(var i = 0; i < bcTotal; i++) {
  var gMat = new THREE.MeshStandardMaterial({
    color: gemColors[i % gemColors.length],
    emissive: gemColors[i % gemColors.length],
    emissiveIntensity: 0.4, metalness: 0.6
  });
  var gem = new THREE.Mesh(gemGeo, gMat);
  gem.position.set(
    (Math.random() - 0.5) * 16,
    0.5,
    (Math.random() - 0.5) * 16
  );
  scene_g4.add(gem);
  gems_g4.push(gem);
}

// Spawn holes (dark circles to avoid)
var holeGeo = new THREE.CylinderGeometry(0.8, 0.8, 0.1, 24);
var holeMat = new THREE.MeshBasicMaterial({color:0x000000});
for(var i = 0; i < 8; i++) {
  var hole = new THREE.Mesh(holeGeo, holeMat);
  hole.position.set(
    (Math.random() - 0.5) * 14,
    0.01,
    (Math.random() - 0.5) * 14
  );
  scene_g4.add(hole);
  holes_g4.push(hole);
}
")

# Keyboard
oHTML.addBodyScript("
var bk = {};
window.addEventListener('keydown', function(e) { bk[e.key.toLowerCase()] = true; e.preventDefault(); });
window.addEventListener('keyup', function(e) { bk[e.key.toLowerCase()] = false; });
")

# Lights
oHTML.threeJSAmbientLight("g4", [:intensity = "0.5"])
oHTML.threeJSDirectionalLight("g4", "bcLt", [:x = "8", :y = "12", :z = "8", :intensity = "0.7"])
oHTML.threeJSPointLight("g4", "ballLight", [:x = "0", :y = "2", :z = "0", :color = "0xff6644", :intensity = "0.5"])

# Game loop
oHTML.threeJSOnAnimate("g4", "
  if(bcDone) return;
  
  bcTime -= delta;
  if(bcTime <= 0) {
    bcTime = 0;
    bcDone = true;
    document.getElementById('g4end').style.display = 'flex';
    document.getElementById('g4final').textContent = 'Gems: ' + bcGems + '/' + bcTotal + ' | Score: ' + bcScore;
    return;
  }
  
  // Ball physics
  var accel = 15;
  var friction = 0.96;
  if(bk['w'] || bk['arrowup']) bcVelZ -= accel * delta;
  if(bk['s'] || bk['arrowdown']) bcVelZ += accel * delta;
  if(bk['a'] || bk['arrowleft']) bcVelX -= accel * delta;
  if(bk['d'] || bk['arrowright']) bcVelX += accel * delta;
  bcVelX *= friction;
  bcVelZ *= friction;
  
  ball.position.x += bcVelX * delta;
  ball.position.z += bcVelZ * delta;
  
  // Boundary
  ball.position.x = Math.max(-9.5, Math.min(9.5, ball.position.x));
  ball.position.z = Math.max(-9.5, Math.min(9.5, ball.position.z));
  
  // Roll rotation
  ball.rotation.z -= bcVelX * delta * 2;
  ball.rotation.x += bcVelZ * delta * 2;
  
  // Light follow
  ballLight.position.set(ball.position.x, 2, ball.position.z);
  
  // Camera follow
  camera_g4.position.x = ball.position.x;
  camera_g4.position.z = ball.position.z + 10;
  camera_g4.lookAt(ball.position.x, 0, ball.position.z);
  
  // Collect gems
  for(var i = gems_g4.length - 1; i >= 0; i--) {
    gems_g4[i].rotation.y += 3 * delta;
    gems_g4[i].position.y = 0.5 + Math.sin(elapsed * 3 + i) * 0.15;
    if(ball.position.distanceTo(gems_g4[i].position) < 0.8) {
      scene_g4.remove(gems_g4[i]);
      gems_g4.splice(i, 1);
      bcGems++;
      bcScore += 100;
      if(bcGems >= bcTotal) {
        bcDone = true;
        document.getElementById('g4end').style.display = 'flex';
        document.getElementById('g4final').textContent = 
          'ALL GEMS! Time: ' + bcTime.toFixed(1) + 's | Score: ' + (bcScore + Math.round(bcTime * 10));
      }
    }
  }
  
  // Holes - reset ball position
  for(var i = 0; i < holes_g4.length; i++) {
    if(ball.position.distanceTo(holes_g4[i].position) < 0.7) {
      ball.position.set(0, 0.5, 0);
      bcVelX = 0;
      bcVelZ = 0;
      bcScore = Math.max(0, bcScore - 50);
      break;
    }
  }
  
  document.getElementById('g4gems').textContent = 'Gems: ' + bcGems + '/' + bcTotal;
  document.getElementById('g4score').textContent = 'Score: ' + bcScore;
  document.getElementById('g4time').textContent = 'Time: ' + bcTime.toFixed(1) + 's';
  if(bcTime < 10) document.getElementById('g4time').style.color = '#ff4444';
")

# HUD
oHTML.threeJSOverlay("g4", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px;font-family:monospace'><div style='color:#ff6644;font-weight:bold;font-size:1.2rem'>BALL COLLECTOR</div><div id='g4gems' style='color:#00ff88;margin-top:6px'>Gems: 0/15</div><div id='g4score' style='color:#ffdd00;margin-top:4px'>Score: 0</div><div id='g4time' style='color:#aaa;margin-top:4px'>Time: 60.0s</div><div style='color:#555;font-size:0.7rem;margin-top:8px'>WASD to roll | Avoid holes!</div></div>", [:position = "top-left"])

# End overlay
oHTML.addRawHTML("<div id='g4end' style='display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:100;justify-content:center;align-items:center'><div style='text-align:center;color:white;font-family:monospace'><div style='font-size:3rem;color:#ff6644'>GAME OVER</div><div style='font-size:1.2rem;margin-top:10px;color:#ffdd00' id='g4final'></div><div style='margin-top:20px;color:#888;cursor:pointer' onclick='location.reload()'>Click to play again</div></div></div>")

oHTML.threeJSAnimate("g4")
oHTML.save("game4_ball_collector.html")
? "  Created: game4_ball_collector.html"
