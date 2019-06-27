class ActiveSupport::TestCase
  def create_full_user
    @@user ||= begin
      user = User.create!(
        :email                 => 'fulluser@test.com',
        :password              => '123456',
        :password_confirmation => '123456'
      )
      @@user = user
      user
    end
  end

  def create_and_signin_gauth_user
    testuser = create_full_user
    sign_in_as_user(testuser)
    visit user_displayqr_path
    check 'user_gauth_enabled'
    fill_in('user_gauth_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now))
    click_button 'Continue...'

    Capybara.reset_sessions!

    sign_in_as_user(testuser)
    testuser
  end

  def sign_in_as_user(user = nil)
    user ||= create_full_user
    resource_name = user.class.name.underscore
    visit send("new_#{resource_name}_session_path")
    fill_in "#{resource_name}_email", :with => user.email
    fill_in "#{resource_name}_password", :with => user.password
    click_button 'Log in'
  end
 
  # Helpers for creating new users
  #
  def generate_unique_email
    @@email_count ||= 0
    @@email_count += 1
    "test#{@@email_count}@email.com"
  end

  def valid_attributes(attributes={})
    { :email => generate_unique_email,
      :password => '123456',
      :password_confirmation => '123456' }.update(attributes)
  end

  def new_user(attributes={})
    user = User.new(valid_attributes(attributes))
    user.save
    user
  end

end
