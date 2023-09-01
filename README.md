# Plexstack
This project includes a docker-compose file and a directory structure that creates 
a group of docker containers that run web applications (Sonarr and Radarr) for finding 
and downloading videos from usenet and then displaying that video on Plex.

# Overview

The group of containers includes the following components:
 - A download client (SAB)
 - A movie search tool (Radarr)
 - A TV search tool (Sonarr)
 - A video asset database and streaming application (Plex)

The following services are used:
 - An NZB indexer (such as NZB Geek)
 - A Usenet service provider (such as Astraweb)
 - Plex

The basic configuration steps need to be performed:
 - Start the servers
 - Configure SAB with info about your Usenet service provider (Astraweb)
 - Configure Sonarr with info about your download client (SAB) and indexer (NZB Geek)
 - Configure Radarr with info about your download client (SAB) and indexer (NZB Geek)
 - Configure Plex, Sonarr, and Radarr to use shared directories (requires compatible permission / user & group ids)

# Clone and set up .env

Clone this project to a working directory, cd into it, and then edit `.env` with your favorite editor to have the
following contents:

```
UID=1001
GID=1001
TZ=America/Denver
PLEXSTACK_HOME=/opt/plexstack
SABNZBD_PORT=9991
SONARR_PORT=9992
RADARR_PORT=9993
```

You should set the UID and GID to be your user's UID and GID (which you can find with the `id` command).

Set TZ to be your local time zone.

PLEXSTACK_HOME should be the working directory where you cloned this repository.

You can leave the ports alone, or change them if you're already using those ports for something else on your host.

# Start the servers

While in PLEXSTACK_HOME, enter the following command to start the servers:

```
docker compose up
```

# Enable access to SAB

SAB will block access to the web site from hosts it doesn't recognize.  To allow access, 
you need to set a config setting in a config file that is created after sabnzb starts up.

Assuming you've already started the containers in the previous step, SAB should have created 
the config file you need to edit.   So shut down the containers:

```
docker compose down
```

Now edit `sabnzbd/config/sabnzbd.ini`, find the setting for `host_whitelist` and add all the hostnames 
that will be used to connect to sabnzbd.

Then re-start the containers with `docker-compose up`.

# Configure your usenet service provider into SAB

Visit http://hostname:9991/config/server/ (which is accessible from the top-nav; the icon is an up and down arrow), 
click **Add Server** and enter info about your usenet provider.
