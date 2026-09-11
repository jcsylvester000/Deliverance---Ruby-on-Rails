# Deliverance — Build Game Plan

**"Looking for a Job, We can Deliver."**
Project: `deliverance` · Type: **T1 New Application** · Depth: **D3 Deep** · Status: **Planning — awaiting approval**
Prepared by the Ruby on Rails Tutor Agency · 2026-09-11 · No code is written until you approve this plan.

---

## 1. Restated objective

You want a job/gig board — Craigslist-shaped, but structured — where companies of any size post
**temporary, project-based, or full-time-with-benefits** work, tagged **Remote / Hybrid / On-site**, and
where applicants browse those posts publicly but must register to apply. The heart of the product is
**two role-specific dashboards that each behave like a CRM**: posters track and qualify inbound applicant
*leads* through a hiring pipeline (apply → review → interview → onboard → hire/reject), and applicants
track the jobs they've applied to. Around that core sit notifications, an interview scheduler with a
calendar, an accept-only messaging system (including applicant-to-applicant discovery and group chats),
and a hiring-time document onboarding step. AI (resume↔requirement matching for posters, CV rewriting for
applicants) is explicitly **deferred** and slots into both dashboards later.

"Done" for the whole program = a deployed Rails app on Render + Neon Postgres where a poster can register,
post up to 10 jobs, receive and qualify applicants, schedule interviews, and message accepted contacts; an
applicant can register, browse publicly, apply to up to 20 jobs, track them, get notified, be scheduled,
and upload onboarding documents when hired — all authorized, tested, and documented, with the AI seam left
ready but empty.

---

## 2. How the agency will build this

This is a full-pipeline **T1/D3** job, so the Orchestrator runs the standard new-application chain
**in phases**, not one pass, with you approving at each checkpoint:

```
S22 → S21 → S09 → S05 → S06 → S17 → S01 → S03 → S08 → S02 → S18 → S07 → S20 → S11 → S12 → S19 → S10 → S16
```

Read as roles: **S22** verify versions · **S21** requirements · **S09** journeys · **S05/S06** data & Postgres ·
**S17** security (veto power) · **S01** models/logic · **S03** controllers/routes · **S08/S02** design & frontend ·
**S18** tests (briefed *with* each build, never after) · **S07** Docker · **S20** background jobs/real-time ·
**S11** QA ship-verdict · **S12** structure/conventions · **S19** deploy · **S10** docs · **S16** memory/work log (every phase).

Standing agency rules that shape everything below: **data before behavior** (schema settled before models
before controllers before views); **journey before interface**; **security has veto**; **tests are not
optional and not last**; **versions verified by S22, never recalled**; **reach a green suite early and never
leave it**; **change one thing per round when the loop runs through your machine**.

---

## 3. The Job Ticket

```yaml
JOB_TICKET:
  id: JT-20260911-05
  date: 2026-09-11
  project: deliverance          # NEW — kebab-case folder in 5 - Final Application/
  type: T1
  depth: D3
  objective: >
    Build "Deliverance", a role-based job/gig posting board. Companies post temporary,
    project-based, or full-time roles tagged Remote/Hybrid/On-site; applicants browse
    publicly and register to apply. Two CRM-style dashboards (Job Poster, Applicant) drive a
    hiring pipeline, with notifications, interview scheduling + calendar, accept-only
    messaging incl. group chats, and hiring-time document onboarding. AI features are
    designed-for but deferred.
  definition_of_done:
    - Public landing page + publicly browsable, searchable, tag-filtered job board.
    - "Login / Become Member" opens the 3-question get-to-know-you modal (Q1 & Q2 required,
      Q3 optional/skippable) → account creation → HUD "setting up your dashboard" transition.
    - Job Poster can create up to 10 job postings and manage them.
    - Applicant can apply to up to 20 postings; every apply is tracked in both CRMs.
    - Poster can advance/qualify or reject an application through the pipeline; applicant is notified.
    - Interviews can be scheduled online and appear on a calendar; both parties are notified.
    - On reaching hire/onboarding status, the applicant is prompted to upload onboarding docs.
    - Accept-only messaging: no message reaches a poster unless the poster accepted the request;
      applicants can find and message other applicants; group chats can be created and joined.
    - Every controller action (incl. index/show) authorized; every collection scoped to the viewer.
    - RSpec suite green against a real Postgres runtime; RuboCop + Brakeman clean.
    - Runs locally under Docker Compose; deployed to Render (Docker) + Neon; portable setup guide written.
  scope_in:
    - Accounts, roles (job_poster, applicant), the two profile types, the onboarding modal.
    - Job postings with employment-type and work-arrangement tags; public board.
    - Applications, the hiring pipeline, both CRM dashboards, the posting/application caps.
    - Notifications, interview scheduling + calendar view, onboarding document upload.
    - Accept-only messaging, applicant discovery, group chats (see Q1 for timing).
    - Local Docker runtime, Neon dev DB, Render production deploy, docs + handoff guide.
  scope_out:
    - The AI resume-matching and CV-rewriting features (designed-for now, built later — Phase 9).
    - Real payments / billing of any kind.
    - Native mobile apps (responsive web only).
    - External calendar provider sync unless chosen in Q3 (default: internal calendar + .ics invite).
  intake_refs:
    - none registered for this project yet (three Rails .docx guides exist in 3 - Data Intake as background).
  prior_state:
    - No Deliverance code exists. An empty "Job Forum and Instant Messaging Board" folder sits in
      5 - Final Application/ as a placeholder (housekeeping item H1 below).
    - Proven boot shape is available to reuse verbatim from milan-at-manila and amped-hobbies
      (Dockerfile, compose, entrypoint, auth concern, rails_helper, Neon wiring, Render Docker deploy).
  constraints:
    - Windows 11 host; Docker Compose is the agreed local runtime; commands written to copy-paste, not run for you.
    - PostgreSQL on Neon (connection string to be provided by you at Phase 0); dev on Neon, test stays local.
    - Own host ports so it runs beside the others: 3002 / 5436 (3000/5434 and 3001/5435 taken).
    - Hotwire (Turbo + Stimulus) + Tailwind + ViewComponent; Devise + Pundit; RSpec + FactoryBot.
    - Money, if any appears (compensation), stored as integer smallest-unit, displayed via one helper.
  assumptions:
    - Posting cap (10) and application cap (20) are interpreted as ACTIVE counts, not lifetime totals
      (see Q4 — say the word and I'll switch to lifetime).
    - Interview scheduling is internal calendar + an .ics email invite in MVP; provider sync is later (Q3).
    - Onboarding ID documents are stored in-app via private ActiveStorage, encrypted, strictly scoped,
      with a retention rule — unless you'd rather not store them at all (Q2).
    - Applicant-to-applicant discovery is opt-in (an applicant chooses to be discoverable) (Q1).
    - Real-time (notifications, chat) via Turbo Streams + Action Cable; async work via the Rails-native
      queue adapter first, Sidekiq + Redis only if throughput demands it.
  open_questions:
    - Q1 messaging scope & timing + discovery opt-in (below)
    - Q2 onboarding document handling / PII posture (below)
    - Q3 interview calendar: internal-only vs external sync (below)
    - Q4 caps: active-count vs lifetime-total (below)
  teaching_mode: on_request
  risk_flags:
    - PII: government ID documents (driver license / passport) at onboarding — S17 owns; see Phase 5.
    - Public exposure: the job board and applicant discovery are viewable/among-users — scoping matters.
    - Secrets: Neon connection string — lives only in .env, never in source/logs/docs/fixtures.
    - Messaging abuse surface: accept-gate, blocking, and rate limits are security concerns, not just features.
```

---

## 4. Domain model — sketch only (S05 will formalize; no migrations yet)

The shape below is the plan's backbone. Exact columns, indexes, and migrations are S05/S06's deliverable in
Phase 1+, settled and shown to you before any model is written.

- **User** (Devise) — one account per person. `role` enum: `job_poster | applicant` (agency convention:
  `enum ... validate: true`, a role gate on a base controller the whole area inherits). Captures the modal
  answers: `registrant_kind` (poster/applicant), `organization_type`
  (`agency | individual | company_representative`), `heard_from` (optional, nullable).
- **PosterProfile** — belongs_to user. company/agency name, org type, contact, branding fields.
- **ApplicantProfile** — belongs_to user. headline, resume attachment, `discoverable` flag (Q1), skills/tags.
- **JobPosting** — belongs_to poster. `employment_type` (`temporary | project_based | full_time_benefits | gig`),
  `work_arrangement` (`remote | hybrid | onsite`), title, description, location, compensation (integer),
  tag list, `status` (`draft | published | closed`). Cap of 10 enforced in the model (Q4).
- **Application** — the CRM lead record. belongs_to applicant + job_posting. `stage` state machine:
  `applied → under_review → interview → offer → onboarding → hired`, plus terminal `rejected | withdrawn`.
  Cap of 20 enforced in the model (Q4). Unique per (applicant, posting).
- **Interview** — belongs_to application. `scheduled_at`, `mode: online`, meeting link, `status`. Feeds the calendar.
- **Notification** — belongs_to user. typed (`application_received | application_rejected | interview_scheduled | message_request | ...`),
  read/unread, delivered live via Turbo Streams and optionally by email.
- **OnboardingDocument** — belongs_to application (or user). Private ActiveStorage attachment, `kind`
  (`drivers_license | passport | ...`), status. **Sensitive — S17 owns the whole model (Phase 5).**
- **Conversation / ConversationParticipant / Message** — messaging. `conversation.kind` (`direct | group`).
- **MessageRequest** — the accept-only gate: a pending request between two users; messages don't deliver
  until accepted. Blocking + reporting hang off this.

**Business rules that live in the models (S01), not the controllers:** the 10/20 caps; the application
stage transitions; the message-delivery accept-gate; discoverability scoping. Controllers stay thin.

---

## 5. Security posture (S17 — has veto, reviewed every phase)

- **Authorization everywhere.** Every controller action authorized through Pundit, *including index and
  show*. Every collection scoped to what the viewer may see: a poster sees only their own postings and the
  applicants to them; an applicant sees only their own applications; the public sees only `published`
  postings; applicant discovery returns only `discoverable` applicants and never exposes contact details
  before a connection is accepted.
- **PII (the big one).** Government IDs are the highest-risk data in the app. Default plan: store via
  **private** ActiveStorage (never public URLs — signed, expiring, authorized downloads only), encrypted at
  rest, access limited to the specific poster/application, excluded from logs, fixtures, seeds, and error
  reports, with a stated retention/deletion rule. **Q2 lets you choose not to store them at all.**
- **Secrets.** The Neon string and any keys live only in git-ignored `.env`; config reads via `ENV.fetch`;
  `.env.example` carries placeholders. This is an agency hard stop — no real secret ever enters source or docs.
- **Auth hygiene.** Devise flows never reveal whether an email is registered (no enumeration oracle).
  Messaging carries an accept-gate, per-user blocking, and rate limiting to bound the abuse surface.
- **Neon specifics (learned on milan):** use Neon's **direct/non-pooled** endpoint for the app that runs
  migrations; name the dev URL something other than `DATABASE_URL` (e.g. `NEON_DATABASE_URL`) so it can
  never leak onto the test run; guard every per-env `ENV.fetch` with a default or an env check because
  `database.yml` is ERB-parsed in every environment.

---

## 6. The phased plan

Each phase is a shippable slice with its own skill chain, its own tests, and a checkpoint where you see the
work before we continue. S18 (tests) is briefed alongside the build skills in every phase. S16 logs every phase.

### Phase 0 — Kickoff & foundation that boots
**Skills:** S22 → S07 → S17(baseline) → S18(harness) → S16
Verify current Ruby / Rails / Postgres / gem versions (S22 — nothing recalled). Scaffold the Rails app in
`5 - Final Application/deliverance/`, reusing the proven boot shape from milan/amped verbatim: Dockerfile +
Compose (ports **3002/5436**), entrypoint, Tailwind + Hotwire + ViewComponent, Devise + Pundit installed but
empty, RSpec + FactoryBot, RuboCop + Brakeman. Wire the **Neon dev DB** with the safe env-var naming; test
stays local. Write `PROJECT_MANIFEST.md`. **Checkpoint 0: the empty app boots and the empty suite is green.**

### Phase 1 — Accounts, roles, the onboarding modal & dashboard shells
**Skills:** S21 → S09 → S05 → S06 → S17 → S01 → S03 → S08 → S02 → S18 → S16
The get-to-know-you modal (Q1 registrant kind → Q2 org type → Q3 optional "how did you hear," skippable →
submit), account creation, the role enum + profiles, the **HUD "setting up your dashboard" loading
transition**, and two empty role-scoped dashboard shells behind the base-controller role gate. Auth hardened.
**Checkpoint 1 (first working slice visible):** you register as each role and land on the right dashboard.

### Phase 2 — Job postings & the public board
**Skills:** S05 → S01 → S03 → S08 → S02 → S18 → S16
JobPosting with employment-type and work-arrangement tags shaping the poster's create/edit UI, the **10-post
cap**, draft/publish/close, and the **public** browse + search + tag-filter + detail pages (no login to view).
Poster dashboard gains posting management. **Checkpoint 2:** a poster publishes a tagged job; a logged-out
visitor finds it.

### Phase 3 — Applications & the two CRMs (the core loop)
**Skills:** S09 → S05 → S01 → S03 → S02 → S18 → S16
The Application record + stage state machine, the Apply flow with the **20-application cap** (register-to-apply
gate for logged-out viewers), the **Poster CRM** (see/qualify leads, advance to interview, or reject) and the
**Applicant CRM** (track everything applied to). First notifications: *applied* and *rejected*.
**Checkpoint 3:** apply → appears in both CRMs → poster advances or rejects → applicant sees the change.

### Phase 4 — Interview scheduling & calendar
**Skills:** S09 → S05 → S01 → S03 → S02 → S20 → S18 → S16
Schedule an online interview against an application, the calendar/map view of upcoming interviews, and
interview notifications to both parties (default: in-app + .ics email invite, per Q3).
**Checkpoint 4:** schedule an interview; it lands on the calendar and notifies both sides.

### Phase 5 — Hiring-time document onboarding  ⚠️ PII — S17 leads
**Skills:** S17 → S05 → S01 → S03 → S02 → S18 → S16
When an application reaches hire/onboarding, the applicant is prompted to upload the basics (driver license /
passport). Private, encrypted, strictly-scoped storage with signed downloads and a retention rule (per Q2).
S17 holds veto on the whole phase. **Checkpoint 5:** hired applicant uploads an ID; only the right poster can
retrieve it, via a signed link, and it appears in no log.

### Phase 6 — Messaging, discovery & group chats
**Skills:** S09 → S05 → S01 → S03 → S02 → S20 → S18 → S16
The accept-only message request gate (nothing delivers until accepted), 1:1 poster↔applicant threads,
opt-in applicant↔applicant discovery and chat, group chats you can create and join, all live via Turbo
Streams + Action Cable, with blocking + rate limits. **Checkpoint 6:** a request must be accepted before
messages flow; a group chat works end to end. *(Timing subject to Q1 — this may move earlier or later.)*

### Phase 7 — Notification center & real-time polish
**Skills:** S20 → S02 → S18 → S16
Consolidate every notification type into one live center, add email digests via background jobs, and tune
the real-time paths. **Checkpoint 7:** every state change surfaces in the notification center in real time.

### Phase 8 — Hardening, QA & deploy
**Skills:** S12 → S17 → S20 → S18 → S11 → S07 → S19 → S10 → S16
Convention/structure pass, full security review, N+1/performance sweep, whole-suite green against real
Postgres, S11 ship verdict, then deploy to **Render (Docker) + Neon production** mirroring milan's proven
path, plus the **portable setup & handoff guide**. **Checkpoint 8 (before deploy):** you approve going live.

### Phase 9 — AI integration  *(future — only on your go-ahead)*
**Skills:** S22 → S04 → S17 → S01 → S03 → S02 → S18 → S16
Two features into both dashboards: for posters, scan a resume against a posting's requirements and score the
match; for applicants, rewrite a CV to align with a target posting. Built behind a **pluggable AI-service
seam** we leave in place from Phase 1 so this drops in without reshaping anything. Needs your choice of AI
provider and an API key (handled as a secret) when you're ready.

---

## 7. Checkpoints where we stop and you look

Per the agency's standing checkpoints, we pause for your sign-off at: **scope agreed (this document)** ·
**data model agreed (end of Phase 1's S05 output)** · **first working slice visible (Checkpoint 1)** ·
**before the PII document feature (Phase 5)** · **before deploy (Checkpoint 8)**. We also stop before anything
destructive to data. Between checkpoints we build quietly (teaching on request only).

---

## 8. Decisions I need before Phase 0

These four genuinely change the architecture, so I'd rather ask than guess. Each has a default (in §3
`assumptions`) that I'll proceed with if you'd rather not decide now.

- **Q1 — Messaging: how central, and discovery opt-in?** The accept-only messaging + applicant discovery +
  group chat is a real-time subsystem in its own right. Is it core to the first usable release, or fine to
  land after the apply→interview→hire loop works (my default: Phase 6)? And should an applicant have to
  **opt in** to being discoverable by other applicants (my default: yes)?
- **Q2 — Onboarding IDs: store or not?** Driver licenses/passports are the most sensitive data here. Store
  them in-app (private, encrypted, scoped, with retention — my default), or have the app only *record that
  onboarding happened* and keep the actual documents out of the system entirely?
- **Q3 — Interview calendar: internal only, or synced?** Internal calendar + an .ics email invite (my
  default), or real sync with an external provider like Google Calendar (that's a Phase-4 integration with
  OAuth, and I'd verify the API via S04/S22)?
- **Q4 — The caps: active or lifetime?** Is "up to 10 postings / 20 applications" a count of *currently
  active* ones (my default — closing a job frees a slot) or a *lifetime total* that never resets?

**Housekeeping H1:** there's an empty `Job Forum and Instant Messaging Board/` folder in
`5 - Final Application/`. I'm proposing the project live in a clean `deliverance/` folder instead. Want me to
leave the old placeholder, or should it be removed?

---

## 9. What "starting us off" looks like

On your approval (and Q1–Q4 answered or defaulted), I run **Phase 0** and hand you a booting, empty
Deliverance app with a green suite and copy-paste run commands — then we agree the data model before a single
model is written. Nothing is coded until you say go.
