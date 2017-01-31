These instructions are mine (Matt Reimer) as I discover how Django works and how to develop locally on it.

## To get running locally:

I'm using pycharm for debugging. 

## Mysql

I use a docker container so:

```
docker-compose up
```

that will give you a mysql server

### Pycharm setup:

First enable Django support from `Language & Frameworks -> Django`

```
PRoject root: <whatever>/sandbar
settings: sandbar_project/settings.pyc
manage script: manage.py
```

Now you need to reate a `local_settings.py` file:

```Python
'''
Created on Aug 29, 2013

@author: kmschoep
'''
from sys import argv
import os
PROJECT_HOME = os.path.dirname(__file__)
SITE_HOME = os.path.split(PROJECT_HOME)[0]
DEBUG = True
#TEMPLATE_DEBUG = DEBUG
#SOUTH_LOGGING_FILE = os.path.join(os.path.dirname(__file__),"south.log")
#SOUTH_LOGGING_ON = True

SCHEMA_USER = 'root'
DB_PWD = 'root'
DB_NAME = 'djangoDB'

DJANGOTEST_PWD = 'root'

# This checks to see if django tests are running (i.e. manage.py test)
if argv and 1 < len(argv):
    RUNNING_TESTS = 'test' in argv
else:
    RUNNING_TESTS= False

if not RUNNING_TESTS:
    DATABASES = {
        'default': {
            'ENGINE': 'django.contrib.gis.db.backends.mysql',
            'NAME': DB_NAME,
            'USER': SCHEMA_USER,
            'PASSWORD': DB_PWD,
            'HOST': '127.0.0.1',
            'PORT': '13306',
        }
    }

POSTGIS_VERSION = (2, 1, 1)

STATIC_URL = '/static/'

GDAWS_SERVICE_URL = 'http://cida-eros-gcmrcdev.er.usgs.gov:8080/gcmrc-services/'

# Make this unique, and don't share it with anybody.
SECRET_KEY = 'wibbly-wobbly-timey-wimey'
```

### VirtualEnv

Now you need a new project interpreter. `Project: gcmrc-sandbar -> Project Interpreter` click the gear and set up a new virtualenv.

You'll need to open a terminal now and:

```

```

 