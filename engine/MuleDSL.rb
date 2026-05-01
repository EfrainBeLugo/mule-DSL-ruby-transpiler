require_relative '../builders/FlowBuilder'
require_relative '../builders/ConfigBuilder'

class MuleDSL
  attr_reader :used_modules

  def initialize(xml_node)
    @xml = xml_node
    @used_modules = Set.new
  end

  def mule_app(name, &block)
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
    builder.process(&block)
  end

  private
  def create_container(tag_name, element_name, &block)
    builder = FlowBuilder.new(tag_name, element_name, @xml)
    builder.process(&block)
  end

end
