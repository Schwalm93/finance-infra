#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ENV_FILE:-$SCRIPT_DIR/.env}"
COMPOSE_FILE="${COMPOSE_FILE:-$SCRIPT_DIR/docker-compose.yml}"
PROFILE="${PROFILE:-}"

usage() {
  cat <<'EOF'
Usage:
  ./deploy.sh <command> [service]

Commands:
  pull            Pull all images from .env
  up              Start/update stack in detached mode
  deploy          Pull + up + ps (recommended update flow)
  ps              Show current container status
  logs [service]  Show logs (all services or one service)
  restart [svc]   Restart all services or one service
  down            Stop stack
  help            Show this help

Environment overrides:
  ENV_FILE=/path/to/.env
  COMPOSE_FILE=/path/to/docker-compose.yml
  PROFILE=tools   Enable optional tools profile (e.g. pgweb)
EOF
}

compose() {
  local args=(--env-file "$ENV_FILE" -f "$COMPOSE_FILE")
  if [[ -n "$PROFILE" ]]; then
    args+=(--profile "$PROFILE")
  fi
  docker compose "${args[@]}" "$@"
}

require_files() {
  if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing env file: $ENV_FILE"
    exit 1
  fi
  if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "Missing compose file: $COMPOSE_FILE"
    exit 1
  fi
}

main() {
  local cmd="${1:-help}"
  local target="${2:-}"
  require_files

  case "$cmd" in
    pull)
      compose pull
      ;;
    up)
      compose up -d
      ;;
    deploy)
      compose pull
      compose up -d
      compose ps
      ;;
    ps)
      compose ps
      ;;
    logs)
      if [[ -n "$target" ]]; then
        compose logs --tail 200 -f "$target"
      else
        compose logs --tail 200 -f
      fi
      ;;
    restart)
      if [[ -n "$target" ]]; then
        compose restart "$target"
      else
        compose restart
      fi
      compose ps
      ;;
    down)
      compose down
      ;;
    help|-h|--help)
      usage
      ;;
    *)
      echo "Unknown command: $cmd"
      usage
      exit 1
      ;;
  esac
}

main "$@"
