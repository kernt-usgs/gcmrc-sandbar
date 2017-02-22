These instructions are mine (Matt Reimer) as I discover how Django works and how to develop locally on it. I'm on OSX so feel free to rewrite this as it applies to you.

## Ways of running Django on your local machine

1. Through pyCharm and virtualenv (no docker)
2. Running the full stack of Mysql+Django with Docker compose
3. Running just DJango on its own and connecting it to a database somewhere else.

## Running Django Server with Pycharm setup:

This stuff is only for the first run. After you do this you should just be able to hit "play" and have a django server. You'd want this option if you're trying to debug python scripts inside the actual app.

#### Step1: Turn on Django Support in Pycharm

First enable Django support from `Language & Frameworks -> Django`

```
Project root: <whatever>/sandbar
settings: sandbar_project/settings.pyc
manage script: manage.py
```

#### Step 2: Setting up a VirtualEnv

Now you need a new project interpreter. `Project: gcmrc-sandbar -> Project Interpreter` click the gear and set up a new virtualenv with a name like `gcmrcenv`. Note the name and the location.

You'll need to open a terminal now and if you see your virtualenv name in the prompt (`gcmrcenv` in this case) you're good to go. Otherwise you need to source the virtualenv:

```Bash
' My Pycharm prompt looks like this:
$ _
' so I type...
source /location/of/your/gcmrcenv/bin/activate
' Now you should see...
(gcmrcenv)$ _
' and everything I execute after this is inside the virtualenv
```

Now you just need to install the dependencies listed in the `requirements.txt` file (adjust paths as necessary):

```bash
pip --timeout=120 install -r sandbar/requirements.txt
' I found that I had to upgrade numpy, scipy and pandas too
pip install --upgrade numpy scipy pandas
```

#### Step 3: Add a Django Configuration with environment variables

* Edit your configurations (button in the top right)
* hit the (+) to add a new Django server with the following properties:
  * **Host**: localhost **Port**: 8080
  * **Environment variables *(set them as follows with appropriate substitutions)*:**

```
DJANGO_SETTINGS_MODULE=sandbar_project.settings
PYTHONUNBUFFERED=1
SCHEMA_USER=[YOUR_DB_USERNAME]
DB_PORT=3306
DB_NAME=[YOUR_DB_NAME]
DB_PWD=[YOUR_DB_PASSWORD]
DB_HOST=[YOUR_DB_HOSTNAME]
SECRET=anyrandomstringyouwant
PHOTO_URL=http://whatever.photo.url/my/folder
```

Done! Now you should be able to debug and run DJango on your machine.

## Running with Docker Compose

Docker compose is a great way to simulate the entire production stack exactly as it is deployed on the server including a network link between containers. This takes most of the guess-work out of debugging on the server.

You can use a local mysql server if you want or you can connect to the live `SandbarData` or the test `SandbarTest` db on **AWS RDS** but if you want to run something locally I've provided a docker container loaded with a MySQL server. 

```Bash
docker-compose up
```

that will give you two containers:

- **Container 1**: mysql server
- **Container 2**: Django python container

If you just want the database you can run:

```bash
docker-compose up db
```

this is useful when you want to debug in pycharm against a local database but can't be bothered to run MySQL on your local machine (which you shouldn't do anyway probably).

***NB: The first time you run this the web worker will fail because it can't find a database. This is because the MySQL container boots up with an empty server. You need to start it up, let the web worker fail then connect on port 13306 using a MySQL client and then import a copy of `SandbarData` DB into the Mysql server (just the first time. It persists)***



### Option 3: Docker Locally

I don't know why you wouldn't use docker-compose but for completeness I'll tell you how to get this up and running with individual docker containers:

```Bash
docker build -t gcmrc-sandbar .
docker run -e "SCHEMA_USER=YOUR_DB_USERNAME" -e "DB_PORT=YOUR_DB_PORT" -e "DB_NAME=YOUR_DB_NAME" -e "DB_PWD=YOUR_DB_PASSWORD" -e "DB_HOST=YOUR_DB_HOST" -p 8080:8000 sandbarprod -it

```

This is basically just doing everything that's in your `docker-compsoe.yml` file.