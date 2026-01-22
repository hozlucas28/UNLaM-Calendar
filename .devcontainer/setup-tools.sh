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

# Exit on any command error
set -e

# Show help if needed
if [ -n "$need_help" ]; then
	printf "Usage: $0 [OPTION]...

Setup repository tools (linters, formatters, and git hooks).

Options:
	-h, --help   display this help and exit
"
	exit 0
fi

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

# Install packages (formatters, linters, and git hooks manager)
echo -e "\e[90m\nInstalling repository tools (formatters, linters, and git hooks manager)...\n\e[0m"

bun add --dev \
	prettier@^3 \
	prettier-plugin-astro@^0 \
	@biomejs/biome@^2 \
	lefthook@^2

echo -e "\e[32m\nRepository tools installed successfully.\e[0m"

# Pull images
zizmor_image="ghcr.io/zizmorcore/zizmor:latest" # Linter for Dependabot file and GitHub Actions workflows

echo -e "\e[90m\nPulling docker images repository tools...\n\e[0m"

docker pull "$zizmor_image"

echo -e "\e[32m\nDocker images pulled successfully.\e[0m"

# Create bin scripts
echo "#! /bin/bash

docker run \\
	--rm \\
	--name zizmor \\
	--volume /workspaces/UNLaM-Calendar/:/workspaces/UNLaM-Calendar/ \\
	--workdir /workspaces/UNLaM-Calendar/ \\
	$zizmor_image \\
	\"\$@\"
" > /usr/local/bin/zizmor

# Allow execution of scripts
chmod +x /usr/local/bin/zizmor
chmod +x /workspaces/UNLaM-Calendar/scripts/*.sh

# Set git configuration and hooks
echo -e "\e[90m\nSetting up git configuration and hooks...\n\e[0m"

git config --global --add safe.directory /workspaces/UNLaM-Calendar

bun run lefthook install

echo -e "\e[32m\nGit configuration and hooks set successfully.\e[0m"

# Install Frontend dependencies
echo -e "\e[90m\nInstalling Frontend dependencies...\n\e[0m"

cd frontend/
bun install
cd ../

echo -e "\e[32m\nFrontend dependencies installed successfully.\e[0m"

# Health check
echo -e "\e[90m\nRunning health check...\n\e[0m"

bash scripts/health-check.sh

echo -e "\e[32m\nAll tools are installed and working correctly.\e[0m"
