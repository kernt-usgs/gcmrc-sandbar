#!/bin/bash
python manage.py migrate                  # Apply database migrations
python manage.py collectstatic --noinput  # Collect static files

# Set up cloudwatch logging
mkdir -p /etc/awslogs
touch /etc/awslogs/gunicorn.log
touch /etc/awslogs/access.log

tail -n 0 -f /etc/awslogs/*.log &
#cp -f /src/champ_api/AWS/EC2/Worker/awscli.conf /etc/awslogs/awscli.conf
#cp -f /src/champ_api/AWS/EC2/Worker/awslogs.conf /etc/awslogs/awslogs.conf

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn wsgi.sandbar \
    --name sandbar \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level=info \
    --log-file=/etc/awslogs/gunicorn.log \
    --access-logfile=/etc/awslogs/access.log \
    "$@"