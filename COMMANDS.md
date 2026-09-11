# Deliverance — Phase 0 run commands

**Goal of Phase 0:** a Rails 8.1.3 app that **boots** on your machine with a **green test suite**, running
against a **local Docker Postgres**. Neon is wired but not used yet — it comes in later for seeding/deploy.

You run these on your Windows machine (PowerShell) in the project folder. Docker Desktop must be running.

> Why you run this and not the agency: this session's cloud workspace is blocked from RubyGems and Docker
> Hub, and can't reach your folder to run commands right now. So the app is generated and booted here, on
> your machine, where the network and Docker are available. Two commands do it.

---

## 0. Open a terminal in the project folder

```powershell
cd "C:\Users\jcsyl\Desktop\Ruby on Rails Tutor Agency\Ruby on Rails Tutor Agency\5 - Final Application\Job Forum and Instant Messaging Board"
```

You should see these files already here: `Dockerfile`, `compose.yaml`, `.env.example`,
`bin\bootstrap`, `setup\`.

---

## 0.5. Create your `.env`

The real secrets file can't be written to your disk by the agency's remote tools, so it was delivered as
`setup\env.filled` (same contents, allowed name). Copy it into place once:

```powershell
Copy-Item "setup\env.filled" ".env"
```

`.env` is git-ignored. You can delete `setup\env.filled` afterward if you like.

---

## 1. Generate + configure + test (one command)

```powershell
docker compose run --rm web bash bin/bootstrap
```

This builds the image, generates the Rails app (module `Deliverance`), adds Devise + Pundit + ViewComponent +
RSpec + FactoryBot, applies the Deliverance `database.yml`, creates the dev and test databases on the local
Postgres, and runs the suite. When it finishes you should see something like:

```
1 example, 0 failures
Phase 0 complete. Start the app with:   docker compose up
```

That green line is **Checkpoint 0**.

---

## 2. Start the app

```powershell
docker compose up
```

Then open **http://localhost:3002** — you'll get the Rails welcome page. The health endpoint
**http://localhost:3002/up** should show green.

Stop it with `Ctrl+C`, or run detached with `docker compose up -d` and stop with `docker compose down`.

---

## Everyday commands (after Phase 0)

```powershell
docker compose up                 # start web + db
docker compose up -d              # start in the background
docker compose down               # stop
docker compose run --rm web bash bin/rails console      # rails console
docker compose run --rm web bundle exec rspec           # run the test suite
docker compose run --rm web bash bin/rails db:migrate   # run migrations (later phases)
docker compose logs -f web        # tail the web logs
```

To connect to the database directly:

```powershell
docker compose exec db psql -U postgres -d deliverance_development
```

---

## If the one command fails, run it in steps

`bin/bootstrap` just runs these in order — you can run them by hand to see exactly where anything stops:

```powershell
# 1. Generate the app
docker compose run --rm web rails new /tmp/deliverance --database=postgresql --css=tailwind --skip-test --skip-kamal --skip-solid
# (then copy /tmp/deliverance contents into the project — bin/bootstrap does this automatically;
#  running the full bootstrap is the reliable path)

# 2. Re-run the bootstrap — it is idempotent and picks up where it left off
docker compose run --rm web bash bin/bootstrap
```

Two things that trip up a first run:
- **Docker Desktop not started** → "cannot connect to the Docker daemon". Start Docker Desktop, wait for green.
- **Port already in use** (`3002` or `5436`) → something else is using it. Change the left-hand number in
  `compose.yaml` (e.g. `3003:3000`) and re-run.

If `--skip-solid` is rejected by your Rails version, remove that one flag and re-run — everything else is the same.

---

## Notes

- Ruby is pinned to **3.3.6** and Rails to **8.1.3** for this first slice. Bumping the Ruby line in the
  `Dockerfile` later (to 3.4.x or 4.0.x) is a one-line change we'll re-verify once the workspace can boot it.
- Your real credentials live only in `.env` (git-ignored). `.env.example` is the safe template to commit.
- Neon is not touched in Phase 0. When we seed to Neon later, we'll point a one-time task at
  `NEON_DATABASE_URL` (the direct endpoint) — the test database can never reach it because of the custom name.
