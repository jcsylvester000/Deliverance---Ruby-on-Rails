module ApplicationHelper
  STAGE_COLORS = {
    "applied"      => "bg-sky-400/10 text-sky-200 border-sky-400/30",
    "under_review" => "bg-amber-400/10 text-amber-200 border-amber-400/30",
    "interview"    => "bg-violet-400/10 text-violet-200 border-violet-400/30",
    "offer"        => "bg-emerald-400/10 text-emerald-200 border-emerald-400/30",
    "onboarding"   => "bg-cyan-400/10 text-cyan-200 border-cyan-400/30",
    "hired"        => "bg-emerald-500/15 text-emerald-100 border-emerald-500/40",
    "rejected"     => "bg-rose-500/10 text-rose-200 border-rose-500/30",
    "withdrawn"    => "bg-slate-500/10 text-slate-400 border-white/15"
  }.freeze

  def stage_badge(application)
    classes = STAGE_COLORS[application.stage] || "bg-white/5 text-slate-300 border-white/15"
    content_tag(:span, application.stage_label, class: "rounded-full border px-2 py-0.5 text-xs #{classes}")
  end

  # ---- Placeholder imagery (Phase 10) -------------------------------------
  # Marketing pages use royalty-free Unsplash photos. Every <img> built through
  # photo_tag also carries an onerror fallback to Lorem Picsum, so a visitor
  # never sees a broken-image icon even if a specific Unsplash id is unavailable.
  # This is a demo: swap these ids/seeds for owned art before any real launch.
  def unsplash_url(id, width: 1600, height: 900)
    "https://images.unsplash.com/photo-#{id}?auto=format&fit=crop&w=#{width}&h=#{height}&q=80"
  end

  def picsum_url(seed, width: 1600, height: 900)
    "https://picsum.photos/seed/#{seed}/#{width}/#{height}"
  end

  # image_tag with a resilient real-photo fallback.
  def photo_tag(unsplash_id, seed:, alt: "", width: 1600, height: 900, **opts)
    fallback = picsum_url(seed, width: width, height: height)
    opts[:onerror] = "this.onerror=null;this.src='#{fallback}'"
    opts[:loading] = opts.fetch(:loading, "lazy")
    opts[:alt] = alt
    image_tag(unsplash_url(unsplash_id, width: width, height: height), **opts)
  end

  # A round avatar with a fallback face.
  def avatar_tag(img_number, seed:, alt: "", size: 96, **opts)
    fallback = "https://picsum.photos/seed/#{seed}/#{size}/#{size}"
    opts[:onerror] = "this.onerror=null;this.src='#{fallback}'"
    opts[:loading] = opts.fetch(:loading, "lazy")
    opts[:alt] = alt
    image_tag("https://i.pravatar.cc/#{size}?img=#{img_number}", **opts)
  end

  def calendar_weeks(date)
    first  = date.beginning_of_month
    start  = first.beginning_of_week(:sunday)
    finish = date.end_of_month.end_of_week(:sunday)
    (start..finish).to_a.each_slice(7).to_a
  end

  def notification_message(notification)
    obj   = notification.notifiable
    title = notifiable_job_title(obj)

    case notification.kind
    when "application_received"         then "New application for #{title} from #{obj.applicant.display_name}"
    when "application_advanced"         then "Your application for #{title} moved to #{obj.stage_label}"
    when "application_rejected"         then "Your application for #{title} wasn't selected this time"
    when "application_withdrawn"        then "#{obj.applicant.display_name} withdrew from #{title}"
    when "interview_scheduled"          then "Interview scheduled for #{title} on #{obj.scheduled_at.to_fs(:long)}"
    when "interview_cancelled"          then "Interview for #{title} was cancelled"
    when "onboarding_document_uploaded" then "#{obj.applicant.display_name} uploaded #{obj.label} for #{title}"
    when "message_request"              then "#{obj.sender.display_name} sent you a message request"
    else "Notification"
    end
  end

  def notification_link(notification)
    obj = notification.notifiable
    return "#" if obj.blank?

    case notification.kind
    when "application_received", "application_withdrawn" then poster_application_path(obj)
    when "onboarding_document_uploaded"                  then poster_application_path(obj.application)
    when "interview_scheduled", "interview_cancelled"    then applicant_interviews_path
    when "message_request"                               then conversation_path(obj.conversation)
    else applicant_applications_path
    end
  end

  private

  def notifiable_job_title(obj)
    jp =
      if obj.is_a?(Interview) then obj.application&.job_posting
      elsif obj.respond_to?(:job_posting) then obj.job_posting
      end
    jp&.title || "a role"
  end
end
