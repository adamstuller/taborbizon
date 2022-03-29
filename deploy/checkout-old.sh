#! /bin/bash

echo "Cloning repository..."

if [ -d taborbizon ]; then
    cd taborbizon
else
    git clone https://github.com/adamstuller/taborbizon.git &&
        cd taborbizon
fi

echo "Building old version..."

if [ -d ../app ]; then
    rm -rf ../app
fi 

mkdir ../app

git checkout main &&
    git pull &&
    npm install &&
    npm run build && 
    cp -R build ../app/build && 
    cp ../../Dockerfile ../app

echo "Cleaning the mess..."

cd .. &&
    rm -rf taborbizon