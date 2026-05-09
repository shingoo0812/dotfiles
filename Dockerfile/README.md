## NOTE: Using fast DNS during the build process requires daemon configuration in Docker Desktop
Docker Desktop -> Settings -> Docker Engine
```
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}

```


## NOTE: 
```
:UpdateRemotePlugins

```

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

## If you want to access WSL files in the neovim
```
:e /wsl/home

```
