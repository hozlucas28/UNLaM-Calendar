#! /bin/bash

# Parse options
options=$(getopt -o "h" --long "help" -- "$@")

if [ $? -ne 0 ]; then
	echo -e "\e[31mAn error occurred on parsing options.\e[0m" >&2
	exit 1
fi

eval set -- "$options"

while true; do
	case "$1" in
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

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

if [[ $? -ne 0 ]]; then
	echo -e "\e[31mFailed to change directory to project root.\e[0m" >&2
	exit 1
fi

exit_code=0


# ------------------------------- Common Tools ------------------------------- #

echo -e "Checking common tools...\n"

yq --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[31m  - YQ is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
else
	echo -e "\e[32m  - YQ installed.\e[0m"
fi

bun --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[31m  - Bun is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
else
	echo -e "\e[32m  - Bun installed.\e[0m"
fi

bun run prettier --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[31m  - Prettier is not installed.\e[0m" >&2
	exit_code=1
else
	echo -e "\e[32m  - Prettier installed\e[0m"
fi

bun run biome --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[31m  - Biome is not installed.\e[0m" >&2
	exit_code=1
else
	echo -e "\e[32m  - Biome installed\e[0m"
fi

docker --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[31m - Docker is not installed,not found in PATH, or not running.\e[0m" >&2
	exit_code=1
else
	echo -e "\e[32m  - Docker installed.\e[0m"
fi

lefthook --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[31m  - Lefthook is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
else
	echo -e "\e[32m  - Lefthook installed.\e[0m"
fi


# -------------------------- Dedicated Backend Tools ------------------------- #

echo -e "\nChecking dedicated Backend tools...\n"

go version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[31m  - Go is not installed or not found in PATH.\e[0m" >&2
	exit_code=1
else
	echo -e "\e[32m  - Go installed.\e[0m"
fi

golangci-lint --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo -e "\e[33m  - Golangci-lint is not installed or not found in PATH.\e[0m" >&2
	exit_code=2
else
	echo -e "\e[32m  - Golangci-lint installed.\e[0m"
fi


exit $exit_code
