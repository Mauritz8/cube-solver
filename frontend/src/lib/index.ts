const base = 'http://localhost:8080';

async function move(cube, direction, clockwise: boolean) {
  const body = {
    move: {
      direction: direction,
      clockwise: clockwise,
    },
    cube: cube,
  };
  return await fetch(`${base}/api/move`, {
    method: 'POST',
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

async function scramble() {
  return await fetch(`${base}/api/scramble`);
}

async function rotate_right(cube) {
  return await fetch(`${base}/api/rotate`, {
    method: 'POST',
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(cube),
  });
}

export default { move, scramble, rotate_right };
