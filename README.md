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

★ Set the UID and GID to be your user's UID and GID (which you can find with the `id` command).

★ Set TZ to be your local time zone.

★ PLEXSTACK_HOME should be the working directory where you cloned this repository.

You can leave the ports alone, or change them if you're already using those ports for something else on your host.

# Start the servers

★ While in PLEXSTACK_HOME, enter the following command to start the servers:

```
docker compose up -d
```

This starts the containers in the background.  You can see the console output of all the servers with:

```
docker compose logs -f
```

# Enable access to SAB

SAB will block access to the web site from hosts it doesn't recognize.  To allow access, 
you need to set a config setting in a config file that is created after sabnzb starts up.

Assuming you've already started the containers in the previous step, SAB should have created 
the config file you need to edit.   

★ First, shut down the containers down again:

```
docker compose down
```

★ Now edit `sabnzbd/config/sabnzbd.ini`, find the setting for `host_whitelist` and add all the hostnames 
that will be used to connect to sabnzbd.

★ You must include `sabnzbd` as one of the hostnames -- that's the hostname that other containers will use 
to refer to this server.

★ Then re-start the containers with `docker-compose up -d`.

# Configure your usenet service provider into SAB

★ First, visit the SAB web page.  You'll be presented with a quick-start wizard.  Pick your language and then 
click "Start Wizard >".  

★ On the next page, enter the requested information about your usenet service provider.  Check the advanced settings; 
my usenet service provider allows me 50 simultaneous connections, many more than the default value in SAB.
Use the "Test Server" button to validate the information and then click "Next >".  

# Configure SAB into Sonarr and Radarr

## Get the NZB Key from SAB and allow external access

Visit the SAB general configuration page.  It's available at this URL: http://hostname:9991/config/general/

Alternatively, you can find the general configuration page from the home screen (http://hostname:9991/) 
by clicking on the gear icon to get to a system info page, then clicking on the "General" top-nav item; 
it has a gear icon.

★ Copy the "API Key" from the "Security" section of this page.  *(Note: The NZB key seems more appropriate for use by Sonarr, 
but this didn't work when I tried it.)*

★ While you're on this page, change the "External internet access" setting to be "Add NZB files", then click "Save Changes".

## Configure SAB into Sonarr

Visit the Sonarr Download Clients configuration page.  It's available at this URL: http://hostname:9992/settings/downloadclients

Alternatively, you can find the Download Clients configuration page from the home screen (http://hostname:9992/) 
by clicking "Settings" in the side-nav, and then clicking on "Download Clients". 

★ From the Download Clients configuration page, click the big "plus" icon, and then click on "SABnzbd" in the "Usenet" section.

★ You'll need to enter the following information:

 - Name: SAB (or whatever you want to name it)
 - Host: sabnzbd (this is the hostname docker compose set up for the containers to use when talking to each other)
 - API Key: enter the NZB you copied from SAB in the previous step

Note: leave the port at the default 8080; don't change it to 9991. 9991 is the port exposed by docker for access from the outside.

★ Hit the "Test" button, then hit "Save".

## Configure SAB into Radarr

Perform the same steps again for Radarr (http://hostname:9992/). 

★ From the Download Clients configuration page, click the big "plus" icon, and then click on "SABnzbd" in the "Usenet" section.

★ Enter the name (SAB), host (sabnzbd), and API Key (from SAB; the same key you put in Sonarr).

★ Hit the "Test" button, then hit "Save".

# Configure the Indexer into Sonarr and Radarr

## Configure the Indexer into Sonarr

The configure indexers page for Sonarr is here: http://mini:9992/settings/indexers

It can be reached through the UI by clicking the "Settings" entry in the side-nav, and then clicking on "Indexers".

★ From the Indexers configuration page, click the big "plus" icon and then on the protocol your indexer supports.  (For my indexer, NZB Geek, the protocol is Newznab.)

★ Enter a name for your indexer, your indexer's URL, and your indexer's API key.  Then click "Test" and "Save".  *(Note, your indexer probably has a separate URL for use by Sonarr/Radarr than the one you visit in a web browser.  NZB Geek's URL is http://nzbgeek.info, but I need to configure http://api.nzbgeek.info into Sonarr/Radarr.)*

## Configure the Indexer into Radarr

The steps to configure your indexer into Radarr are the same as for Sonarr.

The configure indexers page for Radarr is here: http://mini:9993/settings/indexers

★ From the Indexers configuration page, click the big "plus" icon and then on the protocol your indexer supports.  

★ Enter a name for your indexer, your indexer's URL, and your indexer's API key. Then click "Test" and "Save".  

