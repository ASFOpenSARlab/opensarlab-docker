all: build run

build:
	cd iris && bash build.sh 2>&1 | tee build.log

run:
	bash start_container.sh 2>&1 | tee run.log
