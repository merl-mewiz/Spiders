# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create admin
user = User.new
user.email = 'use4all@mail.ru'
user.password = '7550055'
user.password_confirmation = '7550055'
user.save!

# Create statuses
status_new = Status.new
status_new.title = 'New'
status_new.color_class = 'text-bg-primary'
status_new.save!

status_in_progress = Status.new
status_in_progress.title = 'In progress'
status_in_progress.color_class = 'text-bg-warning'
status_in_progress.save!

status_in_performed = Status.new
status_in_performed.title = 'Performed'
status_in_performed.color_class = 'text-bg-success'
status_in_performed.save!

status_overdue = Status.new
status_overdue.title = 'Overdue'
status_overdue.color_class = 'text-bg-danger'
status_overdue.save!

status_closed = Status.new
status_closed.title = 'Closed'
status_closed.color_class = 'text-bg-light'
status_closed.save!

status_canceled = Status.new
status_canceled.title = 'Сanceled'
status_canceled.color_class = 'text-bg-dark'
status_canceled.save!

# Create priorities
priority_normal = Priority.new
priority_normal.title = 'Normal'
priority_normal.color_class = 'text-primary'
priority_normal.save!

priority_low = Priority.new
priority_low.title = 'Low'
priority_low.color_class = 'text-secondary'
priority_low.save!

priority_high = Priority.new
priority_high.title = 'High'
priority_high.color_class = 'text-danger'
priority_high.save!
