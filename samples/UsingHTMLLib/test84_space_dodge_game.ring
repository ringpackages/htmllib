/*
	HTMLLib Demo 84 - Space Dodge Game
*/

load "htmllib.ring"

# ==================================================================
# Demo 84: Space Dodge Game
# Fly a ship through asteroid field, dodge obstacles, collect stars
# Controls: WASD / Arrow keys to move, avoid red asteroids
# ==================================================================
? "Demo 84: Space Dodge..."

oHTML = new HTMLWriter
oHTML.setTitle("Space Dodge")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("g1", [:fullscreen = true, :bg = "0x000011", :camZ = "12", :camY = "3"])

# Game variables
oHTML.threeJSGameVar("score", "0")
oHTML.threeJSGameVar("lives", "3")
oHTML.threeJSGameVar("speed", "5")
oHTML.threeJSGameVar("gameOver", "false")
oHTML.threeJSGameVar("obstacles", "[]")
oHTML.threeJSGameVar("stars", "[]")
oHTML.threeJSGameVar("spawnTimer", "0")
oHTML.threeJSGameVar("starTimer", "0")
oHTML.threeJSGameVar("invTimer", "0")
oHTML.threeJSGameVar("difficulty", "1")

# Player ship (green box)
oHTML.threeJSSphere("g1", "ship", [
	:x = "0", :y = "0", :z = "0",
	:radius = "0.4", :segments = "8",
	:color = "0x00ff88",
	:metalness = "0.6", :roughness = "0.3",
	:emissive = "0x004422", :emissiveIntensity = "0.5"
])

# Floor for reference
oHTML.threeJSPlane("g1", "spFloor", [
	:w = "12", :h = "100", :rx = "-1.5708", :y = "-3",
	:color = "0x0a0a2a", :side = "double"
])
oHTML.threeJSGridHelper("g1", [:size = "40", :divisions = "40", :color1 = "0x111133", :color2 = "0x111133"])

# Lights
oHTML.threeJSAmbientLight("g1", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("g1", "gLt1", [:x = "5", :y = "10", :z = "5", :intensity = "0.8"])
oHTML.threeJSPointLight("g1", "shipGlow", [:x = "0", :y = "0", :z = "0", :color = "0x00ff88", :intensity = "0.5"])

# Keyboard
oHTML.addBodyScript("
var gk = {};
window.addEventListener('keydown', function(e) { gk[e.key.toLowerCase()] = true; e.preventDefault(); });
window.addEventListener('keyup', function(e) { gk[e.key.toLowerCase()] = false; });
")

# Starfield background particles
oHTML.addBodyScript("
var starGeo = new THREE.BufferGeometry();
var starVerts = [];
for(var i=0; i<500; i++) {
  starVerts.push((Math.random()-0.5)*80, (Math.random()-0.5)*40, -Math.random()*60-10);
}
starGeo.setAttribute('position', new THREE.Float32BufferAttribute(starVerts, 3));
var starMat = new THREE.PointsMaterial({color:0xffffff, size:0.15});
scene_g1.add(new THREE.Points(starGeo, starMat));
")

# Main game loop
oHTML.threeJSOnAnimate("g1", "
  if(gameOver) return;
  
  var dt = delta;
  speed = 5 + difficulty * 0.5;
  
  // Player movement
  var mx = 0, my = 0;
  if(gk['a'] || gk['arrowleft']) mx -= 8 * dt;
  if(gk['d'] || gk['arrowright']) mx += 8 * dt;
  if(gk['w'] || gk['arrowup']) my += 6 * dt;
  if(gk['s'] || gk['arrowdown']) my -= 6 * dt;
  ship.position.x = Math.max(-5, Math.min(5, ship.position.x + mx));
  ship.position.y = Math.max(-2.5, Math.min(2.5, ship.position.y + my));
  shipGlow.position.copy(ship.position);
  
  // Invincibility flash
  if(invTimer > 0) {
    invTimer -= dt;
    ship.visible = Math.floor(invTimer * 10) % 2 === 0;
  } else {
    ship.visible = true;
  }
  
  // Spawn obstacles
  spawnTimer -= dt;
  if(spawnTimer <= 0) {
    spawnTimer = Math.max(0.3, 1.2 - difficulty * 0.08);
    var og = new THREE.DodecahedronGeometry(0.3 + Math.random() * 0.5, 0);
    var om = new THREE.MeshStandardMaterial({color:0xff3333, roughness:0.7, flatShading:true});
    var ob = new THREE.Mesh(og, om);
    ob.position.set((Math.random()-0.5)*10, (Math.random()-0.5)*5, -35);
    scene_g1.add(ob);
    obstacles.push(ob);
  }
  
  // Spawn stars (collectibles)
  starTimer -= dt;
  if(starTimer <= 0) {
    starTimer = 2;
    var sg = new THREE.OctahedronGeometry(0.25, 0);
    var sm = new THREE.MeshStandardMaterial({color:0xffdd00, emissive:0xffaa00, emissiveIntensity:0.8});
    var sb = new THREE.Mesh(sg, sm);
    sb.position.set((Math.random()-0.5)*8, (Math.random()-0.5)*4, -35);
    scene_g1.add(sb);
    stars.push(sb);
  }
  
  // Move obstacles toward player
  for(var i = obstacles.length - 1; i >= 0; i--) {
    obstacles[i].position.z += speed * dt;
    obstacles[i].rotation.x += 2 * dt;
    obstacles[i].rotation.y += 1.5 * dt;
    
    // Collision with player
    if(invTimer <= 0 && obstacles[i].position.distanceTo(ship.position) < 0.9) {
      lives--;
      invTimer = 2;
      obstacles[i].material.color.set(0xffffff);
      if(lives <= 0) {
        gameOver = true;
        document.getElementById('g1go').style.display = 'block';
      }
    }
    
    // Remove if past camera
    if(obstacles[i].position.z > 15) {
      scene_g1.remove(obstacles[i]);
      obstacles.splice(i, 1);
      score += 10;
    }
  }
  
  // Move stars
  for(var i = stars.length - 1; i >= 0; i--) {
    stars[i].position.z += speed * dt;
    stars[i].rotation.y += 3 * dt;
    
    // Collect
    if(stars[i].position.distanceTo(ship.position) < 0.7) {
      scene_g1.remove(stars[i]);
      stars.splice(i, 1);
      score += 50;
      continue;
    }
    
    if(stars[i].position.z > 15) {
      scene_g1.remove(stars[i]);
      stars.splice(i, 1);
    }
  }
  
  // Increase difficulty over time
  difficulty = 1 + score / 200;
  
  // Move floor for speed illusion
  spFloor.position.z = (spFloor.position.z + speed * dt) % 2;
  
  // Update HUD
  document.getElementById('g1score').textContent = 'Score: ' + score;
  document.getElementById('g1lives').textContent = 'Lives: ' + '♥'.repeat(lives);
  document.getElementById('g1speed').textContent = 'Speed: ' + speed.toFixed(1);
")

# HUD
oHTML.threeJSOverlay("g1", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px;font-family:monospace'><div style='color:#00ff88;font-weight:bold;font-size:1.2rem'>SPACE DODGE</div><div id='g1score' style='color:#ffdd00;margin-top:6px'>Score: 0</div><div id='g1lives' style='color:#ff4444;margin-top:4px'>Lives: ♥♥♥</div><div id='g1speed' style='color:#888;margin-top:4px;font-size:0.8rem'>Speed: 5</div><div style='color:#555;font-size:0.7rem;margin-top:8px'>WASD / Arrows to move</div></div>", [:position = "top-left"])

# Game Over overlay
oHTML.addRawHTML("<div id='g1go' style='display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:100;display:none;justify-content:center;align-items:center'><div style='text-align:center;color:white;font-family:monospace'><div style='font-size:3rem;color:#ff3333'>GAME OVER</div><div style='font-size:1.5rem;margin-top:10px;color:#ffdd00' id='g1final'>Score: 0</div><div style='margin-top:20px;color:#888;cursor:pointer' onclick='location.reload()'>Click to restart</div></div></div>")

oHTML.addBodyScript("
document.getElementById('g1go').style.display = 'none';
var _origGO = false;
setInterval(function() {
  if(gameOver && !_origGO) {
    _origGO = true;
    var el = document.getElementById('g1go');
    el.style.display = 'flex';
    document.getElementById('g1final').textContent = 'Final Score: ' + score;
  }
}, 100);
")

oHTML.threeJSAnimate("g1")
oHTML.save("game1_space_dodge.html")
? "  Created: game1_space_dodge.html"
