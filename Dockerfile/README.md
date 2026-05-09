## Basic Command
1.docker up detach
docker compose up -d
2.docker run
docker compose run -it ubuntu /bin/bash
3.docker compose build
docker compose up --build
4.Remove all containers
docker container prune -f

## Stop the Docker Container
```
docker compose down

```

## Compose build
- When you want to force an update of the base image or package
```
docker compose build --no-cache

```

## Launch the Docker Container
```
docker compose up -d

```

## Launch nvim in Docker Container
```
docker exec -it dotfiles-nvim nvim

```
