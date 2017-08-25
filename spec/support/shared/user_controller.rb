shared_examples_for "UserController returns errors" do
  it "returns 422 status" do
    subject
    expect(response).to have_http_status(422)
  end

  it "returns errors" do
    subject
    expect(response.body).to be_json_eql(errors.to_json).at_path("errors")
  end
end