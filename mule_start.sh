#!/bin/zsh

# Cargar el PATH del sistema para encontrar ruby y mvn
#export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

MULE_HOME="${MULE_HOME}"
MVN_HOME="${MVN_HOME}"

echo "Usando MULE_HOME en: $MULE_HOME"

while getopts "p:" opt; do
  case $opt in
    p) projectName="$OPTARG" ;;
    *) echo "Uso: $0 -p nombre_proyecto"; exit 1 ;;
  esac
done

if [ -z "$projectName" ]; then
    echo "Error: Debes especificar un nombre de proyecto con -p"
    exit 1
fi

echo "🚀 Iniciando transpilación: $projectName"

# 1. Ejecutar Ruby pasando el nombre del proyecto como argumento
# Modificaremos app.rb para que acepte argumentos
ruby app.rb "$projectName"

# 2. Entrar al directorio de salida
cd "output/$projectName" || { echo "Error: No se encontró la carpeta del proyecto"; exit 1 }

# 3. Compilar con Maven (usando la ruta absoluta si es necesario)
echo "📦 Compilando con Maven..."
$MVN_HOME/bin/mvn clean package -DskipTests

# 4. Limpiar y Desplegar en el Standalone de Mule
#MULE_HOME="/Users/efrainbe/Dev/Mulesoft/mule-enterprise-standalone-4.11.3"
echo "📂 Desplegando en Mule Runtime..."

rm -rf "$MULE_HOME/apps/"*
cp target/*.jar "$MULE_HOME/apps/"
$MULE_HOME/bin/mule

#echo "✅ Proceso completado para $projectName"