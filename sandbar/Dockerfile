FROM python:2.7

RUN apt-get update
RUN pip install --upgrade pip

# Now we need the oracle drivers
ADD . /usr/src/app
WORKDIR /usr/src/app
RUN pip --timeout=120 install -r /tmp/requirements.txt
RUN pip install --upgrade numpy scipy pandas

CMD python manage.py runserver 0.0.0.0:8000
