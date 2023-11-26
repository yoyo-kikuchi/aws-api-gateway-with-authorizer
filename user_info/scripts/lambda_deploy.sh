#!/bin/bash

function_name=$1

zip -r app.zip src vendor
aws lambda update-function-code --function-name $function_name --zip-file fileb://app.zip
rm app.zip