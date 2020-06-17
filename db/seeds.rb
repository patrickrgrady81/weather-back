User.destroy_all
User.create!(email:"pat@pat.com", password:"password", password_confirmation:"password", city:"Philadelphia, PA")

puts "Created #{ActionController::Base.helpers.pluralize(User.all.count, 'User')}..."