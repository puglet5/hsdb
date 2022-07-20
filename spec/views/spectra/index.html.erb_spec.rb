require 'rails_helper'

RSpec.describe "spectra/index", type: :view do
  before(:each) do
    assign(:spectra, [
      Spectrum.create!(
        title: "Title"
      ),
      Spectrum.create!(
        title: "Title"
      )
    ])
  end

  it "renders a list of spectra" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
  end
end
