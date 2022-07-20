# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spectra/show', type: :view do
  before(:each) do
    @spectrum = assign(:spectrum, Spectrum.create!(
                                    title: 'Title'
                                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
  end
end
