# taborbizon
SPA for summer camp bison in Elm, for school purposes as well


## How to run 

1. Install dependencies
`npm install`

2. Run compilation in watch mode
`npm run watch`

3. Run server
`npm run dev`

## TODO:
- [ ] Gallery page
- [ ] POST requests to excel sheet


## deployment 
### ec2 instance setup steps
-  sudo yum update
- sudo yum install docker
- wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
- sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
- sudo chmod -v +x /usr/local/bin/docker-compose
- sudo systemctl enable docker.service
- sudo systemctl start docker.service