require "rails_helper"

RSpec.describe Conversation, type: :model do
  let(:a) { create(:applicant) }
  let(:b) { create(:applicant) }

  def direct(creator, invitee)
    convo = Conversation.create!(kind: :direct, creator: creator)
    convo.conversation_participants.create!(user: creator, status: :accepted)
    convo.conversation_participants.create!(user: invitee, status: :invited)
    convo
  end

  it "is not open until everyone has accepted" do
    convo = direct(a, b)
    expect(convo.open_for?(a)).to be(false)
    expect(convo.pending_for?(b)).to be(true)

    convo.participant_for(b).update!(status: :accepted)
    expect(convo.reload.open_for?(a)).to be(true)
  end

  it "is not open when a participant has blocked it" do
    convo = direct(a, b)
    convo.participant_for(b).update!(status: :blocked)
    expect(convo.reload.open_for?(a)).to be(false)
  end

  it "finds an existing direct conversation between two users" do
    convo = direct(a, b)
    expect(Conversation.direct_between(a, b)).to eq(convo)
    expect(Conversation.direct_between(a, create(:applicant))).to be_nil
  end
end
