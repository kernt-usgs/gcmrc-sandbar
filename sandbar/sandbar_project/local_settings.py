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

SCHEMA_USER = os.getenv('SCHEMA_USER')
DB_PWD = os.getenv('DB_PWD')
DB_NAME = os.getenv('DB_NAME')
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')

# Make sure there's no End slash!
PHOTO_URL = os.getenv('PHOTO_URL')

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
            'HOST': DB_HOST,
            'PORT': DB_PORT,
        }
    }

POSTGIS_VERSION = (2, 1, 1)

STATIC_URL = '/static/'

# GDAWS_SERVICE_URL = 'http://cida-eros-gcmrcdev.er.usgs.gov:8080/gcmrc-services/'

# Make this unique, and don't share it with anybody.
SECRET_KEY = os.getenv('SECRET')