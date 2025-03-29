import * as THREE from 'three';


const blue = 0x0045AD;
const green = 0x009B48;
const red = 0xB90000;
const yellow = 0xFFD500;
const white = 0xFFFFFF;
const orange = 0xFF5900;

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

function create_cubie(x, y, z, colors) {
  const materials = colors.map(c =>
    c ? new THREE.MeshBasicMaterial({ color: c }) :
        new THREE.MeshBasicMaterial({ color: 0x222222, transparent: true, opacity: 0.5 }));

  const cubie = new THREE.Mesh(
    new THREE.BoxGeometry(0.98, 0.98, 0.98),
    materials
  );
  cubie.position.set(x, y, z);
  return cubie;
}

export function create_cube(cube) {
  let cube_three_js = new THREE.Group();
  for (let x = -1; x <= 1; x++) {
    for (let y = -1; y <= 1; y++) {
      for (let z = -1; z <= 1; z++) {
        const color = (face, index) => sticker_to_color(face.at(index));
        const colors = [
          x === 1 ? color(cube.right, 3 * (1 - y) + 1 - z) : null,
          x === -1 ? color(cube.left, 3 * (1 - y) + 1 + z) : null,
          y === 1 ? color(cube.top, 3 * (1 + z) + 1 + x) : null,
          y === -1 ? color(cube.bottom, 3 * (1 - z) + 1 + x) : null,
          z === 1 ? color(cube.front, 3 * (1 - y) + 1 + x) : null,
          z === -1 ? color(cube.back, 3 * (1 - y) + 1 - x) : null,
        ];
        cube_three_js.add(create_cubie(x, y, z, colors));
      }
    }
  }
  return cube_three_js;
}
