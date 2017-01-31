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
RUN apt-get install binutils libproj-dev gunicorn gdal-bin -y

# Get the python requirements file and load it using pip
# Now python dependencies
RUN pip install --upgrade pip
COPY ./sandbar/requirements.txt /tmp/
RUN pip --timeout=120 install -r /tmp/requirements.txt

# Copy application source code to SRCDIR
COPY . /usr/src/app/

# Port to expose
EXPOSE 8000

# Copy entrypoint script into the image
WORKDIR /usr/src/app/sandbar
COPY ./docker-entrypoint.sh /usr/src/
#ENTRYPOINT ["/usr/src/docker-entrypoint.sh"]


# Prepare log files and start outputting logs to stdout

# docker run -e "SCHEMA_USER=root;DB_PORT=13306;DB_NAME=SandbarData;DB_PWD=root;DB_HOST=192.168.0.108" -it sandbarprod /bin/bash

# DEbugging live
#docker run --rm -it \
#--entrypoint=/bin/bash -c "python manage.py runserver 0.0.0.0:8000" \
#--publish=8001:8000 \
#michal/hello_django:latest