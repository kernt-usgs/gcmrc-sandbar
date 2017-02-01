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
RUN apt-get install binutils nginx libproj-dev gdal-bin -y

# Get the python requirements file and load it using pip
# Now python dependencies
RUN pip install --upgrade pip
COPY ./sandbar/requirements.txt /tmp/
RUN pip install virtualenv
RUN virtualenv --no-site-packages /usr/src/env
RUN /usr/src/env/bin/pip --timeout=120 install -r /tmp/requirements.txt
# For some reason numpy gets the wrong version so
RUN /usr/src/env/bin/pip install --upgrade numpy scipy pandas


# Port to expose
EXPOSE 8000

# Copy entrypoint script into the image
# Copy application source code to SRCDIR
COPY . /usr/src/app/
WORKDIR /usr/src/app/sandbar
ENTRYPOINT ["/usr/src/app/sandbar/docker-entrypoint.sh"]


# Prepare log files and start outputting logs to stdout

# docker run -e "SCHEMA_USER=root" -e "DB_PORT=13306" -e "DB_NAME=SandbarData" -e "DB_PWD=root" -e "DB_HOST=192.168.0.108" -p 8080:8000 -it sandbarprod  /bin/bash
# docker run -e "SCHEMA_USER=root" -e "DB_PORT=13306" -e "DB_NAME=SandbarData" -e "DB_PWD=root" -e "DB_HOST=192.168.0.108" -p 8080:8000 sandbarprod -it

# DEbugging live
#docker run --rm -it \
#--entrypoint=/bin/bash -c "python manage.py runserver 0.0.0.0:8000" \
#--publish=8001:8000 \
#michal/hello_django:latest