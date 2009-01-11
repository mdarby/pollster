class PollsterGenerator < Rails::Generator::Base
  attr_accessor :name, :description, :created_by_id, :created_at, :updated_at, :options, :ends_at
  
  def initialize(*runtime_args)
    super(*runtime_args)
  end

  def manifest
    record do |m|
      # m.route_resources "polls"
      
      # Controller, helper, views, and spec directories.
      m.directory(File.join('app/models'))
      m.directory(File.join('app/controllers'))
      m.directory(File.join('app/helpers'))
      m.directory(File.join('app/views'))
      
      if has_rspec?
        m.directory(File.join('spec/controllers'))
        m.directory(File.join('spec/models'))
        m.directory(File.join('spec/helpers'))
        m.directory(File.join('spec/views'))
      end
    
      m.template "#{@resource_generator}:helper.rb",
        File.join('app/helpers', controller_class_path, "#{controller_file_name}_helper.rb")

      for action in scaffold_views
        m.template(
          "#{@resource_generator}:view_#{action}.#{@default_file_extension}",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.#{default_file_extension}")
        )
      end
      
    end
  end
  
  def has_rspec?
    spec_dir = File.join(RAILS_ROOT, 'spec')
    options[:rspec] ||= (File.exist?(spec_dir) && File.directory?(spec_dir)) unless (options[:rspec] == false)
  end
  
  protected
  
    def banner
      "Usage: #{$0} #{spec.name}"
    end
    
end