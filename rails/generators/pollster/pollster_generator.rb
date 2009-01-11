class PollsterGenerator < Rails::Generator::Base
  attr_accessor :name, :created_by_id, :created_at, :updated_at, :options, :ends_at
  
  def initialize(*runtime_args)
    super(*runtime_args)
  end

  def manifest
    record do |m|
      m.route_resources "polls"
    end
  end
  
  protected
  
    def banner
      "Usage: #{$0} #{spec.name}"
    end
    
end