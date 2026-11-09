# Docker Health Monitor

A Bash-based monitoring utility for Docker containers, developed as part of a hands-on Cloud/DevOps engineering portfolio.

## Features

- Checks whether a Docker container exists
- Detects running and stopped containers
- Reports Docker health-check status when available
- Returns exit codes suitable for automation
- Supports testing container failures and recovery

## Technologies

- Ubuntu Server 24.04 LTS
- Docker Engine
- Bash
- Git and GitHub

## Requirements

- Linux with Bash
- Docker Engine installed and running
- Permission to access the Docker daemon

## Usage

Clone the repository:

```bash
git clone https://github.com/kwprice1987/docker-health-monitor.git
cd docker-health-monitor
```

Run the monitoring script:

```bash
sudo ./scripts/check-container.sh CONTAINER_NAME
```

Example:

```bash
sudo ./scripts/check-container.sh devops-nginx
```

Expected output for a running container:

```text
Container: devops-nginx
State: running
Health: not-configured
OK: Container is running
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Container running and not reporting unhealthy |
| 1 | Container stopped or unhealthy |
| 2 | Missing argument, container not found, or inspection unavailable |
| 3 | Docker health check still starting |

## Failure Testing

Stop a test container:

```bash
sudo docker stop devops-nginx
```

Run the monitoring script:

```bash
sudo ./scripts/check-container.sh devops-nginx
echo $?
```

Expected result:

```text
CRITICAL: Container is not running
1
```

Restart the container:

```bash
sudo docker start devops-nginx
sudo ./scripts/check-container.sh devops-nginx
```

The script should now return exit code 0.

## Limitations

- Docker permissions are required.
- A running container without a configured health check is not necessarily healthy.
- The script monitors one container per execution.
- It does not automatically restart failed containers.

## Future Improvements

- HTTP endpoint health checks
- JSON output
- Automated tests
- Scheduled monitoring
- GitHub Actions CI/CD
- Notifications and alerting

## Author

Kristopher Price
