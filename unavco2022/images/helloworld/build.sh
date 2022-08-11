
set -ex

cp dockerfile dockerfile.build

BUILD_TAG=$(date +"%F-%H-%M-%S")
COMMIT_HEAD=$(git rev-parse --short HEAD)

IMAGE_NAME=$1

time docker build -f dockerfile.build --target testing .
time docker build -f dockerfile.build \
    -t $DOCKER_REGISTRY/$IMAGE_NAME:$BUILD_TAG \
    -t $DOCKER_REGISTRY/$IMAGE_NAME:latest \
    -t $DOCKER_REGISTRY/$IMAGE_NAME:$COMMIT_HEAD \
    --target release .

# Push to registry
docker push $DOCKER_REGISTRY/$IMAGE_NAME:$BUILD_TAG
docker push $DOCKER_REGISTRY/$IMAGE_NAME:latest
docker push $DOCKER_REGISTRY/$IMAGE_NAME:$COMMIT_HEAD
