
class ConfigBuilder
  def initialize(name, xml)
    @name = name
    @xml = xml
  end

  def process(&block)
    @xml["http"].send("listener-config", "name" => @name) do
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
end