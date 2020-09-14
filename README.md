# docker.had321.hive312

# Docker Container with Hive 3.1.2 over Hadoop 3.2.1
## Maintainer: Venu Yanamandra (venu.yanamandra@live.com)
Docker setup to create a container with Hadoop 3.2.1 &amp; Hive 3.1.2 

## Build the docker image
```bash
    git clone https://github.com/vyanamandra/docker.had321.hive312.git
    docker build -t vyanamandra:0.1-hd321-hi312 .
    docker run -itd -p 10000:10000 --name vy.had321.hive312 vyanamandra:0.1-had321.hive312
```
## Let's say you already have a mariadb docker instance running in your cluster
##  You could start it like this -

```bash
    docker run -itd -p 10000:10000 --name vy.had321.hive312 vyanamandra:0.1-had321.hive312
```

