# Builds a minimal .ics calendar event for an interview (internal download, no external sync).
module IcsBuilder
  module_function

  def event(interview)
    fmt = ->(t) { t.utc.strftime("%Y%m%dT%H%M%SZ") }
    summary  = "Interview: #{interview.job_posting.title}"
    location = interview.online? ? interview.meeting_link.to_s : interview.location.to_s
    desc     = [interview.mode_label, interview.meeting_link, interview.notes].compact_blank.join(" | ")

    <<~ICS
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//Deliverance//Interviews//EN
      CALSCALE:GREGORIAN
      BEGIN:VEVENT
      UID:interview-#{interview.id}@deliverance
      DTSTAMP:#{fmt.call(Time.current)}
      DTSTART:#{fmt.call(interview.scheduled_at)}
      DTEND:#{fmt.call(interview.ends_at)}
      SUMMARY:#{summary}
      DESCRIPTION:#{desc}
      LOCATION:#{location}
      STATUS:#{interview.cancelled? ? 'CANCELLED' : 'CONFIRMED'}
      END:VEVENT
      END:VCALENDAR
    ICS
  end
end
