`bootstrap-docker-server.sh` does just that. It goes from zero to docker on an ubuntu based server.  
Files that begin with `compose` use docker-compose to provision an entire docker based server.  
Subdirectories like `app-router` contain a Dockerfile and additional files to build a corresponding image.  
