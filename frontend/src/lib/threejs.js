import * as THREE from 'three';


const color =
  c => new THREE.MeshBasicMaterial({ color: c, side: THREE.DoubleSide });
const blue = color(0x0045AD);
const green = color(0x009B48);
const red = color(0xB90000);
const yellow = color(0xFFD500);
const white = color(0xFFFFFF);
const orange = color(0xFF5900);

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

function create_rect(size, color, x, y, z) {
  const geometry = new THREE.PlaneGeometry(size, size);
  const rect = new THREE.Mesh(geometry, color);
  rect.position.set(x, y, z);
  return rect;
}

const rect_size = 1 / 2;

function create_side(side_name, side_arr) {
  const index_map = (x, y) => ({
    "FRONT": 3 * y + x,
    "RIGHT": 3 * y + x,
    "BOTTOM": 3 * y + x,
    "BACK": 3 * y + (2 - x),
    "LEFT": 3 * y + (2 - x),
    "TOP": 3 * (2 - y) + x,
  });

  const side_three_js = new THREE.Group();
  for (let x = 0; x < 3; x++) {
    for (let y = 0; y < 3; y++) {
      const i = index_map(x, y)[side_name];
      const color = sticker_to_color(side_arr[i]);
      const rect =
        create_rect(rect_size, color, x * rect_size, -y * rect_size, 0);
      side_three_js.add(rect);
    }
  }
  return side_three_js;
}

export function create_cube(cube) {
  const cube_three_js = new THREE.Group();

  const back = create_side("BACK", cube.back);
  back.translateZ(-3 * rect_size);
  cube_three_js.add(back);

  const front = create_side("FRONT", cube.front);
  cube_three_js.add(front);

  const bottom = create_side("BOTTOM", cube.bottom);
  bottom.rotateX(Math.PI / 2);
  bottom.translateY(-rect_size / 2);
  bottom.translateZ(rect_size * 5 / 2);
  cube_three_js.add(bottom);

  const top = create_side("TOP", cube.top);
  top.rotateX(Math.PI / 2);
  top.translateZ(-rect_size / 2);
  top.translateY(-rect_size / 2);
  cube_three_js.add(top);

  const left = create_side("LEFT", cube.left);
  left.rotateY(Math.PI / 2);
  left.translateZ(-rect_size / 2);
  left.translateX(rect_size / 2);
  cube_three_js.add(left);

  const right = create_side("RIGHT", cube.right);
  right.rotateY(Math.PI / 2);
  right.translateZ(rect_size * 5 / 2);
  right.translateX(rect_size / 2);
  cube_three_js.add(right);

  return cube_three_js;
}
