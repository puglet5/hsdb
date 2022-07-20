# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spectra/edit', type: :view do
  before(:each) do
    @spectrum = assign(:spectrum, Spectrum.create!(
                                    title: 'MyString'
                                  ))
  end

  it 'renders the edit spectrum form' do
    render

    assert_select 'form[action=?][method=?]', spectrum_path(@spectrum), 'post' do
      assert_select 'input[name=?]', 'spectrum[title]'
    end
  end
end
