# Building the UNAVCO Docker Image and Running it in a Docker Container

Note: Currently M1 Macs are not supported. We haven't tested this on X86 Macs but believe they will work. Please let us know if you have trouble following these steps on an X86 Mac.

# (If Using Windows) Install WSL 2

WSL 2 is a paired down version of Linux running on Windows 10+. 

- [WSL 2 Installation Instructions]( https://docs.microsoft.com/en-us/windows/wsl/install-win10)
    - Install the terminal as described in the final optional step on the page linked above

# Install Docker

- [Linux instructions](https://docs.docker.com/engine/install/ubuntu/) 
    - Select your linux flavor from the left sidebar menu
- [Windows Instructions using WSL 2](https://docs.docker.com/desktop/windows/install/)
    - Be sure to follow the WSL 2 backend specific instructions
- [Mac Instructions](https://docs.docker.com/desktop/mac/install/)
    - X86 Mac support only
    
# Install Git

- Install 
    - [Linux and Mac Instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    - Windows
        - Follow the Linux instructions, running them in a WSL 2 terminal.
- Create an SSH key
    - If you previously installed git outside of WSL 2, you may need to generate a new ssh key
    - [Instructions](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Register your SSH key with GitHub
    - If using WSL 2 on Windows, note that your SSH keys will be stored in /home/<user>/.ssh/
    - [Instructions](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
  

# Clone the Git Repository to Your Computer

- Open a terminal (WSL 2 if on Windows)
- run `git clone git@github.com:ASFOpenSARlab/opensarlab-docker.git`

# Change to the Directory Holding build_start_unavco_container.sh

- run `cd opensarlab-docker/unavco2021`

# Add Any Additional Files You Wish to Access From Your Container

- Add any files or directories you would like mounted in your container to `home/`

# Run build_start_unavco_container.sh

- run `bash build_start_unavco_container.sh 2>&1 | tee log` in the terminal
- Note that we direct output to a log file
    - If your image build or container run fails, please send this log file when you reach out for support

# Open Jupyter Notebooks in Your Browser

- After successfully running the container, you will see some URLs in your terminal

![Image showing jupyter url to open](img/jupyter_url.png)

- Open the bottom URL in your browser
- Do your work
- Files you save in your home directory will be saved in your local `home/` directory and will still be accessible after the container is shut down

# Stop Your Container

- In the terminal running your container and Jupyter Server
    - In Linux and Windows, type `Ctrl + c` twice
    - In Mac OS, type `control + c` twice 

**NOTE:** If you are using WSL 2 (i.e. Windows), your terminal will let you close the terminal that is running container without any warning. If this happens, you cannot use `ctrl + c` to stop the container. In such cases, following steps should lets you stop the container:

1. Use `docker ps` to check if container is running. If it is, copy the `CONTAINER ID`. ![docker_ps](./img/docker_ps.PNG)
1. Use `docker container stop <CONTAINER ID>` to stop your container. You should see your `CONTAINER ID` prompted when container stops. ![docker_stop](./img/docker_stop.PNG)

    
# Run the Container Again

- run `bash build_start_unavco_container.sh 2>&1 | tee log` again any time you wish to rerun the container
    - This will check for updates to the unavco conda environment every time you rerun the container
    - If the docker image is not deleted or modified, a cached version will run.
    
# If You Encounter Issues

- Please reach out for support
- Support contact: uaf-jupyterhub-asf@alaska.edu
