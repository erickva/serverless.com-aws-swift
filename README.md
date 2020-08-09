# serverless.com-aws-swift
Serverless.com Template for AWS Swift Runtime

I am currently working on this ~~, so do not use.
IT DOES NOT WORK YET~~.

Make sure you have installed Docker, Serverless Framework and AWS CLI.

On your terminal login to AWS:
`aws configure`

Then create the serveless project:
`sls create --name ThisIsMyProjectName --template-url https://github.com/erickva/serverless.com-aws-swift`

CD into your new directory:
`cd ThisIsMyProjectName`

Then:
`./scripts/serverless-deploy.sh`

If all goes well you will see the POST endpoint you can call from Postman. It requires a JSON body:
```
{
    "name": "Erick"
}
```
