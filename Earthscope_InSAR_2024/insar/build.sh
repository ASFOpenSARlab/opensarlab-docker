
set -ex

IMAGE_NAME=earthscope-insar-2024

[ -e download.sh ] && bash download.sh

cp dockerfile dockerfile.build

BUILD_TAG=$(date +"%F-%H-%M-%S")
COMMIT_HEAD=$(git rev-parse --short HEAD)

time docker build -f dockerfile.build --target testing .
time docker build -f dockerfile.build \
    -t $IMAGE_NAME:$BUILD_TAG \
    -t $IMAGE_NAME:latest \
    -t $IMAGE_NAME:$COMMIT_HEAD \
    --target release .
