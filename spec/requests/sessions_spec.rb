# frozen_string_literal: true

RSpec.fdescribe 'Sessions' do
  let(:user) { User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password') }

  it 'signs user in and out' do
    sign_in user
    get root_path
    expect(response)
      .to render_template('pages/home')

    sign_out user
    get root_path
    expect(response)
      .not_to render_template('login')
  end

  it 'checks the presence of current_user' do
    sign_in user
    get root_path
    expect(controller.current_user)
      .to eq(user)

    sign_out user
    get root_path
    expect { controller.current_user }
      .to raise_error(NoMethodError)
  end
end
