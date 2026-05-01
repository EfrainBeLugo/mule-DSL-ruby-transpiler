
class ConfigBuilder
  def initialize(name, xml)
    @name = name
    @xml = xml
  end

  def process(tag, &block)
      @xml.send(tag, "name" => @name) do
      instance_eval(&block)
    end
  end

  def http_listener_connection(host:, port:)
    @xml['http'].send(
        "listener-connection",
        "host" => host,
        "port" => port.to_s
      )
  end

  def http_request_connection(host:, port:, protocol: 'HTTPS')
    @xml['http'].send(
        "request-connection",
        "host" => host,
        "port" => port.to_s,
        "protocol" => protocol
      )
  end
end