class PollsterGenerator < Rails::Generator::NamedBase
  
  def initialize(*runtime_args)
    super(*runtime_args)
  end

  def manifest
    record do |m|
      install_routes(m)
      
      m.directory(File.join('app/models'))
      m.directory(File.join('app/controllers'))
      m.directory(File.join('app/helpers'))
      m.directory(File.join('app/views'))
      m.directory(File.join("app/views/#{table_name}"))
      m.directory(File.join('db/migrate'))
      
      if has_rspec?
        m.directory(File.join('spec/controllers'))
        m.directory(File.join('spec/models'))
        m.directory(File.join('spec/helpers'))
        m.directory(File.join('spec/views'))
        m.directory(File.join("spec/views/#{table_name}"))
        
        # Controllers
        m.template "spec/polls_controller_spec.rb", File.join('spec/controllers', "#{table_name}_controller_spec.rb")
        m.template "spec/polls_routing_spec.rb", File.join('spec/controllers', "#{table_name}_routing_spec.rb")
        
        # Models
        m.template "spec/poll_spec.rb", File.join('spec/models', "#{table_name.singularize}_spec.rb")
        m.template "spec/poll_vote_spec.rb", File.join('spec/models', "#{table_name.singularize}_vote_spec.rb")

        # Helpers
        m.template "spec/polls_helper_spec.rb", File.join('spec/helpers', "#{table_name}_helper_spec.rb")
      end
      
      # Controllers
      m.template "polls_controller.rb", File.join('app/controllers', "#{table_name}_controller.rb")
      
      # Models
      m.template "poll.rb", File.join('app/models', "#{table_name.singularize}.rb")
      m.template "poll_vote.rb", File.join('app/models', "#{table_name.singularize}_vote.rb")
      
      # Helpers
      m.template "polls_helper.rb", File.join('app/helpers', "#{table_name}_helper.rb")
      
      # Migrations
      m.migration_template "create_pollster_tables.rb", "db/migrate", :migration_file_name => "create_pollster_tables"
      
      # Views
      for view in views
        new_name = (view == "_poll") ? "_#{object_name}" : view
        m.template "views/#{view}.html.erb", File.join("app/views/#{table_name}", "#{new_name}.html.erb")
      end
      
    end
  end
  
  def table_name
    class_name.tableize
  end
  
  def model_name 
    class_name.demodulize
  end
  
  def object_name
    table_name.singularize
  end
  
  def install_routes(m)
    route_string = ":#{table_name}, :member => { :vote => :post }"
    def route_string.to_sym; to_s; end
    def route_string.inspect; to_s; end
    m.route_resources route_string
  end
  
  def has_rspec?
    spec_dir = File.join(RAILS_ROOT, 'spec')
    options[:rspec] ||= (File.exist?(spec_dir) && File.directory?(spec_dir)) unless (options[:rspec] == false)
  end
  
  def views
    %w[ _current_results _final_results _option_form _poll _vote edit index new ]
  end
  
  protected
  
    def banner
      "Usage: #{$0} #{spec.name}"
    end
    
end