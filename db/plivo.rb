class PlivoAPI
  include Plivo
  attr_accessor :application_id
  attr_accessor :endpoints_id

  def initialize
    @AUTH_ID = ENV['AUTH_ID']
    @AUTH_TOKEN = ENV['AUTH_TOKEN']
    @plivo = RestAPI.new(@AUTH_ID, @AUTH_TOKEN)
    @application_id = []
    @endpoints_id = []
  end

  def create_endpoint_app(app_name, user_id)
    params = {
      'username' => app_name, # The username for the endpoint to be created
      'password' => 'qwertyuiop', # The password for your endpoint username
      'alias' => app_name # Alias for this endpoint
    }
    response = @plivo.create_endpoint(params)
    puts response
    @endpoints_id << response[1]['endpoint_id']
    UserNumber.create(user_id: user_id, sip_endpoint: response[1]['username'] + '@phone.plivo.com')
  end


  def create_endpoint_line(line)
    params = {
      'username' => line, # The username for the endpoint to be created
      'password' => 'qwertyuiop', # The password for your endpoint username
      'alias' => line # Alias for this endpoint
    }
    response = @plivo.create_endpoint(params)
    puts response
    @endpoints_id << response[1]['endpoint_id']
    return if line == 'Max'
    CompanyNumber.create(sip_endpoint: response[1]['username'] + '@phone.plivo.com')
  end

  def create_application
    params = {
      # The URL Plivo will fetch when a call executes this application
      'answer_url' => 'https://aircall.herokuapp.com/forward',
      'answer_method' => 'GET',
      'hangup_url' => 'https://aircall.herokuapp.com/hangup',
      'hangup_method' => 'GET',
      'app_name' => 'Forward test Application', # The name of your application
      'default_endpoint_app' => true # The name of your application
    }
    response = @plivo.create_application(params)
    @application_id << response[1]['app_id']
    puts response
  end

  def delete_application
    @application_id.each do |app_id|
      params = {
        'app_id' => app_id
      }
      response = @plivo.delete_application(params)
      puts response
    end
  end

  def delete_endpoints
    @endpoints_id.each do |endpoint_id|
      params = {
        'endpoint_id' => endpoint_id
      }
      response = @plivo.delete_endpoint(params)
      puts response
    end
  end
end
