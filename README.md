# docker.had321.hive312

    
# Docker Container with Hive 3.1.2 over Hadoop 3.2.1
## Maintainer: Venu Yanamandra
Docker setup to create a container with Hadoop 3.2.1 &amp; Hive 3.1.2 


    
### Ensure the hive-site.xml has the correct JDBC URL, Username & Password.

    

## Build the docker image
```bash
    git clone https://github.com/vyanamandra/docker.had321.hive312.git
    cd docker.had321.hive312
    docker build -t vyanamandra:0.1-had321.hive312 .
```

    
## Let's say you already have a mariadb docker instance running in your cluster
##  You could start it like this -

```bash
    docker run -itd -p 10000:10000 --name vy.had321.hive312 vyanamandra:0.1-had321.hive312
```

## You could now use any client utility to connect to this hive (hs2) instance servicing requests on port 10000.
  If I may suggest, please try DBeaver (https://dbeaver.io/) it is fun!
    
    
## ToDo:
Use external volumes for conf/logs/[name/data]node dirs.

### Any changes or improvements:
  Please leave a comment. I will be very happy to learn.
