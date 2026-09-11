require "rails_helper"

RSpec.describe "Applicant groups", type: :request do
  let(:me) { create(:applicant) }
  before { sign_in me }

  it "creates a group with the creator as a member" do
    expect {
      post applicant_groups_path, params: { title: "Prep Squad" }
    }.to change(Conversation, :count).by(1)

    group = Conversation.last
    expect(group.group?).to be(true)
    expect(group.member?(me)).to be(true)
  end

  it "requires a name" do
    expect {
      post applicant_groups_path, params: { title: "  " }
    }.not_to change(Conversation, :count)
  end

  it "joins an open group" do
    owner = create(:applicant)
    group = Conversation.create!(kind: :group, title: "Open Group", creator: owner)
    group.conversation_participants.create!(user: owner, status: :accepted)

    expect {
      post join_applicant_group_path(group)
    }.to change { group.conversation_participants.count }.by(1)
    expect(group.reload.member?(me)).to be(true)
  end

  it "lets a member post in the group thread" do
    group = Conversation.create!(kind: :group, title: "Chat", creator: me)
    group.conversation_participants.create!(user: me, status: :accepted)

    post conversation_messages_path(group), params: { body: "hello team" }
    expect(group.messages.count).to eq(1)
  end
end
