start: build run 

# docker build -f dockerfile unavco2022:latest .
build:
	docker build -f dockerfile -t unavco2022:latest .

# # root valid?
# run: 
# 	docker run -it --rm -p 8888:8888 \
# 	--user root \
# 	-v $(pwd)/sandbox:/home/jovyan unavco2022:latest

# if this doesn't work for linux/macOS, 
# use 
# $(pwd)/notebooks 
# instead
run:
	docker run -it --rm -p 8888:8888 \
	-e CHOWN_HOME=yes -e CHOWN_HOME_OPTS='-R' -e GRANT_SUDO=yes \
	-v ${PWD}/home:/home/jovyan unavco2022:latest