start: build run 

# docker build -f dockerfile unavco2022:latest .
build:
	docker build -f dockerfile -t unavco2022:latest .

# # root valid?
# run: 
# 	docker run -it --rm -p 8888:8888 \
# 	--user root \
# 	-v ${PWD}/home:/home/jovyan unavco2022:latest

# if this doesn't work for linux/macOS, 
# use 
# $(pwd)/notebooks 
# instead

# NOTE: run command will not work properly if you don't have 'home' directory in unavco2022 directory
# running w/o `home` will cause issue with permission. If this happens, use 
# chmod -R 777 home or chown -R <user>:<group> home
# alternatively, run mkdir home beforehand

# NOTE2: startup.sh may trigger unusual error if not properly done. Try removing stuff from home/.local in this directory

run:
	docker run -it --rm -p 8888:8888 \
	-e CHOWN_HOME=yes -e CHOWN_HOME_OPTS='-R' -e GRANT_SUDO=yes \
	-v ${PWD}/home:/home/jovyan unavco2022:latest