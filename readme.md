# Name?? To be determined ⚒️

**A Ruby-based DSL for generating MuleSoft applications.**

This is an experimental transpiler that allows MuleSoft developers to define integrations using an elegant Ruby-inspired syntax, eliminating the need to manually write complex XML files and the use of the lifelong IDE.

> ⚠️ **Status: Alpha / Work in Progress** > This project is a Proof of Concept (PoC). It is not recommended for production use yet. Functionalities and syntax may change significantly.

---

## ✨ Features

- **Minimalist Syntax:** Define flows, sub-flows, and configurations with Ruby-like readability.
- **Automatic Project Generation:** Creates the standard Maven folder structure (`src/main/mule`, etc.).
- **Dynamic Dependency Management:** Detects which connectors you use (HTTP, DB, etc.) and generates the `pom.xml` with the necessary dependencies. (Only working for HTTP for now).

## 🚀 Quick Start

### Prerequisites

- **Ruby 3.2+** (Tested in 4.0.2 using `asdf`)
- **Apache Maven 3.8+** Set  `MVN_HOME` environment variable to the path of your Maven installation.
- **Mule Runtime 4.x** (Standalone for local deployment and testing) Need to add `MULE_HOME` environment variable to the path of your Mule installation.

### First Project

1. clone the repository:
   ```bash
   git clone https://github.com/EfrainBeLugo/mule-DSL-ruby-transpiler.git
   cd mule-DSL-ruby-transpiler

2. Create a new folder `input/` and place your `.mule` files in there. The output mule project will be generated in `output/` following the same structure.
Here is an example of a `.mule` file:
   ```ruby
   mule_app "my-fist-project" do
   
     http_listener_config "HTTP_Listener_config" do
       http_listener_connection host: "0.0.0.0", port: 8081
     end
   
     flow "hello-world-flow" do
       http_listener config: "HTTP_Listener_config", path: "/hello"
       set_payload value: "#[payload.message]"
     end
   
   end

3. Run `./mule_start.sh -p "my-app"` where `my-app` is the name of the project you want to generate.
4. If you have all ready you should be able to hit `http://localhost:8081/hello` and see the message "Hello World!"

### 🗺️ Roadmap / Next Steps
- [x] Support for automatic project generation.
- [ ] Support for most popular connectors and components.
- [ ] Support for most common dependencies (HTTP, DB, Salesforce, Anypoint MQ, etc).
- [ ] Support for error-handler and reconnection strategies.
- [ ] Integration with external DataWeave (.dwl) files.
- [ ] Support for more connectors (Database, Salesforce, Anypoint MQ).
- [ ] ???

### 🤝 Contributions
Contributions are welcome! If you have an idea to improve the syntax or want to add support for a new Mule component, please open a Pull Request or create an Issue.

### Disclaimer
This is an independent tool and is not affiliated with, endorsed, or sponsored by MuleSoft, LLC or Salesforce, Inc. MuleSoft and Anypoint Platform are registered trademarks of Salesforce, Inc.
