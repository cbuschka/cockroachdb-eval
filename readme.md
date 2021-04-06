# Playing with cockroachdb

## Requirements
* docker
* docker-compose >= 3.8 support
* local psql client

## Usage

### First start the cluster
```
make start-cluster
```

### Init the cluster (first time only)
```
make init-cluster
```

### Connect to cockroachdb dashboard
```
xdg-open http://localhost:8080
```

### Connect to cockroachdb via psql client
```
psql postgresql://root@localhost:26257?sslmode=disable
```

## License
[MIT](./license.txt)
