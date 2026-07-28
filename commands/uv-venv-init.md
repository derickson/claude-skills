Use uv to make a python venv in ~/.venvs/{project-name} and a symbolic link locally so that we pick it up in this folder.

Steps:
1. Determine the project name from the current working directory (the basename of the repo root).
2. Run `uv venv ~/.venvs/{project-name}` to create the virtual environment.
3. Create a symlink `.venv -> ~/.venvs/{project-name}` in the project root so that tools (editors, uv, etc.) pick it up automatically.
4. Confirm success by printing the venv path and symlink location.
