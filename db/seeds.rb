# Deliverance seeds — DEVELOPMENT ONLY. Never seed test or production.
if Rails.env.development?
  poster = User.find_or_create_by!(email: "poster@deliverance.test") do |u|
    u.password = "password123"
    u.role = :job_poster
    u.organization_type = :company_representative
    u.heard_from = "A friend or colleague"
  end
  poster.poster_profile&.update!(company_name: "Acme Staffing", about: "We place great people, fast.")

  applicant = User.find_or_create_by!(email: "applicant@deliverance.test") do |u|
    u.password = "password123"
    u.role = :applicant
    u.organization_type = :individual
  end
  applicant.applicant_profile&.update!(headline: "Reliable generalist, open to gigs")

  sample_jobs = [
    { title: "Delivery Driver (Weekends)", work_arrangement: :onsite,  employment_type: :gig,
      location: "Makati", compensation_cents: 12_000, compensation_period: :hourly,
      description: "Weekend deliveries around Metro Manila. Own transport a plus." },
    { title: "React Front-End Engineer", work_arrangement: :remote,  employment_type: :project_based,
      location: "Remote", compensation_cents: 350_000, compensation_period: :monthly,
      description: "Build a customer dashboard over a 3-month engagement. Hotwire or React welcome." },
    { title: "Warehouse Associate", work_arrangement: :onsite,  employment_type: :full_time_benefits,
      location: "Cavite", compensation_cents: 220_000, compensation_period: :monthly,
      description: "Full-time role with HMO and 13th-month pay. Training provided." },
    { title: "Event Setup Crew", work_arrangement: :onsite,  employment_type: :temporary,
      location: "Quezon City", compensation_cents: 90_000, compensation_period: :fixed,
      description: "Two-day corporate event. Load-in, setup, and teardown." },
    { title: "Bookkeeper (Part-time)", work_arrangement: :hybrid, employment_type: :project_based,
      location: "Pasig / Hybrid", compensation_cents: 25_000, compensation_period: :hourly,
      description: "Reconcile monthly books for a small business. QuickBooks experience preferred." }
  ]

  jobs = sample_jobs.map do |attrs|
    posting = poster.job_postings.find_or_initialize_by(title: attrs[:title])
    posting.assign_attributes(attrs.merge(status: :published))
    posting.save!
    posting
  end

  others = ["mika@deliverance.test", "jae@deliverance.test"].map do |email|
    User.find_or_create_by!(email: email) do |u|
      u.password = "password123"
      u.role = :applicant
      u.organization_type = :individual
    end
  end
  others[0].applicant_profile&.update!(headline: "Barista & event crew, weekends free")
  others[1].applicant_profile&.update!(headline: "Warehouse & logistics")

  [applicant, *others].each { |u| u.applicant_profile&.update!(discoverable: true) }

  seed_apps = [
    [applicant, jobs[0], :applied],
    [applicant, jobs[1], :under_review],
    [others[0], jobs[0], :interview],
    [others[1], jobs[2], :applied]
  ]

  seed_apps.each do |who, job, stage|
    app = Application.find_or_initialize_by(applicant: who, job_posting: job)
    if app.new_record?
      app.stage = stage
      app.save!
      Notification.find_or_create_by!(user: poster, notifiable: app, kind: :application_received)
    end
  end

  Application.find_by(applicant: applicant, job_posting: jobs[1])&.update!(stage: :onboarding)

  interview_app = Application.find_by(applicant: others[0], job_posting: jobs[0])
  if interview_app && interview_app.interview.nil?
    iv = interview_app.create_interview!(
      scheduled_at: 2.days.from_now.change(hour: 14, min: 0),
      duration_minutes: 30, mode: :online,
      meeting_link: "https://meet.example.com/deliverance-demo",
      notes: "Intro call. We'll walk through your weekend availability."
    )
    iv.notify_scheduled!
  end

  if Conversation.direct_between(others[0], applicant).nil?
    convo = Conversation.create!(kind: :direct, creator: others[0])
    convo.conversation_participants.create!(user: others[0], status: :accepted, last_read_at: Time.current)
    convo.conversation_participants.create!(user: applicant, status: :invited)
    msg = convo.messages.create!(sender: others[0], body: "Hey! Saw you're job hunting too — want to compare interview notes?")
    Notification.find_or_create_by!(user: applicant, notifiable: msg, kind: :message_request)
  end

  # An open group chat for the demo applicant to join.
  if Conversation.where(kind: :group, title: "Weekend Gig Crew").none?
    group = Conversation.create!(kind: :group, title: "Weekend Gig Crew", creator: others[0])
    group.conversation_participants.create!(user: others[0], status: :accepted, last_read_at: Time.current)
    group.messages.create!(sender: others[0], body: "Anyone doing the Makati deliveries this weekend?")
  end

  puts "Seeded demo logins (password123):"
  puts "  Job Poster → poster@deliverance.test"
  puts "  Applicant  → applicant@deliverance.test (message request + an open group to join)"
  puts "  Others     → mika@deliverance.test, jae@deliverance.test (discoverable)"
end
