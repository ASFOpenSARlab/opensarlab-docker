start: build run 

# docker build -f dockerfile unavco2022:latest .
build:
	docker build -f dockerfile -t unavco2022:latest .

# root valid?
# docker run -it --rm -p 8888:8888 \
# --user root \
# -v $(pwd):/home/jovyan unavco2022:latest
run:
	docker run -it --rm -p 8888:8888 \
	-v $(pwd):/home/jovyan unavco2022:latest