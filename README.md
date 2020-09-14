# docker.had321.hive312

# Docker Container with Hive 3.1.2 over Hadoop 3.2.1
# Maintainer: Venu Yanamandra (venu.yanamandra@live.com)
Docker setup to create a container with Hadoop 3.2.1 &amp; Hive 3.1.2 


## Ensure the hive-site.xml has the correct JDBC URL, Username & Password.


## Build the docker image
```bash
    git clone https://github.com/vyanamandra/docker.had321.hive312.git
    cd docker.had321.hive312
    docker build -t vyanamandra:0.1-hd321-hi312 .
```

## Let's say you already have a mariadb docker instance running in your cluster
##  You could start it like this -

```bash
    docker run -itd -p 10000:10000 --name vy.had321.hive312 vyanamandra:0.1-had321.hive312
```

## You could now use beeline or a utility like DBeaver (https://dbeaver.io/) to connect to this instance.

# Any changes or improvements, please email me @ prodev.py@gmail.com. I will be very happy to learn.
