# require_relative '../builders/FlowBuilder' -> Moved down to avoid circular dependency
require_relative '../builders/ConfigBuilder'

class MuleDSL
  attr_reader :used_modules

  def initialize(xml_node)
    @xml = xml_node
    @used_modules = Set.new
  end

  def mule_app(&block)
    instance_eval(&block)
  end

  def flow(name, &block)
    create_container('flow', name, &block)
  end

  def sub_flow(name, &block)
    create_container('sub-flow', name, &block)
  end

  def http_listener_config(name, &block)
    @used_modules.add('http')
    @used_modules.add('sockets')
    builder = ConfigBuilder.new(name, @xml)
    builder.process("http:listener-config", &block)
  end

  def http_request_config(name, &block)
    @used_modules.add('http')
    builder = ConfigBuilder.new(name, @xml)
    builder.process("http:request-config", &block)
  end
  
  def db_config(name, &block)
    @used_modules.add('db')
    builder = ConfigBuilder.new(name, @xml)
    builder.process("db:config", &block)
  end

  def error_handler(name, &block)
    if self.is_a?(FlowBuilder)
      # In FlowBuilder (inline error handler)
      @xml.send("error-handler") do
        instance_eval(&block) if block_given?
      end
    else
      # In MuleDSL (global error handler)
      create_container('error-handler', name, &block)
    end
  end

  private
  def create_container(tag_name, element_name, &block)
    require_relative '../builders/FlowBuilder'
    builder = FlowBuilder.new(tag_name, element_name, @xml)
    builder.process(&block)
  end

end
