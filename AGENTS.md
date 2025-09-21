# Repository Guidelines

## Project Structure & Module Organization
The image definition lives in `recipes/recipe.yml`; edit the `modules` list to add packages, scripts, or `justfile` imports. Runtime assets are staged under `files/system` (mirrors the image filesystem), `files/scripts` (bash scripts executed during builds), and `files/justfiles` (ujust recipes included at image build). Keep reusable modules in `modules/` and add new automation to `.github/workflows/` if CI needs to run it. The `cosign.pub` key is required for signature verification and must stay in the repo root.

## Build, Test, and Development Commands
Use the BlueBuild CLI container to work locally:
- `podman run --rm --pull=always -v $PWD:/workspace ghcr.io/blue-build/cli:latest lint recipes/recipe.yml` — schema validation and static checks.
- `podman run --rm --pull=always -v $PWD:/workspace ghcr.io/blue-build/cli:latest build recipes/recipe.yml` — builds the OCI image; ensure `ghcr.io` login if you plan to push.
- `ujust setup-sunshine enable` — runs the bundled just recipe in a target system to toggle the Sunshine service.
GitHub Actions (`.github/workflows/build.yml`) will rebuild the image on PRs, pushes to `main`, and the daily schedule.

## Coding Style & Naming Conventions
Use two-space indentation for YAML. Shell scripts should target Bash, start with `#!/usr/bin/env bash`, enable `set -euo pipefail`, and prefer lowercase-hyphen filenames (e.g., `setup-sunshine.sh`). Place shared just tasks in snake-case `group/task` names, mirroring `files/justfiles/gaming/sunshine.just`.

## Testing Guidelines
Run `lint` before opening PRs and confirm `build` succeeds locally when changing modules, scripts, or filesystem overlays. When modifying Sunshine automation, test `ujust setup-sunshine help` to confirm prompt text renders correctly. After CI builds, verify signatures with `cosign verify --key cosign.pub ghcr.io/yamshy/yamshy-os`.

## Commit & Pull Request Guidelines
Adopt Conventional Commits (`feat:`, `fix:`, `chore:`, etc.) with concise, imperative subjects (`fix: correct sunshine help usage`). Reference PR numbers or issues in the body if context is needed. PRs should summarize user-facing changes, call out affected recipes or scripts, and include build or lint output snippets when relevant. Request reviewers for changes that touch shared scripts or CI.

## Security & Configuration Tips
Keep `recipes/recipe.yml` free of secrets—use GitHub Actions secrets for credentials. When updating download URLs in scripts, prefer HTTPS sources and add integrity checks if available. Review `recipes/recipe.yml` after Fedora rebases to ensure base image tags remain intentional.
