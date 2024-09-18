all: build run

build:
	cd insar && bash build.sh 2>&1 | tee log

run:
	bash start_container.sh 2>&1 | tee log
