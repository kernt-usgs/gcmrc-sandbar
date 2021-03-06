############################################################
# Dockerfile to run a Django-based web application
# Based on an Ubuntu Image
############################################################

# Set the base image to use to Ubuntu
FROM python:2.7

# Set the file maintainer (your name - the file's author)
MAINTAINER Matt Reimer

# Update the default application repository sources list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install binutils nginx libproj-dev gdal-bin cron -y

# Get the python requirements file and load it using pip
# Now python dependencies
RUN pip install --upgrade pip
COPY ./sandbar/requirements.txt /tmp/
RUN pip install virtualenv
RUN virtualenv --no-site-packages /usr/src/env
RUN /usr/src/env/bin/pip --timeout=120 install -r /tmp/requirements.txt

COPY ./awscli.conf /etc/awslogs/awscli.conf
COPY ./awslogs.conf /etc/awslogs/awslogs.conf

RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
RUN python ./awslogs-agent-setup.py --region us-west-2 -n -c /etc/awslogs/awslogs.conf

# Port to expose
EXPOSE 8000

# Copy entrypoint script into the image
# Copy application source code to SRCDIR
COPY . /usr/src/app/
WORKDIR /usr/src/app/sandbar
ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]