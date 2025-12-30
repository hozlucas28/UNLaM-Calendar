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

Set up the local development environment for the project.

Options:
	-h, --help     display this help and exit
"
	exit 0
fi

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

# Install packages (formatters, linters, and git hooks manager)
echo -e "\e[30m\nInstalling repository tools (formatters, linters, and git hooks manager)...\n\e[0m"

bun add --dev \
	prettier@^3 \
	prettier-plugin-astro@^0 \
	@biomejs/biome@^2 \
	lefthook@^2

echo -e "\e[32m\nRepository tools installed successfully.\e[0m"

# Create Visual Studio Code setting and recommended extensions files
echo -e "\e[30m\nCreating Visual Studio Code setting and recommended extensions files...\n\e[0m"

jq '.customizations.vscode.settings' .devcontainer/devcontainer.json > .vscode/settings.json
jq '{recommendations: .customizations.vscode.extensions}' .devcontainer/devcontainer.json > .vscode/extensions.json

echo -e "\e[32m\nVisual Studio Code setting and recommended extensions files created successfully.\e[0m"

# Set git hooks
echo -e "\e[30m\nSetting up git hooks...\n\e[0m"

bun run lefthook install

echo -e "\e[32m\nGit hooks set successfully.\e[0m"

# Install Frontend dependencies
echo -e "\e[30m\nInstalling Frontend dependencies...\n\e[0m"

cd frontend/
bun install
cd ../

echo -e "\e[32m\nFrontend dependencies installed successfully.\e[0m"

# Health check
echo -e "\e[30m\nRunning health check...\n\e[0m"

bash scripts/health-check.sh --env=local

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
echo -e "\n# Welcome to the local environment\n"

echo -e "You have to do a few things before you start coding:\n"

echo -e "\e[33m  1. Open the extensions sidebar, type \`@recommended\` and install the recommended extensions for VSCode.\e[0m"
echo -e "\e[33m  2. Press \`F1\` and run the command \`> Go: Install/Update Tools\` to install Go tools (it may take a while).\e[0m"

echo -e "\e[30m\n> If you want to make a commit, we recommend you \`git commit\` (without \`-m\` option) instead of using VSCode interface.\e[0m"

