# Andersen DevOps online course 11-12.2021 

## Homework 5
Build a docker container for your python app!
- this time it needs to listen port 8080, HTTP only
- the lighter in terms of image size it is – the more points you get
- the one who builds the smallest image gets even more points!
### Hints:
- use the minimal possible setup  
- 100MB is a lot ;-)

## Name
Homework 5. Python + Flask app in Docker container

## Description
Docker image for flask application from Homework 2:   
https://github.com/alexeyput/andr-devops/tree/main/homework2

## Files
homework5-0.1.tar.gz - docker image exported with command:
```
docker save homework5:0.1 | gzip > ./image/homework5-0.1.tar.gz
```

## Import image
Copy **homework5-0.1.tar.gz**  to a remote server and issue:
```
docker load < homework5-0.1.tar.gz
```

## Known bugs
To be done during the test operation

## Possible improvements
Use **FROM scratch** to make the image smaller. 

