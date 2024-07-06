# DockerRemoteDeveloper
A Docker Remote Developer for VS-Code

## Project Overview
This project provides a development environment for remote developers to use with VS-Code. The Docker container includes all necessary dependencies and configures an SSH server for connection.

### Dockerfile
The Dockerfile contains all the necessary commands to build the development environment. It installs Git, the required dependencies for Python, Python 3.9, and the OpenSSH server.

## Getting Started
### 0. Create and Change the new Directory:

```sh
mkdir remote_dev
cd remote_dev/
```
### 1. You have two options to get the Image:

Option 1: Pull the Docker Image from Docker Hub 
```sh
docker pull docdietrich/dockerremotedeveloper:latest
```
Option 2: Clone the Git Repository and Build Locally
```sh
git clone https://github.com/dimitripy/DockerRemoteDeveloper.git
cd DockerRemoteDeveloper
```
### 2. Create or edit the `config.env` file to configure the following parameters:

```sh
sudo nano -w config.env
```
```txt
SSH_PORT=2222
SSH_USER=vscode
SSH_PASSWORD=your_secure_password
```
Adjust the values according to your needs. This file will not be included in the Git repository.

### 3. Start the container using Docker Compose:
```sh
sudo docker-compose up
```
wenn es nicht Funktioniert:
```sh
export SSH_PORT=2222
export SSH_USER=vscode
export SSH_PASSWORD=abcd
docker-compose up --build
```
To allow the container to access your home directory for project management:
```sh
sudo docker run -d -p 2222:22 --name remote-dev -v ~/:/home/vscode docdietrich/dockerremotedeveloper:latest
```
or
```sh
sudo docker run -d -p 2222:22 --name remote-dev -v ~/:/home/vscode dockerremotedeveloper:latest
```
### Connecting to the Container
Replace <SSH_PORT>, <SSH_USER>, and <IP_ADDRESS> with the corresponding values from your config.env file and the IP address of the server running the container.
To connect to the container, use an SSH client as follows:
```sh
ssh -p <SSH_PORT> <SSH_USER>@<IP_ADDRESS>
```
### SSH Configuration (Optional)
You can also configure your SSH client to use the login details from config.env by creating or editing the ~/.ssh/config file:
```sh
sudo nano ~/.ssh/config
```
```sh
Host remote-dev
    HostName <IP_ADDRESS>
    Port <SSH_PORT>
    User <SSH_USER>
    #IdentityFile ~/.ssh/id_rsa
    #StrictHostKeyChecking no
    #UserKnownHostsFile=/dev/null
```
## VS Code Remote Development
To connect to the container using VS Code Remote Development:

1. Install the Remote - SSH extension in VS Code.

2. Open the Command Palette (F1) and select Remote-SSH: Connect to Host....

3. Enter the SSH configuration details:

```sh
ssh docker-dev 
```

After connecting, VS Code will set up the SSH connection and you will be able to work on the remote container as if it were a local environment.

### Troubleshooting
Ensure that the config.env file is correctly configured.
Verify that Docker and Docker Compose are properly installed and configured.
Ensure that the chosen SSH port is not occupied by another application.

License
This project is licensed under the MIT License. For more information, see the LICENSE file.

With this guide, anyone should be able to configure and use the project effectively.
