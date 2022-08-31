#!/usr/bin/env bash
set -euo pipefail # Exit on any non-zero exit code, and error on use of undefined var
REQUIRED_PYTHON="3.8.11"
REQUIRED_DOCKER="20.*"
REQUIRED_DOCKER_COMPOSE="2.10.*"

export ROOT_DIR="$(dirname "$0")"
cd "$ROOT_DIR"


if [[ $EUID == 0 ]]; then
  cat <<-EOF >&2
  You must run this script WITHOUT root privileges
  Please do:
  $ROOT_DIR/${0##*/}
EOF
  exit 1
fi

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

success_message() {
  echo -e "\033[0;32m ✔️  $1  \t\033[0m"
}

warning_message() {
  echo -e "\033[0;33m  $1  \t\033[0m"
}

info_message() {
  echo -e "\033[0;34m  $1  \t\033[0m"
}

error_message() {
  echo -e "\033[0;31m  $1  \t\033[0m"
}

write_to_bashrc() {
  # $1 is the string to add to bashrc, will be added if not already present
  grep -qF -- "$1" "$HOME/.bashrc" || echo "$1" >>"$HOME/.bashrc"
}

info_message "Installing / updating docker"
if command_exists docker; then
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
  curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && rm -f get-docker.sh
fi
write_to_bashrc "export DOCKER_BUILDKIT=1"

set +euo pipefail # Exit on any non-zero exit code, and error on use of undefined var
if ! [[ $(groups | grep "docker") ]]; then
  warning_message "Docker user not found, adding..."
  sudo groupadd docker || true
  sudo usermod -aG docker "$USER" || true
else
  success_message "Docker user already configured"
fi
set -euo pipefail # Exit on any non-zero exit code, and error on use of undefined var

info_message "Installing / updating docker compose"
INSTALLED_DOCKER_COMPOSE=$(docker compose version | grep -o '[[:digit:]].*')

if [[ $(echo $INSTALLED_DOCKER_COMPOSE | grep "$REQUIRED_DOCKER_COMPOSE") == "" ]]; then
  warning_message "docker compose version is currently $INSTALLED_DOCKER_COMPOSE , must be ~= $REQUIRED_DOCKER_COMPOSE"
  info_message "Attempting to install new version"
  mkdir -p "$HOME/.docker/cli-plugins" &&
    curl -SL https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep -wo https.*docker-compose-$(uname | awk '{print tolower($0)}')-$(uname -m)$ | wget -i - -O "$HOME/.docker/cli-plugins/docker-compose" &&
    chmod +x "$HOME/.docker/cli-plugins/docker-compose"
else
  success_message "Docker compose version '$INSTALLED_DOCKER_COMPOSE' is up to date with requirement '$REQUIRED_DOCKER_COMPOSE'"
fi
