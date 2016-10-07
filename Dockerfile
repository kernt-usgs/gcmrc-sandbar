FROM ubuntu:precise

RUN apt-get update
RUN apt-get install python-pip python-dev build-essential curl -y
RUN pip install virtualenv virtualenvwrapper
RUN pip install --upgrade pip

# Now we need the oracle drivers
RUN apt-get install libaio1 libaio-dev alien poppler-utils -y 

# Get Oracle Client (this isn't the offical download location, but at least it works without logging in!)
RUN curl -O http://repo.dlt.psu.edu/RHEL5Workstation/x86_64/RPMS/oracle-instantclient12.1-basic-12.1.0.1.0-1.x86_64.rpm
RUN curl -O http://repo.dlt.psu.edu/RHEL5Workstation/x86_64/RPMS/oracle-instantclient12.1-devel-12.1.0.1.0-1.x86_64.rpm

RUN echo "/usr/lib/oracle/12.1/client64/lib" > /etc/ld.so.conf.d/oracle.conf
ENV ORACLE_HOME /usr/lib/oracle/12.1/client64
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib
RUN ldconfig

# Now copy in oru app
COPY . /src
WORKDIR /src/sandbar
RUN virtualenv --python=python2.7 --no-site-packages env
RUN env/bin/pip --timeout=120 install -r requirements.txt

# docker build -t gcmrcsandbar .
# $ docker run -d -P --name web -v /src:./ training/webapp python app.py