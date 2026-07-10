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

if [[ $? -ne 0 ]]; then
	printf "\e[31mFailed to change directory to project root.\e[0m\n" >&2
	exit 1
fi

# Exit on any command failure
set -e

# Install packages (formatters, linters, and git hooks manager)
printf "\e[90m\nInstalling project tools (formatters, linters, and git hooks manager)...\e[0m\n\n"

bun add --dev \
	prettier@^3 \
	prettier-plugin-astro@^0 \
	@biomejs/biome@^2 \
	lefthook@^2

printf "\e[32m\nProject tools installed successfully.\e[0m\n"

# Create Visual Studio Code setting and recommended extensions files
printf "\e[90m\nCreating Visual Studio Code setting and recommended extensions files...\e[0m\n\n"

jq '.customizations.vscode.settings' .devcontainer/devcontainer.json > .vscode/settings.json
jq '{recommendations: .customizations.vscode.extensions}' .devcontainer/devcontainer.json > .vscode/extensions.json

printf "\e[32m\nVisual Studio Code setting and recommended extensions files created successfully.\e[0m\n"

# Set git hooks
printf "\e[90m\nSetting up git hooks...\e[0m\n\n"

bun run lefthook install

printf "\e[32m\nGit hooks set successfully.\e[0m\n"

# Install Frontend dependencies
printf "\e[90m\nInstalling Frontend dependencies...\e[0m\n\n"

cd frontend/
bun install
cd ../

printf "\e[32m\nFrontend dependencies installed successfully.\e[0m\n"

# Health check
printf "\e[90m\nRunning health check...\e[0m\n\n"

bash scripts/health-check.sh --env=local

printf "\e[32m\nAll tools are installed and working correctly.\e[0m\n"

# Show welcome message
printf "\n# Welcome to the local environment\n\n"

printf "\e[33mTo finish the installation of necessary tools, please open the extensions sidebar, type \`@recommended\` and install the recommended extensions for VSCode.\e[0m\n"

printf "\e[90m\n> If you want to make a commit, we recommend you \`git commit -m \"COMMIT MESSAGE\"\` instead of using VSCode interface.\e[0m\n"
