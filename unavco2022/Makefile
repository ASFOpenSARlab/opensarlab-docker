# NOTE: run command will not work properly if you don't have 'home' directory in unavco2022 directory
# running w/o `home` will cause issue with permission. If this happens, use 
# chmod -R 777 home or chown -R <user>:<group> home
# alternatively, run mkdir home beforehand

# NOTE2: startup.sh may trigger unusual error if not properly done. Try removing stuff from home/.local in this directory

start: check build run 

sudo: check build runsudo

build:
	docker build -f dockerfile -t unavco2022:latest .

run:
	docker run -it --rm -p 8888:8888 \
	-v ${PWD}/virtual_home:/home/jovyan unavco2022:latest

runsudo:
	docker run -it --rm -p 8888:8888 \
	--user root \
	-v ${PWD}/virtual_home:/home/jovyan unavco2022:latest

check:
	if [ ! -d "virtual_home" ]; then \
        mkdir virtual_home; \
    else \
        ls -l | grep virtual_home; \
    fi
