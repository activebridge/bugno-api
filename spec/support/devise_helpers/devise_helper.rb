module DeviseHelper
  def login(user)
    post user_session_path, params:  {  email:    user.email,
                                        password: user.password }.to_json,
                            headers: {  'CONTENT_TYPE'  => 'application/json',
                                        'ACCEPT'        => 'application/json' }
  end
end
