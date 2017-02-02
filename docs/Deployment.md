# Deployment

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

