#!/bin/bash

rm -rf dist
mkdir -p dist

VERSION="0.5.8"
folder="spectre-${VERSION}"
if [ ! -d ${folder} ]; then
    filename="v${VERSION}.tar.gz"
    curl -OL https://github.com/picturepan2/spectre/archive/${filename}
    tar xvfz ${filename}
    rm ${filename}
fi

cp gulpfile.js ${folder}/

pushd ${folder}

if [ ! -d "node_modules" ]; then
    npm install -D gulp@^4
    npm install
fi

file="src/_variables.scss"

declare -A colors

colors["default"]="#5755d9"
colors["red"]="#F44336"
colors["pink"]="#E91E63"
colors["purple"]="#9C27B0"
colors["deep_purple"]="#673AB7"
colors["indigo"]="#3F51B5"
colors["blue"]="#2196F3"
colors["light_blue"]="#03A9F4"
colors["cyan"]="#00BCD4"
colors["teal"]="#009688"
colors["green"]="#4CAF50"
colors["light_green"]="#8BC34A"
colors["lime"]="#CDDC39"
colors["yellow"]="#FFEB3B"
colors["amber"]="#FFC107"
colors["orange"]="#FF9800"
colors["deep_orange"]="#FF5722"
colors["brown"]="#795548"
colors["grey"]="#9E9E9E"
colors["blue_grey"]="#607D8B"

for name in "${!colors[@]}"; do 
    color=${colors[$name]}
    echo "${name}: ${color}"
    sed -i -e "s/\$primary-color:.*/\$primary-color: ${color} !default;/" $file
    ./node_modules/gulp/bin/gulp.js build
    cp -r dist ../dist/${name}
done

popd