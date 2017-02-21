#!/bin/bash
##########
# If you don't want to use Docker you can put this script in the user-data of 
# a CentOS EC2 box to start the application. 
##########

yum update -y
yum install binutils nginx git mysql-devel python-devel gcc gcc-c++ geos -y

pip install --upgrade pip
pip install virtualenv

# Now go get the app
git clone https://github.com/NorthArrowResearch/gcmrc-sandbar.git /usr/src/app

# Set up our VirtualEnv
virtualenv --no-site-packages /usr/src/env
/usr/src/env/bin/pip --timeout=120 install -r /usr/src/app/sandbar/requirements.txt
# For some reason numpy gets the wrong version so
/usr/src/env/bin/pip install --upgrade numpy scipy pandas

####################################################################
# Above here is the provisioning that you should bake into your AMI
# Do this so it doesn't have to install numpy and pandas (slow) 
# every time an EC2 machine boots
####################################################################
# Below this point is what should go in your user-data
####################################################################

#!/bin/bash

# Get the latest code:
cd /usr/src/app
git pull

# Make sure we have the latest dependencies
/usr/src/env/bin/pip --timeout=120 install -r /usr/src/app/sandbar/requirements.txt

# DANGER: DO NOT PUT REAL VALUES HERE. THEY WILL BE PUBLIC
# INSTEAD, COPY AND PASTE THIS SOMEWHERE ELSE FIRST
# IF YOU COMMIT PASSWORDS TO GITHUB EVERYONE WILL SEE THEM!!!!!!!!
export DJANGO_SETTINGS_MODULE=sandbar_project.settings
export SCHEMA_USER=<<<<<PLACEHOLDER>>>>>>
export DB_PWD=<<<<<PLACEHOLDER>>>>>>
export DB_NAME=<<<<<PLACEHOLDER>>>>>>
export DB_HOST=<<<<<PLACEHOLDER>>>>>>
export DB_PORT=3306
export SECRET_KEY=<<<<<PLACEHOLDER>>>>>>

# Install the cloudwatch logger
mkdir -p /etc/awslogs
cp /usr/src/app/awscli.conf /etc/awslogs/awscli.conf
cp /usr/src/app/awslogs.conf /etc/awslogs/awslogs.conf

curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
python ./awslogs-agent-setup.py --region us-west-2 -n -c /etc/awslogs/awslogs.conf

# Set up cloudwatch logging
touch /etc/awslogs/gunicorn.log
touch /etc/awslogs/access.log

# Start up our logging service
tail -n 0 -f /etc/awslogs/*.log &
service awslogs start
service awslogs status

# Start Gunicorn processes
echo Starting Gunicorn. ${PWD}
source /usr/src/env/bin/activate

exec gunicorn wsgi:application \
    --name sandbar \
    --bind 0.0.0.0:80 \
    --workers 3 \
    --log-level=info \
    --log-file=/etc/awslogs/gunicorn.log \
    --access-logfile=/etc/awslogs/access.log \
    "$@"