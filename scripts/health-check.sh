#! /bin/bash

# Parse options
options=$(getopt -o "e:h" --long "env:,help" -- "$@")

if [ $? -ne 0 ]; then
	echo -e "\e[31mAn error occurred on parsing options.\e[0m" >&2
	exit 1
fi

eval set -- "$options"

while true; do
	case "$1" in
		"-e" | "--env")
			env="$2"
			shift 2
			;;
		"-h" | "--help")
			need_help="true"
			shift 1
			break
			;;
		"--")
			shift
			break
			;;
		*)
			echo -e "\e[31mAn internal error occurred!\e[0m" >&2
			exit 1
			;;
		esac
done

# Show help if needed
if [[ -n "$need_help" ]]; then
	printf "Usage: $0 [OPTIONS]...

Perform a health check of the tools needed to contribute on this project.

Options:
	-h, --help     display this help and exit
"
	exit 0
fi

# Gets command version
command_version() {
	local version

	if version=$("$@" 2>/dev/null); then
		echo "v$(echo "$version" | grep --perl-regexp --only-matching '\d+\.\d+\.\d+' | head --lines=1)"
	else
		return 1
	fi
}

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

if [[ $? -ne 0 ]]; then
	echo -e "\e[31mFailed to change directory to project root.\e[0m" >&2
	exit 1
fi

exit_code=0


if command -v go >/dev/null 2>&1; then
	echo -e "\e[32m- Go $(command_version go version) installed.\e[0m"
else
	echo -e "\e[31m- Go is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if command -v node >/dev/null 2>&1; then
	echo -e "\e[32m- Node.js $(command_version node --version) installed.\e[0m"
else
	echo -e "\e[31m- Node.js is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if command -v bun >/dev/null 2>&1; then
	echo -e "\e[32m- Bun $(command_version bun --version) installed.\e[0m"
else
	echo -e "\e[31m- Bun is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if command -v golangci-lint >/dev/null 2>&1; then
	echo -e "\e[32m- Golangci-lint $(command_version golangci-lint version) installed.\e[0m"
else
	echo -e "\e[33m  - Golangci-lint is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if command -v gitleaks >/dev/null 2>&1; then
	echo -e "\e[32m- Gitleaks $(command_version gitleaks --version) installed.\e[0m"
else
	echo -e "\e[31m- Gitleaks is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if command -v renovate >/dev/null 2>&1; then
	echo -e "\e[32m- Renovate $(command_version act --version) installed.\e[0m"
else
	echo -e "\e[31m- Renovate is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if command -v act >/dev/null 2>&1; then
	echo -e "\e[32m- act $(command_version act --version) installed.\e[0m"
else
	echo -e "\e[31m- act is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if command -v gh >/dev/null 2>&1; then
	echo -e "\e[32m- GitHub CLI $(command_version gh --version) installed.\e[0m"
else
	echo -e "\e[31m- GitHub CLI is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi

if [[ "$env" == "local" ]]; then
	if command -v jq >/dev/null 2>&1; then
		echo -e "\e[32m- jq $(command_version jq --version) installed.\e[0m"
	else
		echo -e "\e[31m- jq is not installed or not found in PATH.\e[0m" >&2
		exit_code=1
	fi
fi

if command -v docker >/dev/null 2>&1; then
	echo -e "\e[32m- Docker $(command_version docker --version) installed.\e[0m"
else
	echo -e "\e[31m- Docker is not installed, not found in PATH, or not running.\e[0m" >&2
	exit_code=1
fi

if version=$(command_version bun run prettier --version); then
	echo -e "\e[32m- Prettier $version installed.\e[0m"
else
	echo -e "\e[31m- Prettier is not installed.\e[0m" >&2
	exit_code=1
fi

if version=$(command_version bun run biome --version); then
	echo -e "\e[32m- Biome $version installed.\e[0m"
else
	echo -e "\e[31m- Biome is not installed.\e[0m" >&2
	exit_code=1
fi

if version=$(command_version bun run lefthook --version); then
	echo -e "\e[32m- Lefthook $version installed.\e[0m"
else
	echo -e "\e[31m- Lefthook is not installed.\e[0m" >&2
	exit_code=1
fi

if command -v zizmor >/dev/null 2>&1; then
	echo -e "\e[32m- Zizmor $(command_version zizmor --version) installed.\e[0m"
else
	echo -e "\e[31m- Zizmor is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
fi


exit $exit_code
