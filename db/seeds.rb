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

#[] Create Application and SIP endpoints you'll use for company's numbers.

#[X] Create a Call model in order to store call history and voicemails.

#[X] Redirect incoming calls to users' apps by interacting with Plivo.

company_lines = ['Mainoffice2', 'Salesnumber2', 'SupportNumber2']

def create_endpoints(params_array, user_id)
  include Plivo
  p = RestAPI.new('MAMDE0NWVKM2ZKYJA5ZT', 'OTI2ODg4MzAwYjBmMDdhN2ZmMzhiNzg0NTIyMmQx')

  params_array.each do |line|
    params = {
      'username' => line, # The username for the endpoint to be created
      'password' => 'qwertyuiop', # The password for your endpoint username
      'alias' => line # Alias for this endpoint
    }
    response = p.create_endpoint(params)
    return if params_array == ['Max']
    if user_id != 0
      UserNumber.create(user_id: user_id, sip_endpoint: response[1]['username'] + '@phone.plivo.com')
    else
      CompanyNumber.create(sip_endpoint: response[1]['username'] + '@phone.plivo.com')
    end
    print response
  end
end


users = ['Jane', 'Peter', 'Luke']
user_apps = ['Mobile', 'Tablet', 'Desktop']

#users.each do |user|
  #user = User.create(name: user)
  #create_endpoints(user_apps, user.id)
#end

#create_endpoints(company_lines, 0)


caller_user = ['Max']
create_endpoints(caller_user, 0)
