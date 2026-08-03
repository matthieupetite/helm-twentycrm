# Changelog

All notable changes to this project will be documented in this file.

## [0.4.1] - 2026-08-03

### Fixed
- **Security:** Removed hardcoded `nginx.ingress.kubernetes.io/configuration-snippet` annotation from ingress template
  - The snippet was blocked by Nginx Ingress Controllers with snippets disabled for security
  - This is not a breaking change as Nginx Ingress automatically handles `X-Forwarded-For` headers
  - Improves compatibility with security-hardened Kubernetes clusters

### Why this change?
- Nginx Ingress Controller automatically adds proxy headers (`X-Forwarded-For`, `X-Forwarded-Proto`, `X-Real-IP`)
- Configuration snippets pose security risks (code injection) and are disabled in many production clusters
- Standard annotations are sufficient for proper proxy configuration

## [0.4.0] - 2026-08-03

### Added
- **SSL/TLS Support:** Full support for HTTPS with cert-manager integration
  - New `ingress.ssl.enabled` flag to enable/disable SSL
  - Automatic cert-manager annotation when SSL is enabled
  - Configurable ClusterIssuer via `ingress.ssl.clusterIssuer`
  - Auto-generated TLS secret names or custom via `ingress.ssl.secretName`
  - SERVER_URL automatically uses `https://` when SSL is enabled
- **External Redis Support:** Ability to use external Redis instead of deploying one
  - New `redis.enabled` flag to control Redis deployment
  - New `externalRedis.enabled` and `externalRedis.connectionString` for external Redis
  - Conditional Redis deployment and service based on configuration
- **Documentation:** Complete examples and usage guides for SSL and external Redis
- Example configuration file: `examples/values-ssl.yaml`

### Changed
- Updated to latest Twenty CRM compatibility (aligned with Docker Compose v2026)
- Database image updated from `twentycrm/twenty-postgres:latest` to `postgres:16`
- Database default name changed from `twenty` to `default`
- Redis deployment now includes proper health probes and `--maxmemory-policy noeviction`

### Fixed
- Missing `ENCRYPTION_KEY` environment variable (now required)
- Removed deprecated token secrets (`ACCESS_TOKEN_SECRET`, `LOGIN_TOKEN_SECRET`, etc.)
- Fixed message queue configuration inconsistencies
- Added proper health checks for all services

## [0.3.0] - 2026-08-03

### Added
- Updated workflow to deploy chart to personal GitHub account using dynamic repository variables
- Chart compatibility verified against official Twenty CRM Docker Compose configuration

### Changed
- Helm repository URL now uses GitHub context variables for automatic adaptation

## [0.2.0] - Previous version

### Initial release
- Basic Twenty CRM deployment support
- PostgreSQL and Redis deployment
- Ingress configuration
- Basic environment variable support
