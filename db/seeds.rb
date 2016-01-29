require_relative 'plivo'

company_lines = ['Mainoffice', 'Salesnumber', 'SupportNumber']
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

# Clear data generated
#plivo.delete_application
#plivo.delete_endpoints
