# Pleroma-Swarm
## Project goal
The goal of this project was to make a Pleroma instance, running on a docker swarm cluster for scalability, portability and high availability.
This is not meant for a production deployment, its just a demo of pleroma running on swarm.
## Current limitations
The application runs without HTTPS, therefore it is not very secure. This was done for easy exposure of the web interface via docker swarm.
## Tools and images used
- Docker engine 28.2.2, build e6534b4
- Debian 12 bookworm
- Elestio pleroma image
- Elestio postgres image
## Test setup / Cluster
(This is the setup where this project was developed)<br>
The cluster consists of 5 nodes: 1 manager and 4 workers.
The manager has the IP : 192.168.1.29<br>
The workers have IPs in range 192.168.1.30 - 192.168.1.34

> [!IMPORTANT]
>To adjust this project to your needs you will have to change the local IP of my local manager node to the IP of your manager within your cluster in a couple of config files.

- All the nodes within the development cluster ran Debian 12 bookworm.
## Deploy/Remove stack (Start/Stop application)
To deploy the stack : 
```
chmod +x up.sh
./up.sh
```
To remove the stack :
```
chmod +x down.sh
./down.sh
```
## Adjusting this project to your needs
### Change the stack name
In "up.sh" change the "STACK_NAME" variable to your liking :
```
STACK_NAME="your-cool-stackname" # stack name
```
> [!TIP]
> The stack name is used for several docker commands (such as docker stack ps, which shows you on which node each service is running)
### Change the node where the DB runs
> [!IMPORTANT]
>The database runs on a fixed node, so data persists between runs. Declare the node hostname you want the database to run on in "up.sh" :
```
DB_NODE_NAME="hostname-of-your-worker" # hostname of node where the DB will run on
```
### Changing IP, hostname and ports for web interface
- Inside ".env" you must change :
```
DOMAIN=192.168.1.29:3226
FRONTEND_PORT=3226
```
To the domain you want to use and the port. If you dont use a domain (like I did), you must still specify the IP and Port likewise.
- Inside "prod.server.exs" you must change :
```
url: [host: System.get_env("DOMAIN", "192.168.1.29"), scheme: "http", port: 3226]
```
To your desired IP and port.
### Changing port for Database
This is not recommended and can break the application, however if you MUST do it, inside ".env" you have to change:
```
DB_PORT=5432
```
> [!CAUTION]
> Keep in mind this is not tested and may break things.
### Changing database user and password
inside .env change the following values to your liking : 
```
POSTGRES_PASSWORD=pass
POSTGRES_USER=pleroma
POSTGRES_DB=pleroma
DB_USER=pleroma
DB_PASS=pass
DB_HOST=pleroma-db
DB_NAME=pleroma
```