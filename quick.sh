#!/bin/bash

if [ $# -lt 4 ]; then
    echo "usage: ./quick.sh folderName companyName frontendName backendName"
    echo -e "\nex: ./quick MyApp WidgetWorld frontend api"
    echo -e "\nfolderName - The name of the folder that will be created in the current working directory"
    echo -e "\ncompanyName - The scope that all packages will be placed in."
    echo -e "\nfrontendName - The name of the frontend package that uses create-react-app."
    echo -e "\nbackendName - The name of the backend package that uses nestjs"
    exit;
fi

folderName=$1
companyName=$2
frontendName=$3
backendName=$4

# Setup lerna & workspaces
mkdir $folderName && cd $folderName
git init

yarn add -D lerna
npx lerna init
jq '.npmClient="yarn" | .useWorkspaces=true' lerna.json > lerna.json.tmp && mv lerna.json.tmp lerna.json 
jq '.workspaces=["projects/*"] | .private=true' package.json > package.json.tmp && mv package.json.tmp package.json

# Create packages
npx lerna create @companyName/common --private --description 'common' -y
# Create react app
npx create-react-app projects/$frontendName --template typescript
jq ".name=\"@$companyName/$frontendName\"" projects/$frontendName/package.json > projects/$frontendName/package.json.tmp && mv projects/$frontendName/package.json.tmp projects/$frontendName/package.json
## Create Nest app
npx @nestjs/cli new projects/$backendName -g -p yarn
jq ".name=\"@$companyName/$backendName\"" projects/$backendName/package.json > projects/$backendName/package.json.tmp && mv projects/$backendName/package.json.tmp projects/$backendName/package.json
# Convert js to json
echo 'const file=require("./projects/$backendName/.eslintrc.js");console.log(JSON.stringify(file,null,4));' | node > projects/$backendName/.eslintrc.json
rm projects/$backendName/.eslintrc.js

# Add common to each package (except common)
npx lerna add @$companyName/common
npx lerna link

# Install eslint & husky
yarn add -W -D eslint husky lint-staged prettier eslint-config-airbnb eslint-config-prettier eslint-plugin-prettier eslint-plugin-import @typescript-eslint/eslint-plugin@^2.14.0 @typescript-eslint/parser@^2.14.0
yarn eslint --init

echo '{
    "printWidth": 120,
    "singleQuote": true,
    "trailingComma": "es5",
    "tabWidth": 4
}' > .prettierrc.json

jq '.extends[.extends|length]+="prettier/@typescript-eslint" | .extends[.extends|length]+="plugin:prettier/recommended"' .eslintrc.json > .eslintrc.json.tmp && mv .eslintrc.json.tmp .eslintrc.json
jq ".parserOptions.project=\"projects/$backendName/tsconfig.json\"" projects/$backendName/.eslintrc.json > projects/$backendName/.eslintrc.json.tmp && mv projects/$backendName/.eslintrc.json.tmp projects/$backendName/.eslintrc.json

# Pull duplicate dev dependencies down to the root 
npx lerna bootstrap