import * as THREE from 'three';

function getSideStickers(sideId) {
  const side = document.getElementById(sideId);
  const sticker_elems = Array.from(side.getElementsByClassName('sticker'));
  return sticker_elems.map(
    sticker_elem => [sticker_elem.classList[1].toUpperCase()]
  );
}

function getCube() {
  return {
    front: getSideStickers('front'),
    right: getSideStickers('right'),
    left: getSideStickers('left'),
    top: getSideStickers('top'),
    bottom: getSideStickers('bottom'),
    back: getSideStickers('back'),
  };
}

function move_cube_post_req(direction, clockwise) {
  const body = {
    move: {
      direction: direction,
      clockwise: clockwise,
    },
    cube: getCube(),
  };
  fetch('/api/move', {
    method: 'POST',
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  }).then(res => res.text())
    .then(text => {
      document.getElementById('cube').outerHTML = text;
    });
}

function move_on_btn_click(btn_id, direction, clockwise) {
  document
    .getElementById(btn_id)
    .addEventListener('click', () => move_cube_post_req([direction], clockwise));
}

move_on_btn_click('move_up_clockwise_btn', 'UP', true);
move_on_btn_click('move_up_counter_clockwise_btn', 'UP', false);
move_on_btn_click('move_down_clockwise_btn', 'DOWN', true);
move_on_btn_click('move_down_counter_clockwise_btn', 'DOWN', false);
move_on_btn_click('move_right_clockwise_btn', 'RIGHT', true);
move_on_btn_click('move_right_counter_clockwise_btn', 'RIGHT', false);
move_on_btn_click('move_left_clockwise_btn', 'LEFT', true);
move_on_btn_click('move_left_counter_clockwise_btn', 'LEFT', false);
move_on_btn_click('move_front_clockwise_btn', 'FRONT', true);
move_on_btn_click('move_front_counter_clockwise_btn', 'FRONT', false);
move_on_btn_click('move_back_clockwise_btn', 'BACK', true);
move_on_btn_click('move_back_counter_clockwise_btn', 'BACK', false);

document.getElementById('scramble_btn').addEventListener('click', () => {
  fetch('/api/scramble')
    .then(res => res.text())
    .then(text => document.getElementById('cube_container').outerHTML = text);
});

const color = c => new THREE.MeshBasicMaterial({ color: c, side: THREE.DoubleSide });
const blue = color(0x0000ff);
const green = color(0x00ff00);
const red = color(0xff0000);
const yellow = color(0xffff00);
const white = color(0xffffff);
const orange = color(0xffA500);

const rect_size = 1 / 3;
const margin = 0.00;
const axis_pos = axis => axis * (rect_size + margin);
function create_rect(color, x, y, z) {
  const geometry = new THREE.PlaneGeometry(rect_size, rect_size);
  const rect = new THREE.Mesh(geometry, color);
  rect.position.set(x, y, z);
  return rect;
}

function create_cube() {
  const group = new THREE.Group();

  // front
  for (let x = 0; x < 3; x++) {
    for (let y = 0; y < 3; y++) {
      group.add(create_rect(blue, axis_pos(x), axis_pos(y), 0));
    }
  }

  // back
  for (let x = 0; x < 3; x++) {
    for (let y = 0; y < 3; y++) {
      group.add(create_rect(green, axis_pos(x), axis_pos(y), axis_pos(3)));
    }
  }

  // top
  for (let x = 0; x < 3; x++) {
    for (let z = 0; z < 3; z++) {
      const rect = create_rect(white, axis_pos(x), -axis_pos(1) / 2, axis_pos(z) + axis_pos(1) / 2);
      rect.rotateX(Math.PI / 2);
      group.add(rect);
    }
  }

  // bottom
  for (let x = 0; x < 3; x++) {
    for (let z = 0; z < 3; z++) {
      const rect = create_rect(yellow, axis_pos(x), axis_pos(2) + axis_pos(1) / 2, axis_pos(z) + axis_pos(1) / 2);
      rect.rotateX(Math.PI / 2);
      group.add(rect);
    }
  }

  // right
  for (let y = 0; y < 3; y++) {
    for (let z = 0; z < 3; z++) {
      const rect = create_rect(red, -axis_pos(1) / 2, axis_pos(y), axis_pos(z) + axis_pos(1) / 2);
      rect.rotateY(Math.PI / 2);
      group.add(rect);
    }
  }

  // left
  for (let y = 0; y < 3; y++) {
    for (let z = 0; z < 3; z++) {
      const rect = create_rect(orange, axis_pos(2) + axis_pos(1) / 2, axis_pos(y), axis_pos(z) + axis_pos(1) / 2);
      rect.rotateY(Math.PI / 2);
      group.add(rect);
    }
  }

  return group;
}

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);

const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

const cube = create_cube();
scene.add(cube);

camera.position.x = 2;
camera.position.y = 2;
camera.position.z = 4;
camera.lookAt(scene.position);
function animate() {
	//cube.rotation.x += 0.01;
	//cube.rotation.y += 0.01;
	renderer.render(scene, camera);
}
renderer.setAnimationLoop(animate);
