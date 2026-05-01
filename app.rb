# TODO: LOGIC TO GET INFO ABOUT MULE RUNTIME VERSION, PROJECT NAME, ETC.

require 'nokogiri'
require 'fileutils'

require_relative 'engine/MuleDSL'
require_relative 'generators/PomGenerator'
require_relative 'generators/MuleArtifactGenerator'

class MuleTranspiler

  def initialize
    @used_modules = []
  end
  def run(input_file, project_name)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      # Defining the root node 'mule' without the namespace prefix yet
      xml.mule do
        # Injecting the namespace definitions
        xml.parent.add_namespace_definition("doc", "http://www.mulesoft.org/schema/mule/documentation")
        xml.parent.add_namespace_definition("http", "http://www.mulesoft.org/schema/mule/http")
        xml.parent.add_namespace_definition("xsi", "http://www.w3.org/2001/XMLSchema-instance")

        # Setting namespace and schemaLocation
        xml.parent["xmlns"] = "http://www.mulesoft.org/schema/mule/core"
        xml.parent["xsi:schemaLocation"] = "http://www.mulesoft.org/schema/mule/core http://www.mulesoft.org/schema/mule/core/current/mule.xsd http://www.mulesoft.org/schema/mule/http http://www.mulesoft.org/schema/mule/http/current/mule-http.xsd http://www.mulesoft.org/schema/mule/ee/core http://www.mulesoft.org/schema/mule/ee/core/current/mule-ee.xsd"

        # Processing DSL content
        dsl_content = File.read(input_file)
        engine = MuleDSL.new(xml)
        engine.instance_eval(dsl_content)
        @used_modules.concat(engine.used_modules.to_a)

      end
    end

    # Creating output directory structure
    FileUtils.mkdir_p("output/#{project_name}")
    FileUtils.mkdir_p("output/#{project_name}/src/main/mule")

    output_name = input_file.gsub('.mule', '.xml')

    FileUtils.mkdir_p("output/#{project_name}/src/main/mule/#{output_name.split('/')[1..-2].join('/')}")
    File.write("output/#{project_name}/src/main/mule/#{output_name.gsub('input/', '')}", builder.to_xml)
    puts "Transpilation completed!"
  end

  def generate_project(project_name)
    MuleArtifactGenerator.generate(project_name)
    pom = PomGenerator.generate(project_name, @used_modules.to_a)
    File.write("output/#{project_name}/pom.xml", pom)
    puts "POM.xml generated with #{@used_modules.count} dependencies!"
  end
end

project_name = ARGV[0]
# Exec
# MuleTranspiler.run('input/src/main/mule/poc-dsl-mule.mule', project_name)
files = Dir.glob("input/**/*.mule")
transpiler = MuleTranspiler.new
files.each do |file|
  transpiler.run(file, project_name)
end
transpiler.generate_project(project_name)