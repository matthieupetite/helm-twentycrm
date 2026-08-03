# TwentyCRM helm chart

This repository provides a Helm chart to deploy [Twenty CRM](https://twenty.com/).

## Install

Create a `values.yaml` file and put all your config (see `Configuration` section), then run:

```bash
helm repo add twentycrm https://matthieupetite.github.io/helm-twentycrm
helm upgrade -i twenty-crm twentycrm/twentycrm -f values.yaml
```

## Prerequisites

Before installing, you must generate an encryption key:

```bash
openssl rand -base64 32
```

Add this to your `values.yaml`:

```yaml
secrets:
  encryptionKey: "your-generated-key-here"
```

**WARNING:** Keep this key secure! Losing it means losing access to all encrypted secrets in the database.

## Configuration

For a complete list of configuration fields, check the [values.yaml](./charts/twentycrm/values.yaml) file.

### Core Configuration

| Field Name                       | Description                                                                               | Default Value           |
|----------------------------------|-------------------------------------------------------------------------------------------|-------------------------|
| `image`                          | Docker image for the application.                                                        | `twentycrm/twenty:latest` |
| `env`                            | [Environment variables](https://docs.twenty.com/developers/self-host/capabilities/setup) for configuring the application.| See values.yaml|
| `secrets.encryptionKey`          | **REQUIRED** Encryption key for secrets at rest. Generate with `openssl rand -base64 32` |                         |
| `secrets.fallbackEncryptionKey`  | Previous encryption key during rotation                                                  |                         |
| `server.replicas`                | Number of server replicas.                                                               | `1`                     |
| `server.storage`                 | Storage size for the server.                                                             | `5Gi`                   |
| `server.storageClassName`        | Storage class name for server persistence.                                               |                         |
| `server.resources.requests.memory` | Memory resource request for the server.                                                 | `128Mi`                 |
| `server.resources.requests.cpu`  | CPU resource request for the server.                                                    | `100m`                  |
| `worker.replicas`                | Number of worker replicas.                                                               | `1`                     |
| `worker.resources.requests.memory` | Memory resource request for workers.                                                   | `128Mi`                 |
| `worker.resources.requests.cpu`  | CPU resource request for workers.                                                       | `100m`                  |

### Database Configuration

| Field Name                       | Description                                                                               | Default Value           |
|----------------------------------|-------------------------------------------------------------------------------------------|-------------------------|
| `db.enabled`                     | Deploy PostgreSQL database (set to `false` to use external database)                    | `true`                  |
| `db.image`                       | Docker image for the PostgreSQL database.                                                | `postgres:16`           |
| `db.storage`                     | Storage size for the database.                                                           | `5Gi`                   |
| `db.storageClassName`            | Storage class name for database persistence.                                             |                         |
| `db.database`                    | Name of the database.                                                                    | `default`               |
| `db.user`                        | Database user name.                                                                      | `postgres`              |
| `db.password`                    | Password for the database user.                                                         | `postgres`              |
| `db.resources.requests.memory`   | Memory resource request for the database.                                               | `256Mi`                 |
| `db.resources.requests.cpu`      | CPU resource request for the database.                                                  | `100m`                  |
| `externalDb.enabled`             | Use external PostgreSQL database instead of deploying one                                | `false`                 |
| `externalDb.postgresConnectionString` | Connection string for external PostgreSQL (e.g., `postgres://user:pass@host:5432/db`) |                    |

### Redis Configuration

| Field Name                       | Description                                                                               | Default Value           |
|----------------------------------|-------------------------------------------------------------------------------------------|-------------------------|
| `redis.enabled`                  | Deploy Redis cache (set to `false` to use external Redis)                               | `true`                  |
| `redis.image`                    | Docker image for Redis.                                                                  | `redis:latest`          |
| `redis.resources.requests.memory` | Memory resource request for Redis.                                                     | `128Mi`                 |
| `redis.resources.requests.cpu`   | CPU resource request for Redis.                                                         | `20m`                   |
| `externalRedis.enabled`          | Use external Redis instead of deploying one                                              | `false`                 |
| `externalRedis.connectionString` | Connection string for external Redis (e.g., `redis://host:6379`)                        |                         |

### Ingress Configuration

| Field Name                       | Description                                                                               | Default Value           |
|----------------------------------|-------------------------------------------------------------------------------------------|-------------------------|
| `ingress.enabled`                | Enable or disable ingress.                                                              | `true`                  |
| `ingress.host`                   | Hostname for the ingress.                                                               | `crm.example.com`       |
| `ingress.class`                  | Ingress class name.                                                                      | `nginx`                 |

## Usage Examples

### Using External Redis

To use an existing Redis instance instead of deploying a new one:

```yaml
# values.yaml
redis:
  enabled: false  # Don't deploy Redis

externalRedis:
  enabled: true
  connectionString: "redis://my-redis-host:6379"
```

Examples of Redis connection strings:
- Basic: `redis://redis-host:6379`
- With authentication: `redis://username:password@redis-host:6379`
- With database number: `redis://redis-host:6379/0`
- Kubernetes service: `redis://redis.namespace.svc.cluster.local:6379`

### Using External Database

To use an existing PostgreSQL database:

```yaml
# values.yaml
db:
  enabled: false  # Don't deploy PostgreSQL

externalDb:
  enabled: true
  postgresConnectionString: "postgres://user:password@db-host:5432/twentycrm"
```

### Complete Example

```yaml
# values.yaml
image: twentycrm/twenty:latest

secrets:
  encryptionKey: "your-base64-encoded-key-here"

server:
  replicas: 2
  storage: 10Gi
  resources:
    requests:
      memory: "512Mi"
      cpu: "250m"
    limits:
      memory: "1Gi"
      cpu: "500m"

worker:
  replicas: 2
  resources:
    requests:
      memory: "256Mi"
      cpu: "200m"

# Use external Redis
redis:
  enabled: false

externalRedis:
  enabled: true
  connectionString: "redis://my-redis.default.svc.cluster.local:6379"

# Deploy internal PostgreSQL
db:
  enabled: true
  storage: 20Gi
  password: "strong-password-here"

ingress:
  enabled: true
  host: crm.mycompany.com
  class: nginx
```

## Documentation

For more information:
- [Twenty CRM Documentation](https://docs.twenty.com)
- [Self-Hosting Configuration](https://docs.twenty.com/developers/self-host/capabilities/setup)
- [Docker Compose Setup](https://docs.twenty.com/developers/self-hosting/docker-compose)

