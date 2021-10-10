# Playing with cockroachdb

## Ingredients
* GNU make based cockroach cluster setup
* non root cockroach db image

## Requirements
* docker
* docker-compose >= 3.8 support
* local psql client

## Usage

### First create/start the cluster

This
* generates certs
* starts a cluster
* inits the cluster (if new)
* configures cluster settings
* creates a user dba

```
make start-cluster
```

### Connect to cockroachdb dashboard
```
xdg-open http://localhost:8080
```

### Connect to cockroachdb via psql client
```
psql postgresql://root@localhost:26257?sslmode=disable
```

### Destroy cluster
```
make destroy-cluster
```

## License
[MIT](./license.txt)
