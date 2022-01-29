#!/bin/bash

echo "Executing create_package.sh..."

echo "Making package directory"
mkdir package

echo "Copying python script to package directory"
cp aws_health.py package/

echo "Installing requirements"
pip install --target ./package/ -r requirements.txt

echo "Moving to package directory"
cd package

echo "Zipping contents into deployment package"
zip -r lambda_function.zip .

echo "Moving back to main directory"
cd ..

echo "Moving deployment package to terraform directory"
mv package/lambda_function.zip terraform/

echo "Removing package directory"
rm -rf package/

echo "Finished script execution!"