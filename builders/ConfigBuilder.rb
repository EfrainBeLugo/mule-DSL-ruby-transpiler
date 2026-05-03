
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

  def db_connection(host:, port: 3306, user:, password:, database:)
    @xml['db'].send(
      "my-sql-connection",
      "host" => host,
      "port" => port.to_s,
      "user" => user,
      "password" => password,
      "database" => database
    )
  end
end