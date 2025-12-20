
FROM mcr.microsoft.com/devcontainers/go:1.25-bookworm

# Install gnupg2 for share GPG keys
RUN <<EOF
	apt-get update
	apt-get install --no-install-recommends gnupg2=2 --yes
	apt-get clean
	rm -rf /var/lib/apt/lists/*
EOF

CMD [ "sleep", "infinity" ]
