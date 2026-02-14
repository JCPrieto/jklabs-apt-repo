# Repository Guidelines

## Project Structure & Module Organization
This repository is workflow-first and publishes an APT repository to `gh-pages`.

- `.github/workflows/update-repo.yml`: main automation for ingesting a `.deb`, rebuilding metadata with `reprepro`, and publishing artifacts.
- `gh-pages` branch (managed by workflow): generated APT output (`dists/`, `pool/`, `public.key`).
- No application source tree exists yet (`src/`, `tests/`, etc.). Keep runtime logic in workflows unless a script is clearly reusable.

## Build, Test, and Development Commands
There is no local build pipeline; validation is mainly workflow-level.

- `git status && git diff`: verify only intended workflow/docs changes are staged.
- `yamllint .github/workflows/update-repo.yml` (if installed): catch YAML syntax/style issues.
- `act workflow_dispatch -W .github/workflows/update-repo.yml` (optional): dry-run the GitHub Action locally.
- `gh workflow run update-repo.yml` (maintainers): trigger a manual run in GitHub.

## Coding Style & Naming Conventions
- Use 2-space indentation in YAML.
- Keep workflow step names imperative and specific (example: `Import signing key`, `Deploy to gh-pages`).
- Prefer lowercase, hyphenated filenames for workflows and docs.
- For shell in `run:` blocks: use `set -e` semantics via explicit checks (`test -n`, `exit 1`) and quote variables.

## Testing Guidelines
- Treat workflow execution as the primary integration test.
- For changes to package ingestion/publishing logic, validate:
  - payload checks fail on missing `deb_url`/`deb_filename`,
  - idempotent include behavior for existing versions,
  - `publish` contains `dists/`, `pool/`, and `public.key`.
- If adding scripts later, place tests near the script (for example, `scripts/<name>.sh` with a matching test file).

## Commit & Pull Request Guidelines
- Commit messages should be short, present tense, and scoped (history examples: `Workflow`, `Actualización del workflow`).
- Prefer clearer format going forward: `<area>: <change>` (example: `workflow: validate payload fields`).
- PRs should include:
  - what changed and why,
  - linked issue/event source,
  - impact on `gh-pages` output,
  - relevant workflow run URL or logs.

## Security & Configuration Notes
- Never commit private keys or secrets.
- Required GitHub secret: `APT_GPG_PRIVATE_KEY`.
- `repository_dispatch` payload must provide `deb_url` and `deb_filename`.
