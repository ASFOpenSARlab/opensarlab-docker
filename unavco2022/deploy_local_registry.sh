
# https://docs.docker.com/registry/deploying/

mkdir -p /tmp/docker-registry
docker run -d -p 5000:5000 -v /tmp/docker-registry:/var/lib/registry:cached --restart=always --name registry registry:2

# docker push localhost:5000/{image}
 