shared_examples_for "UserLogic.create" do
  subject { AdvertiserLogic.create(params: advertiser_params)  }

  it "new Advertise saved to database" do
    expect { subject }.to change(Advertiser, :count).by(1)
  end

  it "new User saved to database" do
    expect { subject }.to change(User, :count).by(1)
  end
end