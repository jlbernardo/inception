# _*_ Makefile _*_

# COLOR CODES
DFL = \033[0m
GRN = \033[32;1m
BLU = \033[34;1m
RED = \033[31;1m
PRP = \033[35;1m

all: setup up
	@echo "$(PRP)"
	@echo "ALL CONTAINERS ARE UP AND RUNNING ◝(ᵔᵕᵔ)◜"
	@echo "Access https://julberna.42.fr/ to see the website!"
	@echo "$(DFL)"

setup:
	@sudo mkdir -p /home/julberna/data/wordpress
	@sudo mkdir -p /home/julberna/data/mariadb
	@sudo chmod -R 755 /home/julberna/data/wordpress
	@sudo chmod -R 755 /home/julberna/data/mariadb

up:
	@echo "$(GRN)"
	@echo "*~ STARTING UP THE ENVIRONMENT ~*"
	@echo "$(DFL)"
	@sudo docker-compose -f ./srcs/docker-compose.yml up -d

down:
	@echo "$(RED)"
	@echo "*~ STOPPING THE ENVIRONMENT ~*"
	@echo "$(DFL)"
	@sudo docker-compose -f ./srcs/docker-compose.yml down

show:
	@echo "$(BLU)"
	@echo " *~ CONTAINERS$(DFL)"
	@sudo docker-compose -f ./srcs/docker-compose.yml ps
	@echo "$(BLU)"
	@echo " *~ IMAGES$(DFL)"
	@sudo docker-compose -f ./srcs/docker-compose.yml images

volumes:
	@echo "$(BLU)"
	@echo " *~ VOLUMES$(DFL)"
	@sudo docker volume inspect db-volume wp-volume

clean:
	@echo "$(BLU)"
	@echo "*~ CLEANING UP THE ENVIRONMENT ~*"
	@echo "$(DFL)"
	@sudo docker-compose -f ./srcs/docker-compose.yml down -v --rmi all --remove-orphans

fclean: clean
	@docker system prune --volumes --all --force
	@sudo rm -rf /home/julberna/data/mariadb
	@sudo rm -rf /home/julberna/data/wordpress

re: fclean show all

.PHONY: all up down clean fclean re
