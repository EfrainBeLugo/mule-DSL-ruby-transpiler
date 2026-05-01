class PomGenerator
  MULE_CONNECTORS = {
    "http" => { g: "org.mule.connectors", a: "mule-http-connector", v: "1.9.3" },
    "db" => { g: "org.mule.connectors", a: "mule-db-connector", v: "1.14.0" },
    "file" => { g: "org.mule.connectors", a: "mule-file-connector", v: "1.5.2" }
  }

  def self.generate(project_name, modules)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.project(
        "xmlns" => "http://maven.apache.org/POM/4.0.0",
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd"
      ) do
        xml.modelVersion "4.0.0"
        xml.groupId "com.miempresa.integracion"
        xml.artifactId project_name
        xml.version "1.0.0-SNAPSHOT"
        xml.packaging "mule-application"
        xml.name project_name

        xml.properties do
          xml.send("project.build.sourceEncoding", "UTF-8")
          xml.send("project.reporting.outputEncoding", "UTF-8")
          xml.send("app.runtime", "4.11.3")
          xml.send("mule.maven.plugin.version", "4.7.0")
        end

        xml.build do
          xml.plugins do
            xml.plugin do
              xml.groupId "org.apache.maven.plugins"
              xml.artifactId "maven-clean-plugin"
              xml.version "3.2.0"
            end

            xml.plugin do
              xml.groupId "org.mule.tools.maven"
              xml.artifactId "mule-maven-plugin"
              xml.version "${mule.maven.plugin.version}"
              xml.extensions "true"
            end
          end
        end

          xml.dependencies do
            # 1. Dependencia base obligatoria de Mule
            xml.dependency do
              xml.groupId "org.mule.connectors"
              xml.artifactId "mule-sockets-connector"
              xml.version "1.2.3"
              xml.classifier "mule-plugin"
            end

            # 2. Dependencias dinámicas según lo usado en el .mule
            modules.each do |mod_name|
              coords = MULE_CONNECTORS[mod_name]
              if coords
                xml.dependency do
                  xml.groupId coords[:g]
                  xml.artifactId coords[:a]
                  xml.version coords[:v]
                  xml.classifier "mule-plugin" # Crucial para Mule 4
                end
              end
            end
          end

        xml.repositories do
          xml.repository do
            xml.id "mulesoft-releases"
            xml.name "MuleSoft Releases Repository"
            xml.url "https://repository.mulesoft.org/nexus/repository/releases/"
            xml.layout "default"
          end
          xml.repository do
            xml.id "anypoint-exchange-v3"
            xml.name "Anypoint Exchange"
            xml.url "https://maven.anypoint.mulesoft.com/api/v3/maven"
            xml.layout "default"
          end
        end

        xml.pluginRepositories do
          xml.pluginRepository do
            xml.id "mulesoft-releases"
            xml.name "MuleSoft Releases Repository"
            xml.url "https://repository.mulesoft.org/nexus/repository/releases/"
            xml.snapshots do
              xml.enabled "false"
            end
          end
        end
      end
    end
    builder.to_xml
  end
end