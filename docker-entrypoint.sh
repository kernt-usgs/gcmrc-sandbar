#!/bin/bash

# Set up cloudwatch logging
mkdir -p /etc/awslogs
touch /etc/awslogs/gunicorn.log
touch /etc/awslogs/access.log

tail -n 0 -f /etc/awslogs/*.log &
#cp -f /src/champ_api/AWS/EC2/Worker/awscli.conf /etc/awslogs/awscli.conf
#cp -f /src/champ_api/AWS/EC2/Worker/awslogs.conf /etc/awslogs/awslogs.conf

# Start Gunicorn processes
echo Starting Gunicorn.
source /usr/src/env/bin/activate
exec gunicorn wsgi:application \
    --name sandbar \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level=info \
    --log-file=/etc/awslogs/gunicorn.log \
    --access-logfile=/etc/awslogs/access.log \
    "$@"

# gunicorn sandbar.wsgi --name sandbar --bind 0.0.0.0:8000 --workers 3 --log-level=info --log-file=/etc/awslogs/gunicorn.log --access-logfile=/etc/awslogs/access.log "$@"