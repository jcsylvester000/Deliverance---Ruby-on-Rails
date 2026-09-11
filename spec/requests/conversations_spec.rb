require "rails_helper"

RSpec.describe "Conversations", type: :request do
  let(:me) { create(:applicant) }
  before { sign_in me }

  def discoverable_applicant
    create(:applicant).tap { |u| u.applicant_profile.update!(discoverable: true) }
  end

  it "starts a request with an intro message and notifies the recipient" do
    other = discoverable_applicant
    expect {
      post conversations_path, params: { recipient_id: other.id, body: "hi there" }
    }.to change(Conversation, :count).by(1)
      .and change(other.notifications, :count).by(1)

    convo = Conversation.last
    expect(convo.pending_for?(other)).to be(true)
    expect(convo.messages.count).to eq(1)
  end

  it "will not message a non-discoverable applicant" do
    other = create(:applicant) # discoverable defaults to false
    expect {
      post conversations_path, params: { recipient_id: other.id, body: "hi" }
    }.not_to change(Conversation, :count)
  end

  it "holds messages until the request is accepted" do
    other = discoverable_applicant
    post conversations_path, params: { recipient_id: other.id, body: "intro" }
    convo = Conversation.last

    # Sender can't keep sending before the recipient accepts.
    post conversation_messages_path(convo), params: { body: "still there?" }
    expect(convo.messages.count).to eq(1)

    # Recipient accepts, then both can message.
    sign_in other
    patch accept_conversation_path(convo)
    post conversation_messages_path(convo), params: { body: "sure!" }
    expect(convo.reload.messages.count).to eq(2)
  end

  it "reuses an existing direct conversation instead of duplicating" do
    other = discoverable_applicant
    post conversations_path, params: { recipient_id: other.id, body: "hi" }
    expect {
      post conversations_path, params: { recipient_id: other.id, body: "again" }
    }.not_to change(Conversation, :count)
  end
end
