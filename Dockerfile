# Container image that runs your code
FROM ubuntu:20.04

# Installs Git
RUN apt update
RUN apt install -y git

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]