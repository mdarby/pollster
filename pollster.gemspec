Gem::Specification.new do |s|
  s.name     = "pollster"
  s.version  = "0.1"
  s.date     = "2009-01-11"
  s.summary  = "Easy user polling for your Rails app"
  s.email    = "matt@matt-darby.com"
  s.homepage = "http://github.com/mdarby/pollster"
  s.description = "A Rails gem that generates an entire MVC stack for user polling on your Rails 2x app"
  s.has_rdoc = false
  s.authors  = ["Matt Darby"]
  s.files    = [
    "MIT-LICENSE",
    "README.textile",
    "Rakefile",
    "init.rb",
    "install.rb",
    "generators/pollster/pollster_generator.rb",
    "generators/pollster/templates/create_pollster_tables.rb",
    "generators/pollster/templates/poll.rb",
    "generators/pollster/templates/poll_vote.rb",
    "generators/pollster/templates/polls_controller.rb",
    "generators/pollster/templates/polls_helper.rb",
    "generators/pollster/templates/spec/poll_spec.rb",
    "generators/pollster/templates/spec/poll_vote_spec.rb",
    "generators/pollster/templates/spec/polls_controller_spec.rb",
    "generators/pollster/templates/spec/polls_helper_spec.rb",
    "generators/pollster/templates/spec/polls_routing_spec.rb",
    "generators/pollster/templates/views/_current_results.html.erb",
    "generators/pollster/templates/views/_final_results.html.erb",
    "generators/pollster/templates/views/_option_form.html.erb",
    "generators/pollster/templates/views/_poll.html.erb",
    "generators/pollster/templates/views/_vote.html.erb",
    "generators/pollster/templates/views/edit.html.erb",
    "generators/pollster/templates/views/index.html.erb",
    "generators/pollster/templates/views/new.html.erb",
    "generators/pollster/USAGE",
    "uninstall.rb"
  ]
end