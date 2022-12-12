# T-POO-700-PAR_4

## Mount with docker compose
```
docker compose up -d
```

## Generate the database
```
docker exec BACK_END_CONTAINER_NAME mix ecto.create
docker exec BACK_END_CONTAINER_NAME mix ecto.migrate
```
