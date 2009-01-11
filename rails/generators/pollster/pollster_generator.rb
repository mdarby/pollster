class PollsterGenerator < Rails::Generator::Base
  attr_accessor :name, :description, :created_by_id, :created_at, :updated_at, :options, :ends_at
  
  def initialize(*runtime_args)
    super(*runtime_args)
  end

  def manifest
    record do |m|
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      
      map_routes(m)
      
      m.directory(File.join('app/models'))
      m.directory(File.join('app/controllers'))
      m.directory(File.join('app/helpers'))
      m.directory(File.join('app/views'))
      m.directory(File.join('app/views/polls'))
      m.directory(File.join('db/migrate'))
      
      if has_rspec?
        m.directory(File.join('spec/controllers'))
        m.directory(File.join('spec/models'))
        m.directory(File.join('spec/helpers'))
        m.directory(File.join('spec/views'))
      end
      
      m.file "polls_controller.rb", File.join('app/controllers', "polls_controller.rb")
      m.file "poll.rb", File.join('app/models', "poll.rb")
      m.file "poll_vote.rb", File.join('app/models', "poll_vote.rb")
      m.file "polls_helper.rb", File.join('app/helpers', "polls_helper.rb")
      
      m.file "create_pollster_tables.rb", File.join('db/migrate', "#{timestamp}_create_pollster_tables.rb")
      
      for view in views
        m.file "views/#{view}.html.haml", File.join('app/views/polls', "#{view}.html.haml")
      end
      
    end
  end
  
  def map_routes(m)
    route_string = ":polls, :member => { :vote => :post }"
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

  def model_name 
    class_name.demodulize
  end
  
  protected
  
    def banner
      "Usage: #{$0} #{spec.name}"
    end
    
end