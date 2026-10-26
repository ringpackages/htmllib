/*
	HTMLLib Demo 88 - Whack-A-Mole 3D Game
*/

load "htmllib.ring"

# ==================================================================
# Demo 88: Whack-A-Mole 3D Game
# Click on moles as they pop up from the ground
# Controls: Mouse click
# ==================================================================
? "Demo 88: Whack-A-Mole 3D..."

oHTML = new HTMLWriter
oHTML.setTitle("Whack-A-Mole 3D")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("g5", [:fullscreen = true, :bg = "0x88aa44", :camX = "0", :camY = "8", :camZ = "8"])

# Game vars
oHTML.threeJSGameVar("wScore", "0")
oHTML.threeJSGameVar("wMisses", "0")
oHTML.threeJSGameVar("wTime", "30")
oHTML.threeJSGameVar("wDone", "false")
oHTML.threeJSGameVar("wCombo", "0")

# Ground
oHTML.threeJSPlane("g5", "wGround", [
	:w = "12", :h = "12", :rx = "-1.5708",
	:color = "0x5a3a1a"
])

oHTML.threeJSAmbientLight("g5", [:intensity = "0.5"])
oHTML.threeJSDirectionalLight("g5", "wLt", [:x = "5", :y = "10", :z = "5", :intensity = "0.7"])
oHTML.threeJSHemisphereLight("g5", [:skyColor = "0x88aa44", :groundColor = "0x5a3a1a", :intensity = "0.3"])

# Mole grid + raycasting
oHTML.addBodyScript("
var moles = [];
var moleStates = [];  // 0=hidden, 1=rising, 2=up, 3=falling, 4=hit
var moleTimers = [];
var moleMeshes = [];

var raycaster = new THREE.Raycaster();
var mouse = new THREE.Vector2();

// Create 3x3 grid of mole holes
var holeMat = new THREE.MeshStandardMaterial({color:0x2a1a0a});
var moleMat = new THREE.MeshStandardMaterial({color:0x885533, roughness:0.8});
var hitMat = new THREE.MeshStandardMaterial({color:0xff3333, emissive:0xff0000, emissiveIntensity:0.5});
var moleGeo = new THREE.CylinderGeometry(0.35, 0.4, 0.8, 12);
var holeGeo = new THREE.CylinderGeometry(0.55, 0.55, 0.15, 16);

for(var row = -1; row <= 1; row++) {
  for(var col = -1; col <= 1; col++) {
    var x = col * 3;
    var z = row * 3;
    
    // Hole
    var hole = new THREE.Mesh(holeGeo, holeMat);
    hole.position.set(x, 0.01, z);
    scene_g5.add(hole);
    
    // Mole (starts underground)
    var mole = new THREE.Mesh(moleGeo, moleMat.clone());
    mole.position.set(x, -0.8, z);
    scene_g5.add(mole);
    
    // Eyes
    var eyeGeo = new THREE.SphereGeometry(0.08, 8, 8);
    var eyeMat = new THREE.MeshBasicMaterial({color:0xffffff});
    var eye1 = new THREE.Mesh(eyeGeo, eyeMat);
    eye1.position.set(-0.12, 0.25, 0.3);
    mole.add(eye1);
    var eye2 = new THREE.Mesh(eyeGeo, eyeMat);
    eye2.position.set(0.12, 0.25, 0.3);
    mole.add(eye2);
    var pupilGeo = new THREE.SphereGeometry(0.05, 8, 8);
    var pupilMat = new THREE.MeshBasicMaterial({color:0x000000});
    var p1 = new THREE.Mesh(pupilGeo, pupilMat);
    p1.position.set(-0.12, 0.25, 0.35);
    mole.add(p1);
    var p2 = new THREE.Mesh(pupilGeo, pupilMat);
    p2.position.set(0.12, 0.25, 0.35);
    mole.add(p2);
    
    // Nose
    var noseGeo = new THREE.SphereGeometry(0.06, 8, 8);
    var noseMat = new THREE.MeshBasicMaterial({color:0xff6666});
    var nose = new THREE.Mesh(noseGeo, noseMat);
    nose.position.set(0, 0.15, 0.38);
    mole.add(nose);
    
    moles.push(mole);
    moleMeshes.push(mole);
    moleStates.push(0);
    moleTimers.push(Math.random() * 2 + 1);
  }
}

// Click to whack
window.addEventListener('click', function(e) {
  if(wDone) return;
  mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
  mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
  raycaster.setFromCamera(mouse, camera_g5);
  
  var hits = raycaster.intersectObjects(moleMeshes, true);
  if(hits.length > 0) {
    // Find which mole was hit
    var hitObj = hits[0].object;
    while(hitObj.parent && moleMeshes.indexOf(hitObj) === -1) hitObj = hitObj.parent;
    var idx = moleMeshes.indexOf(hitObj);
    if(idx >= 0 && (moleStates[idx] === 1 || moleStates[idx] === 2)) {
      moleStates[idx] = 4;
      moleTimers[idx] = 0.3;
      moles[idx].material.color.set(0xff3333);
      moles[idx].material.emissive.set(0xff0000);
      moles[idx].material.emissiveIntensity = 0.5;
      wCombo++;
      wScore += 10 * wCombo;
    }
  } else {
    wCombo = 0;
    wMisses++;
  }
});
")

# Game loop
oHTML.threeJSOnAnimate("g5", "
  if(wDone) return;
  
  wTime -= delta;
  if(wTime <= 0) {
    wTime = 0;
    wDone = true;
    document.getElementById('g5end').style.display = 'flex';
    document.getElementById('g5final').textContent = 
      'Score: ' + wScore + ' | Misses: ' + wMisses;
    return;
  }
  
  // Mole state machine
  for(var i = 0; i < moles.length; i++) {
    moleTimers[i] -= delta;
    
    switch(moleStates[i]) {
      case 0: // Hidden - wait to pop up
        if(moleTimers[i] <= 0) {
          moleStates[i] = 1;
          moleTimers[i] = 0.3;
          moles[i].material.color.set(0x885533);
          moles[i].material.emissive.set(0x000000);
          moles[i].material.emissiveIntensity = 0;
        }
        break;
      case 1: // Rising
        moles[i].position.y += 3 * delta;
        if(moles[i].position.y >= 0.4) {
          moles[i].position.y = 0.4;
          moleStates[i] = 2;
          moleTimers[i] = 1 + Math.random() * 1.5;
        }
        break;
      case 2: // Up - waiting to be whacked
        if(moleTimers[i] <= 0) {
          moleStates[i] = 3;
          wCombo = 0;
        }
        break;
      case 3: // Falling
        moles[i].position.y -= 3 * delta;
        if(moles[i].position.y <= -0.8) {
          moles[i].position.y = -0.8;
          moleStates[i] = 0;
          moleTimers[i] = Math.random() * 2 + 0.5;
        }
        break;
      case 4: // Hit - brief flash then fall
        if(moleTimers[i] <= 0) {
          moleStates[i] = 3;
        }
        break;
    }
  }
  
  document.getElementById('g5score').textContent = 'Score: ' + wScore;
  document.getElementById('g5time').textContent = 'Time: ' + wTime.toFixed(1) + 's';
  document.getElementById('g5combo').textContent = wCombo > 1 ? 'Combo: x' + wCombo : '';
  if(wTime < 10) document.getElementById('g5time').style.color = '#ff4444';
")

# HUD
oHTML.threeJSOverlay("g5", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px;font-family:monospace'><div style='color:#885533;font-weight:bold;font-size:1.2rem'>WHACK-A-MOLE 3D</div><div id='g5score' style='color:#ffdd00;margin-top:6px'>Score: 0</div><div id='g5time' style='color:#aaa;margin-top:4px'>Time: 30.0s</div><div id='g5combo' style='color:#ff6644;margin-top:4px'></div><div style='color:#555;font-size:0.7rem;margin-top:8px'>Click the moles!</div></div>", [:position = "top-left"])

# End overlay
oHTML.addRawHTML("<div id='g5end' style='display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:100;justify-content:center;align-items:center'><div style='text-align:center;color:white;font-family:monospace'><div style='font-size:3rem;color:#885533'>TIME UP!</div><div style='font-size:1.2rem;margin-top:10px;color:#ffdd00' id='g5final'></div><div style='margin-top:20px;color:#888;cursor:pointer' onclick='location.reload()'>Click to play again</div></div></div>")

oHTML.threeJSAnimate("g5")
oHTML.save("game5_whack_a_mole.html")
? "  Created: game5_whack_a_mole.html"
