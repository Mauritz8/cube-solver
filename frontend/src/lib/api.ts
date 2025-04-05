const base = 'http://localhost:8080';

async function solved_cube() {
  return await fetch(`${base}/api/solved_cube`);
}

async function scramble() {
  return await fetch(`${base}/api/scramble`);
}

export default { scramble, solved_cube };
