
class FlowBuilder
  def initialize(tag_name, name, xml)
    @tag_name = tag_name
    @name = name
    @xml = xml
  end

  def process(&block)
    @xml.send(@tag_name, "name" => @name) do
      instance_eval(&block)
    end
  end

  def http_listener(config: '', path: '', doc_name: "Listener")

    @xml['http'].send(
      "listener",
      "config-ref" => config,
      "path" => path,
      "doc:name" => doc_name
    )

  end

  def logger(message: '', level: 'INFO',doc_name: "Logger")
    @xml.logger(
      "message" => message,
      "level" => level,
      "doc:name" => doc_name
    )
  end

  def set_variable(name: '', value: '', doc_name: "Set Variable")

    @xml.send(
      "set-variable",
      "variableName" => name,
      "value" => value,
    )
  end

  def set_payload(value: '', doc_name: "Set Payload")
    @xml.send(
      "set-payload",
      "value" => value,
    )
  end

  def flow_ref(name: '', doc_name: "Flow Reference")
    @xml.send(
      "flow-ref",
      "name" => name,
      "doc:name" => doc_name
    )
  end
end