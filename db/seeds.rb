[
  "ProjectA1", 
  "ProjectB1", 
  "ProjectC1"
].each do |project_name|
  project = Project.create!(name: project_name)
  puts "Created project #{project_name}"
end

[
  "Admin", 
  "User", 
  "Guest"
].each do |role_name|
  role = Role.create(name: role_name)
  puts "Created role #{role_name}"
end

[
  "San Francisco",
  "San Diego",
  "Los Angeles",
  "Portland",
  "Las Vegas",
  "Miami",
  "New York",
  "Chicago",
  "Boston",
  "Detroit"
].each do |location_name|
  location = Location.create(name: location_name)
  puts "Created location #{location_name}"
end


def adduser(email, password, name, projects, roles, locations)
  @user = User.invite!(email: email, name: name, projects: projects, roles: roles, locations: locations) do |u|
    u.skip_invitation = true
  end
  token = Devise::VERSION >= "3.1.0" ? @user.instance_variable_get(:@raw_invitation_token) : @user.invitation_token
  if User.accept_invitation!(:invitation_token => token, :password => password, :password_confirmation => password)
    location_names = []
    @user.locations.each {|location| location_names << location.name }
    puts "Created User #{email} with password #{password}"
    puts " and assigned to project #{@user.projects.first.name} with role #{@user.roles.first.name} and locations #{location_names}."
  end
end

user1 = adduser("user1@example.com", "qwertyIsB@dP@$$w0rd!", "Jack Smith", [Project.first], [Role.first], [Location.first])
user2 = adduser("user2@example.com", "qwertyIsB@dP@$$w0rd!", "Jim Kerry", [Project.second], [Role.second], [Location.second, Location.third])
user3 = adduser("user3@example.com", "qwertyIsB@dP@$$w0rd!", "John Doe", [Project.third], [Role.second], [Location.first, Location.last])

# hmmm... same passwords? Naughty seeds! ;)
