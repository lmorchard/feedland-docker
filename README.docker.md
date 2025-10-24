# FeedLand Docker Setup

This directory contains a complete Docker-based setup for running FeedLand locally with all required services.

## Services Included

- **FeedLand Application**: The main Node.js application
- **MySQL 8.0**: Database server with automatic schema initialization
- **Minio**: S3-compatible object storage for feeds and user content (includes automatic bucket setup)
- **MailHog**: Email testing tool that captures all outgoing emails

## Quick Start

1. **Copy the environment file**:
   ```bash
   cp .env.example .env
   ```

   Edit `.env` if you want to customize ports or credentials.

2. **Start all services**:
   ```bash
   docker compose up -d
   ```

   This will automatically:
   - Initialize the MySQL database with the FeedLand schema
   - Create the Minio bucket with appropriate permissions
   - Start all required services

3. **Wait for services to be ready** (first time may take a minute):
   ```bash
   docker compose logs -f feedland
   ```

   Wait until you see the application is running.

4. **Access the services**:
   - **FeedLand**: http://localhost:1452
   - **Minio Console**: http://localhost:9001 (login: feedland/feedland123)
   - **MailHog Web UI**: http://localhost:8025

## Create Your FeedLand Account

1. Visit http://localhost:1452
2. Click "Sign up" and create your account
3. Check MailHog at http://localhost:8025 for the confirmation email
4. Click the confirmation link

## Configuration

### Environment Variables

Edit `.env` to customize:

- **Ports**: Change if you have conflicts with other services
- **Credentials**: Update passwords for production use
- **Database**: MySQL settings

### Application Configuration

Edit `config.json` to customize FeedLand behavior:

- **Domain**: Update `myDomain` and related URLs if hosting publicly
- **Features**: Enable/disable user feeds, likes feeds, etc.
- **S3 Paths**: Adjust Minio bucket paths
- **Email**: Already configured for MailHog

## Common Operations

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f feedland
docker compose logs -f mysql
```

### Restart Services

```bash
# Restart all
docker compose restart

# Restart specific service
docker compose restart feedland
```

### Stop Services

```bash
docker compose down
```

### Stop and Remove All Data

```bash
docker compose down -v
```

⚠️ This will delete the database and all stored content!

### Access MySQL Database

```bash
docker compose exec mysql mysql -u feedland -pfeedland feedland
```

### Update FeedLand

If you make changes to the application or configuration:

```bash
# Rebuild and restart
docker compose up -d --build feedland
```

## Troubleshooting

### FeedLand won't start

Check the logs:
```bash
docker compose logs feedland
```

Common issues:
- MySQL not ready yet (wait a bit longer)
- Config.json syntax error
- Port already in use

### Can't access services

Verify services are running:
```bash
docker compose ps
```

Check port mappings in `.env` and `docker-compose.yml`.

### Email not working

1. Check MailHog is running: `docker compose ps mailhog`
2. Visit MailHog UI at http://localhost:8025
3. Verify `config.json` has correct SMTP settings (host: `mailhog`, port: `1025`)

### S3/Minio issues

The `feedland` bucket should be created automatically on startup. If you're having issues:

1. Verify Minio is running and accessible at http://localhost:9001
2. Check the minio-init logs: `docker compose logs minio-init`
3. Verify the bucket was created (you can check in Minio Console)
4. Check `config.json` S3 paths match your bucket structure

If the bucket wasn't created, you can manually run:
```bash
docker compose up minio-init
```

## File Structure

```
feedland/
├── feedlandInstall-main/     # Unpacked from main.zip (original files)
│   ├── config.json           # Original config (not used)
│   ├── feedland.js
│   ├── package.json
│   └── ...
├── Dockerfile                # New: Builds FeedLand container
├── docker-compose.yml        # New: Orchestrates all services
├── config.json               # New: Docker-specific config
├── init-db.sql              # New: Database schema
├── .env                     # New: Environment variables (create from .env.example)
├── .env.example             # New: Template for environment variables
└── README.docker.md         # New: This file
```

## Network Architecture

All services run on a shared Docker network and communicate using service names:

- FeedLand connects to MySQL at hostname `mysql`
- FeedLand connects to MailHog at hostname `mailhog`
- FeedLand connects to Minio at hostname `minio` (but uses localhost URLs for browser access)

## Production Deployment

For production use, consider:

1. Use strong passwords in `.env`
2. Update `config.json` with your real domain
3. Configure proper S3 credentials if using real AWS S3
4. Replace MailHog with real SMTP credentials
5. Set up SSL/TLS termination (reverse proxy recommended)
6. Configure backups for MySQL and Minio volumes
7. Review security settings in all services

## Next Steps

1. Import your OPML feed list
2. Customize your reading preferences
3. Explore the FeedLand documentation
4. Consider setting up GitHub backup in `config.json`

## Support

For FeedLand issues, see: https://github.com/scripting/feedlandInstall
