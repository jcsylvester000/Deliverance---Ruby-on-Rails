# PROJECT_MANIFEST.md — Deliverance

**Read this first on any future session touching this project.**
Folder: `5 - Final Application/Job Forum and Instant Messaging Board/` · Ticket: JT-20260911-05 (T1/D3)
Status: **Phases 0–7 built & green (RSpec 88/0); Phase 8 deploy kit prepared (not yet deployed).** Last updated 2026-09-11.

## What this is
"Deliverance" — a role-based job/gig board. Tagline *"Looking for a Job, We can Deliver."* Companies post
temporary / project / full-time-with-benefits roles tagged Remote/Hybrid/On-site; applicants browse publicly
and register to apply. Two CRM dashboards (Job Poster, Applicant) drive a hiring pipeline.

## Stack (verified)
Rails 8.1.3 · Ruby 3.3.6 · PostgreSQL 16 · Hotwire (Turbo + Stimulus) + Tailwind + ViewComponent · Devise +
Pundit-style role gates · RSpec + FactoryBot · ActiveStorage (local) · `json` pinned ~> 2.7 (D-008).
Local: Docker Compose — **web on :3002, db on :5436**, dev image `Dockerfile.dev`. Prod: `./Dockerfile`
(Render Docker) + Neon; cable async.

## Run it locally
`docker compose build` → `docker compose run --rm web bash bin/bootstrap` (first time only) →
`docker compose run --rm web bin/rails db:migrate` (+ `RAILS_ENV=test`) → `db:seed` → `docker compose up` → http://localhost:3002.
Demo logins (password123): `poster@deliverance.test`, `applicant@deliverance.test`, plus `mika@`, `jae@`.

## Phases (all green, verified on the user's machine)
- **0** foundation (boots, empty suite green)
- **1** accounts + role enum + 2 profiles, get-to-know-you modal, HUD transition, role-gated dashboards
- **2** JobPostings (type/arrangement/status enums, 10-active cap, money-as-cents), public board (search/filter/detail)
- **3** Applications (stage machine, 20-active cap, dedupe), poster pipeline CRM + applicant tracker, Notifications
- **4** Interviews + month calendar (both sides), reschedule/cancel, .ics download
- **5** Onboarding upload (ActiveStorage, prototype per Q2), checklist, poster doc view
- **6** Messaging: accept-only DMs, opt-in discovery, group chats, live Turbo threads, block/decline
- **7** Real-time notification center (live bell + list via Turbo Streams, per-kind icons)
- **8** Deploy kit prepared: Dockerfile.dev split, cable async for prod, .dockerignore excludes /setup/,
  render.yaml, docs/DEPLOY.md. **Deploy is user-run — see docs/DEPLOY.md.**

## Decisions log (D-001…D-009)
See `6 - Memory and Work Logs/_MEMORY_INDEX.md` and per-phase worklogs. Key: Ruby 3.3.6 pin (verifiable
stack), Docker generate-on-user-machine kit (egress/mount blocked), compose `exec` + pid-clear, json 2.x pin,
enum `group` → `scopes: false`.

## Remaining
- **Phase 8 execution** — user deploys via `docs/DEPLOY.md` (Neon prod DB + Render, secrets in env only).
- **Phase 9** — swap onboarding/CV storage to UploadThing v7 (live test needed); AI resume-match + CV-rewrite
  (needs AI provider + key). Both deferred to the user's go-ahead.

## Next three actions
1. User runs the Phase 8 local re-verify (`docker compose build` + rspec + up), then follows `docs/DEPLOY.md`.
2. Decide Phase 9 scope (UploadThing and/or AI) and provide the AI provider/key when ready.
3. Rotate the dev Neon + UploadThing keys before any real use.
