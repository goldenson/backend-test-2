# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#

#[X] Create SIP endpoints on Plivo for the caller and the users' apps.

#[X] Create Application and SIP endpoints you'll use for company's numbers.

#[X] Create a Call model in order to store call history and voicemails.

#[X] Redirect incoming calls to users' apps by interacting with Plivo.

class PlivoAPI
  include Plivo

  def initialize
    @AUTH_ID = ENV['AUTH_ID']
    @AUTH_TOKEN = ENV['AUTH_TOKEN']
    @plivo = RestAPI.new(@AUTH_ID, @AUTH_TOKEN)
  end

  def create_endpoint_app(app_name, user_id)
    params = {
      'username' => app_name, # The username for the endpoint to be created
      'password' => 'qwertyuiop', # The password for your endpoint username
      'alias' => app_name # Alias for this endpoint
    }
    response = @plivo.create_endpoint(params)
    puts response
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
     Create a new application
    response = @plivo.create_application(params)
    puts response
  end
end


company_lines = ['Mainoffice2', 'Salesnumber2', 'SupportNumber2']
users = ['Jane', 'Peter', 'Luke']
user_apps = ['Mobile', 'Tablet', 'Desktop']

plivo = PlivoAPI.new

plivo.create_application

users.each do |user|
  user = User.create(name: user)
  user_apps.each do |app|
    plivo.create_endpoint_app(app, user.id)
  end
end

company_lines.each do |line|
  plivo.create_endpoint_line(line)
end

plivo.create_endpoint_line('Max')
