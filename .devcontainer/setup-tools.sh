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

# Exit on error
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
echo -e "\nInstalling repository tools (formatters, linters, and git hooks manager)...\n"

bun add --dev \
	prettier@^3 \
	@biomejs/biome@^2

echo ""
go install github.com/evilmartians/lefthook/v2@v2

echo -e "\e[32m\nRepository tools installed successfully.\e[0m"

# Pull images
zizmor_image="ghcr.io/zizmorcore/zizmor:1.16.3" # Linter for Dependabot files and GitHub Actions workflows

echo -e "\nPulling docker images repository tools...\n"

docker pull "$zizmor_image"

echo -e "\e[32m\nDocker images pulled successfully.\e[0m"

# Create bin scripts
echo "#! /bin/bash

# Convert relative paths to absolute paths
arguments=()
for argument in \"\$@\"; do
	if [[ \"\$argument\" == ./* ]]; then
		arguments+=(\"\$(realpath \"\$argument\")\")
	else
		arguments+=(\"\$argument\")
	fi
done

docker run \\
	--rm \\
	--name zizmor \\
	--volume /workspaces/UNLaM-Calendar/:/workspaces/UNLaM-Calendar/ \\
	$zizmor_image \\
	\"\${arguments[@]}\"
" > /usr/local/bin/zizmor

# Allow execution of scripts
chmod +x /usr/local/bin/zizmor
chmod +x /workspaces/UNLaM-Calendar/scripts/*.sh

# Set git configuration and hooks
echo -e "\nSetting up git configuration and hooks...\n"

git config --global --add safe.directory /workspaces/UNLaM-Calendar
lefthook install

echo -e "\e[32m\nGit configuration and hooks set successfully.\e[0m"

# Health check
echo -e "\e[30m\nRunning health check...\n\e[0m"

bash ./scripts/health-check.sh

if [ $? -eq 0 ]; then
	echo -e "\e[32m\nAll tools are installed and working correctly.\e[0m"
else
	if [ $? -eq 1 ]; then
		echo -e "\e[31mHealth check failed.\e[0m" >&2
		exit 1
	else
		echo -e "\e[33mHealth check completed with warnings.\e[0m"
	fi
fi

# Show welcome message
echo -e "\n# Welcome to the Devcontainer\n"

echo -e "Development container is set up with all the necessary tools and configurations to help you get started quickly, but
you have to do a few things before you start coding:\n"

echo -e "\e[33m  1. Press \`F1\` and run the command \`> Go: Install/Update Tools\` to install Go tools (it may take a while).\e[0m"
echo -e "\e[33m  2. (Optional) Set \`user.name\` and \`user.email\` git configuration properties (may not be required).\e[0m"

echo -e "\e[30m\n> After completing these steps, we recommend you to run the health check script (\`bash ./scripts/health-check.sh\`).\e[0m"
