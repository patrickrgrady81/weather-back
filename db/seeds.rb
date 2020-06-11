User.destroy_all
User.create!(email:"pat@pat.com", password:"pat", password_confirmation:"pat")

puts "Created #{ActionController::Base.helpers.pluralize(User.all.count, 'User')}..."