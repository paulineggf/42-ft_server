docker build -t ft_server .
docker run -itd -p 80:80 -p 443:443 ft_server
docker exec -it [ID] sh
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)

