#!/bin/zsh

# Cargar el PATH del sistema para encontrar ruby y mvn
#export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

MULE_HOME="${MULE_HOME}"
MVN_HOME="${MVN_HOME}"

echo "Using MULE_HOME en: $MULE_HOME"

while getopts "p:" opt; do
  case $opt in
    p) projectName="$OPTARG" ;;
    *) echo "Uso: $0 -p project_name"; exit 1 ;;
  esac
done

if [ -z "$projectName" ]; then
    echo "Error: You should specify a project name with -p"
    exit 1
fi

echo "🚀 Starting transpilation: $projectName"

# 1. Ejecutar Ruby pasando el nombre del proyecto como argumento
# Modificaremos app.rb para que acepte argumentos
ruby app.rb "$projectName"

# 2. Entrar al directorio de salida
cd "output/$projectName" || { echo "Error: Project folder could not be found"; exit 1 }

# 3. Compilar con Maven (usando la ruta absoluta si es necesario)
echo "📦 Compiling con Maven..."
$MVN_HOME/bin/mvn clean package -DskipTests

# 4. Limpiar y Desplegar en el Standalone de Mule
#MULE_HOME="/Users/efrainbe/Dev/Mulesoft/mule-enterprise-standalone-4.11.3"
echo "📂 Deploying in Mule Runtime..."

rm -rf "$MULE_HOME/apps/"*
cp target/*.jar "$MULE_HOME/apps/"
$MULE_HOME/bin/mule
