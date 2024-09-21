import * as THREE from 'three';

const color =
  c => new THREE.MeshBasicMaterial({ color: c, side: THREE.DoubleSide });
const blue = color(0x0000ff);
const green = color(0x00ff00);
const red = color(0xff0000);
const yellow = color(0xffff00);
const white = color(0xffffff);
const orange = color(0xffA500);

function sticker_to_color(sticker) {
  const sticker_to_color_map = {
    ["BLUE"]: blue,
    ["GREEN"]: green,
    ["RED"]: red,
    ["YELLOW"]: yellow,
    ["WHITE"]: white,
    ["ORANGE"]: orange,
  };
  return sticker_to_color_map[sticker];
}

const rect_size = 1 / 2;
function create_rect(color, x, y, z) {
  const geometry = new THREE.PlaneGeometry(rect_size, rect_size);
  const rect = new THREE.Mesh(geometry, color);
  rect.position.set(x, y, z);
  return rect;
}

const margin = 0.00;
const axis_pos = axis => axis * (rect_size + margin);

function create_cube(cube) {
  const group = new THREE.Group();

  // back
  for (let x = 0; x < 3; x++) {
    for (let y = 0; y < 3; y++) {
      const color = sticker_to_color(cube.back[3 * y + (2 - x)]);
      group.add(create_rect(color, axis_pos(x), axis_pos(-y), axis_pos(-2)));
    }
  }

  // front
  for (let x = 0; x < 3; x++) {
    for (let y = 0; y < 3; y++) {
      const color = sticker_to_color(cube.front[3 * y + x]);
      group.add(create_rect(color, axis_pos(x), axis_pos(-y), axis_pos(1)));
    }
  }

  // bottom
  for (let x = 0; x < 3; x++) {
    for (let z = 0; z < 3; z++) {
      const color = sticker_to_color(cube.bottom[3 * z + x]);
      const rect = create_rect(
        color,
        axis_pos(x),
        axis_pos(-2) - axis_pos(1) / 2,
        axis_pos(-z) + axis_pos(1) / 2);
      rect.rotateX(Math.PI / 2);
      group.add(rect);
    }
  }

  // top
  for (let x = 0; x < 3; x++) {
    for (let z = 0; z < 3; z++) {
      const color = sticker_to_color(cube.top[3 * (2 - z) + x]);
      const rect = create_rect(
        color,
        axis_pos(x),
        axis_pos(1) / 2,
        axis_pos(-z) + axis_pos(1) / 2);
      rect.rotateX(Math.PI / 2);
      group.add(rect);
    }
  }

  // left
  for (let y = 0; y < 3; y++) {
    for (let z = 0; z < 3; z++) {
      const color = sticker_to_color(cube.left[3 * y + (2 - z)]);
      const rect = create_rect(
        color,
        -axis_pos(1) / 2,
        axis_pos(-y),
        axis_pos(-z) + axis_pos(1) / 2);
      rect.rotateY(Math.PI / 2);
      group.add(rect);
    }
  }

  // right
  for (let y = 0; y < 3; y++) {
    for (let z = 0; z < 3; z++) {
      const color = sticker_to_color(cube.right[3 * y + z]);
      const rect = create_rect(
        color,
        axis_pos(2) + axis_pos(1) / 2,
        axis_pos(-y),
        axis_pos(-z) + axis_pos(1) / 2);
      rect.rotateY(Math.PI / 2);
      group.add(rect);
    }
  }

  return group;
}

const solved_cube = {
  front: [
    ["GREEN"],
    ["GREEN"],
    ["GREEN"],
    ["GREEN"],
    ["GREEN"],
    ["GREEN"],
    ["GREEN"],
    ["GREEN"],
    ["GREEN"],
  ],
  left: [
    ["ORANGE"],
    ["ORANGE"],
    ["ORANGE"],
    ["ORANGE"],
    ["ORANGE"],
    ["ORANGE"],
    ["ORANGE"],
    ["ORANGE"],
    ["ORANGE"],
  ],
  right: [
    ["RED"],
    ["RED"],
    ["RED"],
    ["RED"],
    ["RED"],
    ["RED"],
    ["RED"],
    ["RED"],
    ["RED"],
  ],
  top: [
    ["WHITE"],
    ["WHITE"],
    ["WHITE"],
    ["WHITE"],
    ["WHITE"],
    ["WHITE"],
    ["WHITE"],
    ["WHITE"],
    ["WHITE"],
  ],
  bottom: [
    ["YELLOW"],
    ["YELLOW"],
    ["YELLOW"],
    ["YELLOW"],
    ["YELLOW"],
    ["YELLOW"],
    ["YELLOW"],
    ["YELLOW"],
    ["YELLOW"],
  ],
  back: [
    ["BLUE"],
    ["BLUE"],
    ["BLUE"],
    ["BLUE"],
    ["BLUE"],
    ["BLUE"],
    ["BLUE"],
    ["BLUE"],
    ["BLUE"],
  ],
};

let cube = solved_cube;
let cube_three_js = create_cube(cube);

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(
  75, window.innerWidth / window.innerHeight, 0.1, 1000);

const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

scene.add(cube_three_js);

camera.position.x = 2;
camera.position.y = 2;
camera.position.z = 4;
camera.lookAt(scene.position);
function animate() {
	//cube_three_js.rotation.x += 0.01;
	//cube_three_js.rotation.y += 0.01;
	renderer.render(scene, camera);
}
renderer.setAnimationLoop(animate);

function update_cube(new_cube) {
  scene.remove(cube_three_js);
  cube = new_cube;
  cube_three_js = create_cube(cube);
  scene.add(cube_three_js);
}

function move_cube_post_req(direction, clockwise) {
  const body = {
    move: {
      direction: direction,
      clockwise: clockwise,
    },
    cube: cube,
  };
  fetch('/api/move', {
    method: 'POST',
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  }).then(res => res.json().then(json => update_cube(json)));
}

function move_on_btn_click(btn_id, direction, clockwise) {
  document
    .getElementById(btn_id)
    .addEventListener(
      'click', () => move_cube_post_req([direction], clockwise));
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
    .then(res => res.json().then(json => update_cube(json)));
});
