const base = 'http://localhost:8080';

async function solved_cube() {
  return await fetch(`${base}/api/solved_cube`);
}

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

export default { move, scramble, solved_cube };
