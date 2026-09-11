# Static, in-memory blog content for the marketing site (Phase 10).
#
# Intentionally NOT an ActiveRecord model: there is no migration and no table,
# so the blog renders identically in every environment and adds no schema risk
# to the deployed database. If the blog ever needs real authoring, promote this
# to a table with the same public interface (all / find / to_param).
class Article
  include ActiveModel::Model

  attr_accessor :slug, :title, :excerpt, :tag, :cover_id, :read_minutes,
                :author, :author_role, :author_avatar, :published_on, :body

  ARTICLES = [
    new(
      slug: "hire-without-the-chaos",
      title: "Hire without the spreadsheet chaos",
      excerpt: "Why a pipeline beats a full inbox — and how to move candidates from ‘applied’ to ‘hired’ without losing anyone.",
      tag: "For Posters",
      cover_id: "1600880292203-757bb62b4baf",
      read_minutes: 4,
      author: "Ava Mitchell",
      author_role: "Founder, Meridian Studio",
      author_avatar: 47,
      published_on: Date.new(2026, 8, 28),
      body: [
        "Most hiring doesn't fall apart because of bad candidates. It falls apart because good candidates get lost — buried in an inbox, forgotten in a thread, or ghosted because nobody remembered whose turn it was to reply.",
        "A pipeline fixes that by making state visible. Every applicant is a card, and every card sits in exactly one column: applied, under review, interview, offer, onboarding, or hired. You never have to ask ‘where did we land with this person?’ — the board already answers it.",
        "On Deliverance, moving a candidate forward also does the quiet work for you: it notifies them, it timestamps the change, and it keeps the whole history in one place. The result is fewer dropped balls and a lot less second-guessing.",
        "Start small. Post one role, watch the applications land as cards, and move the first few through by hand. Within a day the rhythm becomes obvious — and you'll wonder how you ever did it in a spreadsheet."
      ]
    ),
    new(
      slug: "apply-once-then-track-it",
      title: "Apply once, then actually track it",
      excerpt: "The silence after applying is the worst part of job hunting. Here's how real-time status changes that.",
      tag: "For Applicants",
      cover_id: "1521737604893-d14cc237f11d",
      read_minutes: 3,
      author: "Daniel Okafor",
      author_role: "Freelance Developer",
      author_avatar: 33,
      published_on: Date.new(2026, 8, 20),
      body: [
        "You spend an hour on an application, hit submit, and then… nothing. No confirmation that a human saw it, no sense of whether you're still in the running. That silence is the single most demoralizing part of looking for work.",
        "Deliverance is built to remove it. The moment a poster moves your application, you see it — applied becomes under review, review becomes interview. You're never guessing whether it's time to follow up.",
        "That transparency changes how you job-hunt. Instead of blasting fifty applications into the void, you can apply thoughtfully to roles you actually want and watch each one progress.",
        "And when an interview is scheduled, the invite and calendar file land automatically. No back-and-forth about times, no missed meetings — just a clear next step."
      ]
    ),
    new(
      slug: "the-30-second-welcome",
      title: "The 30-second welcome that shapes everything",
      excerpt: "Our get-to-know-you flow asks three questions. Here's why each one earns its place.",
      tag: "Product",
      cover_id: "1522071820081-009f0129c71c",
      read_minutes: 3,
      author: "Priya Nair",
      author_role: "Talent Lead, Vertex",
      author_avatar: 45,
      published_on: Date.new(2026, 8, 12),
      body: [
        "Onboarding questionnaires are usually a tax — ten fields between you and the thing you came to do. We wanted the opposite: three questions, thirty seconds, and a dashboard that's already shaped around you when you arrive.",
        "The first question — poster or applicant — decides your entire workspace. The second, what kind of organization you are, tunes the details. The third is optional, because not everyone wants to say how they found us, and forcing it would be rude.",
        "That's the whole philosophy: ask only what changes the experience, and let people skip the rest. A shorter welcome that respects your time beats a thorough one that wastes it."
      ]
    ),
    new(
      slug: "accept-only-messaging",
      title: "Why our inbox is accept-only",
      excerpt: "Cold messages are noise. Conversations that both sides opted into are signal. A small rule with a big effect.",
      tag: "Product",
      cover_id: "1499750310107-5fef28a66643",
      read_minutes: 2,
      author: "Ava Mitchell",
      author_role: "Founder, Meridian Studio",
      author_avatar: 47,
      published_on: Date.new(2026, 8, 5),
      body: [
        "Open inboxes get abused. The moment anyone can message anyone, the interesting messages drown under the ones nobody asked for.",
        "So on Deliverance a conversation only starts when both sides opt in. Someone sends a request; you accept, decline, or block. Once accepted, you can talk freely — including in group chats — but the door only opens from the inside.",
        "It's a small rule, and it quietly does a lot: less spam, more intent, and an inbox that's actually worth checking."
      ]
    ),
    new(
      slug: "interviews-and-the-calendar",
      title: "Interviews that don't need a scheduling email",
      excerpt: "Built-in scheduling, reminders, and .ics invites — so the only thing left to do is show up.",
      tag: "For Posters",
      cover_id: "1517245386807-bb43f82c33c4",
      read_minutes: 3,
      author: "Priya Nair",
      author_role: "Talent Lead, Vertex",
      author_avatar: 45,
      published_on: Date.new(2026, 7, 29),
      body: [
        "The scheduling dance — ‘does Tuesday work? no? how about Thursday at 2, actually make it 3’ — is one of the most avoidable time-sinks in hiring.",
        "Deliverance folds it into the pipeline. Pick a time from the candidate's card, and both sides get an invite plus a downloadable calendar file. Need to move it? Reschedule or cancel in one place, and everyone's notified.",
        "The point isn't the calendar itself. It's that scheduling stops being a separate task you have to remember, and becomes one click inside the flow you're already in."
      ]
    ),
    new(
      slug: "browse-before-you-commit",
      title: "Browse before you commit",
      excerpt: "The board is open to everyone. You only make an account when you're ready to apply — here's the thinking.",
      tag: "For Applicants",
      cover_id: "1600880292089-90a7e086ee0c",
      read_minutes: 2,
      author: "Daniel Okafor",
      author_role: "Freelance Developer",
      author_avatar: 33,
      published_on: Date.new(2026, 7, 21),
      body: [
        "Plenty of job sites make you sign up before you can even see what's on offer. That's backwards. You should be able to look around first.",
        "On Deliverance the whole board is public. Filter by remote or on-site, by gig or full-time, search by title — all without an account. You register only at the moment you decide to apply, because that's the first time an account actually does something for you.",
        "Lower the cost of looking, and people look more honestly. That's better for applicants and for posters, who get applications from people who actually chose the role."
      ]
    )
  ].freeze

  def self.all
    ARTICLES
  end

  def self.find(slug)
    all.find { |a| a.slug == slug } ||
      raise(ActiveRecord::RecordNotFound, "No article with slug #{slug.inspect}")
  end

  # Lets article_path(article) build /blog/:slug.
  def to_param
    slug
  end
end
