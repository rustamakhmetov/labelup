shared_examples_for "Advertiser with invalid attributes" do
  subject { object.save }

  it "don't save user to database" do
    expect { subject }.to_not change(User, :count)
  end

  it "don't save advertiser to database" do
    expect { subject }.to_not change(Advertiser, :count)
  end

  it "exists errors" do
    subject
    expect(object.errors.full_messages).to match_array(errors)
  end
end