let cube = {
  front: [
    'green',
    'green',
    'green',
    'green',
    'green',
    'green',
    'green',
    'green',
    'green',
  ],
  back: [
    'blue',
    'blue',
    'blue',
    'blue',
    'blue',
    'blue',
    'blue',
    'blue',
    'blue',
  ],
  right: [
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
  ],
  left: [
    'orange',
    'orange',
    'orange',
    'orange',
    'orange',
    'orange',
    'orange',
    'orange',
    'orange',
  ],
  top: [
    'white',
    'white',
    'white',
    'white',
    'white',
    'white',
    'white',
    'white',
    'white',
  ],
  bottom: [
    'yellow',
    'yellow',
    'yellow',
    'yellow',
    'yellow',
    'yellow',
    'yellow',
    'yellow',
    'yellow',
  ],
};

let cube_div = document.getElementById('cube');

function create_elem_from_side(side, side_name) {
  let side_div = document.createElement('div');
  side_div.classList.add('side');
  side_div.classList.add(side_name);
  side.forEach(sticker => {
    const sticker_div = document.createElement('div');
    sticker_div.classList.add('sticker');
    sticker_div.classList.add(sticker);
    side_div.appendChild(sticker_div);
  });
  cube_div.appendChild(side_div);
}

create_elem_from_side(cube.top, 'top');
create_elem_from_side(cube.left, 'left');
create_elem_from_side(cube.front, 'front');
create_elem_from_side(cube.right, 'right');
create_elem_from_side(cube.back, 'back');
create_elem_from_side(cube.bottom, 'bottom');
