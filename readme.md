docker build -t ft_server .
docker run -itd -p 80:80 -p 443:443 ft_server
docker exec -it [ID] sh
