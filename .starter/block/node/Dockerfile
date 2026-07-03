# add node and npm
# hadolint ignore=DL3008
RUN <<-EOF
	apt-get update
	apt-get install -y --no-install-recommends \
		nodejs \
		npm
	rm -rf /var/lib/apt/lists/*
EOF
