# quick-typescript-nestjs-react-eslint-prettier-common-monorepo
Contains a shell script to quickly get setup with a create-react-app frontend and a nestjs backend. It uses eslint and prettier with a monorepo using lerna and yarn workspaces. It also has a common project that can be used to share code between packages.

The following must be installed before running this script:
- git
- jq
- npm
- yarn
- lerna (yarn global add lerna@v3.4.0)

Run the script with the following command:
```shell script
bash <(wget -o /dev/null -O- http://git.io/Jfw9e) myApp myCompany frontend backend
```

Note, the following questions are asked when running the above command. This script has only been tested with the following answers.

- How would you like to use ESLint? **To check syntax, find problems, and enforce code style**
- What type of modules does your project use? **JavaScript modules (import/export)**
- Which framework does your project use? **React**
- Does your project use TypeScript? **Yes**
- Where does your code run? **Browser, Node**
- How would you like to define a style for your project? **Use a popular style guide**
- Which style guide do you want to follow? **Airbnb: https://github.com/airbnb/javascript**
- What format do you want your config file to be in? **JSON**
