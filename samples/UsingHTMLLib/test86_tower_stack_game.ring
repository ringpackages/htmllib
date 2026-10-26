/*
	HTMLLib Demo 86 - Tower Stack Game
*/

load "htmllib.ring"

# ==================================================================
# Demo 86: Tower Stack Game
# Stack falling blocks as perfectly as possible
# Controls: Space / Click to drop block
# ==================================================================
? "Demo 86: Tower Stack..."

oHTML = new HTMLWriter
oHTML.setTitle("Tower Stack")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("g3", [:fullscreen = true, :bg = "0x1a0a2e", :camX = "6", :camY = "8", :camZ = "10"])

# Game variables
oHTML.threeJSGameVar("towerHeight", "0")
oHTML.threeJSGameVar("tStackScore", "0")
oHTML.threeJSGameVar("blockW", "3")
oHTML.threeJSGameVar("blockD", "3")
oHTML.threeJSGameVar("swingDir", "1")
oHTML.threeJSGameVar("swingAxis", "'x'")
oHTML.threeJSGameVar("tStackGO", "false")
oHTML.threeJSGameVar("dropping", "false")
oHTML.threeJSGameVar("swingSpeed", "4")
oHTML.threeJSGameVar("lastX", "0")
oHTML.threeJSGameVar("lastZ", "0")
oHTML.threeJSGameVar("stackBlocks", "[]")

# Base platform
oHTML.threeJSBox("g3", "basePlat", [
	:x = "0", :y = "-0.25", :z = "0",
	:w = "3", :h = "0.5", :d = "3",
	:color = "0x4444ff",
	:metalness = "0.3", :roughness = "0.5"
])

# Lights
oHTML.threeJSAmbientLight("g3", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("g3", "tsLt", [:x = "8", :y = "15", :z = "8", :intensity = "0.7"])
oHTML.threeJSPointLight("g3", "topLight", [:x = "0", :y = "5", :z = "0", :color = "0xffffff", :intensity = "0.5"])

oHTML.threeJSOrbitControls("g3", [:damping = true])

# Block creation and game logic
oHTML.addBodyScript("
var currentBlock = null;

function getBlockColor(h) {
  var hue = (h * 25) % 360;
  return new THREE.Color('hsl(' + hue + ',70%,55%)');
}

function spawnBlock() {
  var geo = new THREE.BoxGeometry(blockW, 0.5, blockD);
  var mat = new THREE.MeshStandardMaterial({
    color: getBlockColor(towerHeight),
    metalness: 0.3, roughness: 0.5
  });
  currentBlock = new THREE.Mesh(geo, mat);
  currentBlock.position.y = towerHeight * 0.5 + 0.25;
  
  if(swingAxis === 'x') {
    currentBlock.position.x = -7;
    currentBlock.position.z = lastZ;
  } else {
    currentBlock.position.z = -7;
    currentBlock.position.x = lastX;
  }
  scene_g3.add(currentBlock);
  dropping = false;
}

function dropBlock() {
  if(!currentBlock || dropping || tStackGO) return;
  dropping = true;
  
  var pos = currentBlock.position;
  var overlap, newW, newD, newX, newZ;
  
  if(swingAxis === 'x') {
    overlap = blockW - Math.abs(pos.x - lastX);
    if(overlap <= 0) { endGame(); return; }
    newW = overlap;
    newD = blockD;
    newX = lastX + (pos.x - lastX) / 2;
    newZ = lastZ;
    
    // Trim block
    currentBlock.geometry.dispose();
    currentBlock.geometry = new THREE.BoxGeometry(newW, 0.5, newD);
    currentBlock.position.x = newX;
    
    // Falling offcut
    var cutW = blockW - overlap;
    if(cutW > 0.05) {
      var cutGeo = new THREE.BoxGeometry(cutW, 0.5, newD);
      var cutMat = currentBlock.material.clone();
      cutMat.transparent = true;
      var cutBlock = new THREE.Mesh(cutGeo, cutMat);
      var cutDir = pos.x > lastX ? 1 : -1;
      cutBlock.position.set(newX + cutDir * (newW + cutW) / 2, pos.y, newZ);
      scene_g3.add(cutBlock);
      // Animate fall
      (function(cb) {
        var vy = 0;
        animCallbacks_g3.push(function(dt) {
          vy -= 15 * dt;
          cb.position.y += vy * dt;
          cb.material.opacity -= dt;
          if(cb.position.y < -10) scene_g3.remove(cb);
        });
      })(cutBlock);
    }
    
    blockW = newW;
    lastX = newX;
  } else {
    overlap = blockD - Math.abs(pos.z - lastZ);
    if(overlap <= 0) { endGame(); return; }
    newW = blockW;
    newD = overlap;
    newX = lastX;
    newZ = lastZ + (pos.z - lastZ) / 2;
    
    currentBlock.geometry.dispose();
    currentBlock.geometry = new THREE.BoxGeometry(newW, 0.5, newD);
    currentBlock.position.z = newZ;
    
    var cutD = blockD - overlap;
    if(cutD > 0.05) {
      var cutGeo2 = new THREE.BoxGeometry(newW, 0.5, cutD);
      var cutMat2 = currentBlock.material.clone();
      cutMat2.transparent = true;
      var cutBlock2 = new THREE.Mesh(cutGeo2, cutMat2);
      var cutDir2 = pos.z > lastZ ? 1 : -1;
      cutBlock2.position.set(newX, pos.y, newZ + cutDir2 * (newD + cutD) / 2);
      scene_g3.add(cutBlock2);
      (function(cb) {
        var vy = 0;
        animCallbacks_g3.push(function(dt) {
          vy -= 15 * dt;
          cb.position.y += vy * dt;
          cb.material.opacity -= dt;
          if(cb.position.y < -10) scene_g3.remove(cb);
        });
      })(cutBlock2);
    }
    
    blockD = newD;
    lastZ = newZ;
  }
  
  // Perfect placement bonus
  var diff = (swingAxis === 'x') ? Math.abs(pos.x - lastX) : Math.abs(pos.z - lastZ);
  var bonus = diff < 0.15 ? ' PERFECT!' : '';
  
  towerHeight++;
  tStackScore += Math.round((1 - diff/3) * 100);
  if(bonus) tStackScore += 50;
  
  // Alternate swing axis
  swingAxis = swingAxis === 'x' ? 'z' : 'x';
  swingSpeed = Math.min(8, 4 + towerHeight * 0.15);
  
  stackBlocks.push(currentBlock);
  currentBlock = null;
  
  // Move camera up
  var targetY = towerHeight * 0.5 + 6;
  camera_g3.position.y += (targetY - camera_g3.position.y) * 0.3;
  topLight.position.y = towerHeight * 0.5 + 4;
  
  spawnBlock();
  
  document.getElementById('g3score').textContent = 'Score: ' + tStackScore + bonus;
  document.getElementById('g3height').textContent = 'Height: ' + towerHeight;
}

function endGame() {
  tStackGO = true;
  if(currentBlock) {
    var cb = currentBlock;
    var vy = 0;
    animCallbacks_g3.push(function(dt) {
      vy -= 15 * dt;
      cb.position.y += vy * dt;
      if(cb.position.y < -10) scene_g3.remove(cb);
    });
  }
  document.getElementById('g3go').style.display = 'flex';
  document.getElementById('g3final').textContent = 'Score: ' + tStackScore + ' | Height: ' + towerHeight;
}

// Start
spawnBlock();

// Input
window.addEventListener('keydown', function(e) {
  if(e.code === 'Space') { e.preventDefault(); dropBlock(); }
});
window.addEventListener('click', function() { dropBlock(); });
window.addEventListener('touchstart', function() { dropBlock(); });
")

# Swing animation
oHTML.threeJSOnAnimate("g3", "
  if(currentBlock && !dropping && !tStackGO) {
    if(swingAxis === 'x') {
      currentBlock.position.x += swingDir * swingSpeed * delta;
      if(currentBlock.position.x > 6) swingDir = -1;
      if(currentBlock.position.x < -6) swingDir = 1;
    } else {
      currentBlock.position.z += swingDir * swingSpeed * delta;
      if(currentBlock.position.z > 6) swingDir = -1;
      if(currentBlock.position.z < -6) swingDir = 1;
    }
  }
  
  // Slowly orbit camera
  var camR = 12;
  var camAngle = elapsed * 0.15;
  camera_g3.position.x = Math.sin(camAngle) * camR;
  camera_g3.position.z = Math.cos(camAngle) * camR;
  var lookY = towerHeight * 0.5;
  camera_g3.lookAt(0, lookY, 0);
")

# HUD
oHTML.threeJSOverlay("g3", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px;font-family:monospace'><div style='color:#ff66aa;font-weight:bold;font-size:1.2rem'>TOWER STACK</div><div id='g3score' style='color:#ffdd00;margin-top:6px'>Score: 0</div><div id='g3height' style='color:#aaa;margin-top:4px'>Height: 0</div><div style='color:#555;font-size:0.7rem;margin-top:8px'>Space / Click to drop</div></div>", [:position = "top-left"])

# Game Over
oHTML.addRawHTML("<div id='g3go' style='display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:100;justify-content:center;align-items:center'><div style='text-align:center;color:white;font-family:monospace'><div style='font-size:3rem;color:#ff66aa'>TOWER FELL!</div><div style='font-size:1.2rem;margin-top:10px;color:#ffdd00' id='g3final'></div><div style='margin-top:20px;color:#888;cursor:pointer' onclick='location.reload()'>Click to restart</div></div></div>")

oHTML.threeJSAnimate("g3")
oHTML.save("game3_tower_stack.html")
? "  Created: game3_tower_stack.html"
