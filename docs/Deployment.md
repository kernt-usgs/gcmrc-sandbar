# Deployment

## The Stack

We're currently running Django using the following AWS stack:

* [Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/): Cheap MySQL hosting
* [Docker](https://www.docker.com/): We run Django inside a container and run that container in production to keep server admin problems to a minimum.
* [VirtualEnv](https://virtualenv.pypa.io/en/stable/): Used to run a specific version of python that can be different from what's running on our server. (The server is a docker container).
* [Amazon EC2 Container Service](https://aws.amazon.com/ecs/): Easiest way to run containers in the cloud.
* [Amazon Cloudwatch](https://aws.amazon.com/cloudwatch/): All logging



## Docker Deployment to AWS ECS:

To install the AWS CLI and Docker and for more information on the steps below, visit the ECR [documentation page](http://docs.aws.amazon.com/AmazonECR/latest/userguide/ECR_GetStarted.html).

1) Retrieve the `docker login` command that you can use to authenticate your Docker client to your registry:

```Bash
aws ecr get-login --region us-west-2
```

2) Run the `docker login` command that was returned in the previous step.

3) Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions [here](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html). You can skip this step if your image is already built:

```Bash
docker build -t gcmrc-sandbar .
```

4) After the build completes, tag your image so you can push the image to this repository:

```Bash
docker tag gcmrc-sandbar:latest 806758145339.dkr.ecr.us-west-2.amazonaws.com/gcmrc-sandbar:latest
```

5) Run the following command to push this image to your newly created AWS repository:

```bash
docker push 806758145339.dkr.ecr.us-west-2.amazonaws.com/gcmrc-sandbar:latest
```

## Logging into ECS and docker

Maybe you want to know what's happening on your docker box. 

### Step 1: Log into your EC2 Machine using SSH

1. Find your EC2 box in the Instances lit on the EC2 console.
2. Right-click, click "connect" and get your connection string
3. Use your connection string to log into your EC2 box. It's a pretty standard Linux configuration

You can find ECS logs in `/var/logs/ecs`

### Step 2: Log into your container

1. Form you EC2 box type `docker ps`

2. Copy the hash of the box contaning `gcmrc-sandbar` to your clipboard

3. Connect to the docker box with `docker exec -it <HASH> /bin/bash`

Now you're SSH'd into the server box. Make a mess!

