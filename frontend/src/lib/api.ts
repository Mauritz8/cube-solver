import { type Cube, cubeToJson } from './cube';

const base = 'http://localhost:8080';

async function solved_cube() {
  return await fetch(`${base}/api/solved_cube`);
}

async function scramble() {
  return await fetch(`${base}/api/scramble`);
}

async function solve(cube: Cube) {
  return await fetch(`${base}/api/solve`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(cubeToJson(cube))
  });
}

async function move(move: string, cube: Cube) {
  const body = {
    move: move,
    cube: cubeToJson(cube),
  };
  return await fetch(`${base}/api/move`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body)
  });
}

export default { solved_cube, scramble, solve, move };
