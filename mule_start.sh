#!/bin/bash

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

ruby app.rb "$projectName"

if ! cd "output/$projectName"; then
    echo "Error: Project folder could not be found"
    exit 1
fi

echo "📦 Compiling con Maven..."
$MVN_HOME/bin/mvn clean package -DskipTests

echo "📂 Deploying in Mule Runtime..."

rm -rf "$MULE_HOME/apps/"*
cp target/*.jar "$MULE_HOME/apps/"
$MULE_HOME/bin/mule
