#!/bin/bash

# Set up cloudwatch logging
mkdir -p /etc/awslogs
touch /etc/awslogs/gunicorn.log
touch /etc/awslogs/access.log

# Start up our logging service
tail -n 0 -f /etc/awslogs/*.log &
service awslogs start
service awslogs status

# Start Gunicorn processes
echo Starting Gunicorn. ${PWD}
source /usr/src/env/bin/activate
cd /usr/src/app

exec gunicorn wsgi:application \
    --name sandbar \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level=info \
    --log-file=/etc/awslogs/gunicorn.log \
    --access-logfile=/etc/awslogs/access.log \
    "$@"