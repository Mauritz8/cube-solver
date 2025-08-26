# cube-solver: Interactive 3D Rubik's Cube Solver
A 3D Rubik's Cube simulator with built-in solving guidance.

<img width="1917" height="964" alt="image" src="https://github.com/user-attachments/assets/09f36e22-cb45-4abc-9a78-f3850bee3506" />

## Tech Stack
* **Frontend:** Svelte
* **Backend:** OCaml with the Dream framework

## Usage

1. Backend
```bash
# install dependencies
opam install . --deps-only --with-test --with-doc

# setup environment
eval $(opam env)

# launch server
dune exec ./bin/server.exe
```

2. Frontend
```bash
cd frontend

# install dependencies
npm install

# run web application
npm run dev
```
