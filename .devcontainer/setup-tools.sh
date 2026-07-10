#! /bin/bash

# Parse options
while [[ $# -gt 0 ]]; do
	case "$1" in
		-h | --help)
			need_help='true'
			shift 1
			break
			;;

		--)
			shift 1
			break
			;;

		-*)
			printf "\e[31mAn invalid option was found!\e[0m\n" >&2
			exit 1
			;;

        *)
            break
            ;;
	esac
done

# Show help if needed
if [ -n "$need_help" ]; then
	printf "Usage: $0 [OPTION]...

Setup project tools (linters, formatters, and git hooks).

Options:
	-h, --help   display this help and exit
"
	exit 0
fi

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

if [[ $? -ne 0 ]]; then
	printf "\e[31mFailed to change directory to project root.\e[0m\n" >&2
	exit 1
fi

# Exit on any command failure
set -e

# Install packages (formatters, linters, and git hooks manager)
printf "\e[90m\nInstalling project tools (formatters, linters, and git hooks manager)...\n\e[0m\n"

bun add --dev \
	prettier@^3 \
	prettier-plugin-astro@^0 \
	@biomejs/biome@^2 \
	lefthook@^2

printf "\e[32m\nProject tools installed successfully.\e[0m\n"

# Pull images
zizmor_image='ghcr.io/zizmorcore/zizmor:1.22.0' # Linter for Dependabot configuration file and GitHub Actions workflows.

printf "\e[90m\nPulling docker images project tools...\n\e[0m\n"

docker pull "$zizmor_image"

printf "\e[32m\nDocker images pulled successfully.\e[0m\n"

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
printf "\e[90m\nSetting up git configuration and hooks...\n\e[0m\n"

git config --global --add safe.directory /workspaces/UNLaM-Calendar

bun run lefthook install

printf "\e[32m\nGit configuration and hooks set successfully.\e[0m\n"

# Install Frontend dependencies
printf "\e[90m\nInstalling Frontend dependencies...\n\e[0m\n"

cd frontend/
bun install
cd ../

printf "\e[32m\nFrontend dependencies installed successfully.\e[0m\n"

# Health check
printf "\e[90m\nRunning health check...\n\e[0m\n"

bash scripts/health-check.sh

printf "\e[32m\nAll tools are installed and working correctly.\e[0m\n"
