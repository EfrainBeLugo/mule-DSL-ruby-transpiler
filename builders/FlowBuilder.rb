
class FlowBuilder < MuleDSL
  def initialize(tag_name, name, xml)
    @tag_name = tag_name
    @name = name
    @xml = xml
    @used_modules = Set.new # Although it should probably report back to the main engine
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

  def transform(doc_name: "Transform Message", &block)
    @xml['ee'].transform("doc:name" => doc_name) do
      instance_eval(&block) if block_given?
    end
  end

  def message(&block)
    @xml['ee'].message do
      instance_eval(&block) if block_given?
    end
  end

  def set_payload_dw(expression)
    @xml['ee'].send("set-payload") { @xml.text expression }
  end

  def db_select(config:, doc_name: "Select", &block)
    @xml['db'].select("config-ref" => config, "doc:name" => doc_name) do
      instance_eval(&block) if block_given?
    end
  end

  def sql(query)
    @xml['db'].sql { @xml.text query }
  end

  def choice(doc_name: "Choice", &block)
    @xml.choice("doc:name" => doc_name) do
      instance_eval(&block) if block_given?
    end
  end

  def when_expression(expression, &block)
    @xml.send("when", "expression" => expression) do
      instance_eval(&block) if block_given?
    end
  end

  def otherwise(&block)
    @xml.otherwise do
      instance_eval(&block) if block_given?
    end
  end

  def foreach(collection: "#[payload]", doc_name: "For Each", &block)
    @xml.foreach("collection" => collection, "doc:name" => doc_name) do
      instance_eval(&block) if block_given?
    end
  end

  def on_error_propagate(type: "ANY", doc_name: "On Error Propagate", &block)
    @xml.send("on-error-propagate", "type" => type, "doc:name" => doc_name) do
      instance_eval(&block) if block_given?
    end
  end

  def on_error_continue(type: "ANY", doc_name: "On Error Continue", &block)
    @xml.send("on-error-continue", "type" => type, "doc:name" => doc_name) do
      instance_eval(&block) if block_given?
    end
  end
end