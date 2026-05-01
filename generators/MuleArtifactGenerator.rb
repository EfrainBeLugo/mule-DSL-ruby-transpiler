require 'json'

class MuleArtifactGenerator
  def self.generate(project_name)
    json_content = {
      "minMuleVersion" => "4.9.0",
      "javaSpecificationVersion" => ["17"],
    }

    File.write("output/#{project_name}/mule-artifact.json", json_content.to_json)
    puts "Mule artifact generated!"
  end
end