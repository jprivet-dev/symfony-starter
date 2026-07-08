# add node and npm
# hadolint ignore=DL3008
RUN <<-EOF
	curl -fsSL https://deb.nodesource.com/setup_NODE_MAJOR_LTS_VERSION.x | bash -
	apt-get install -y --no-install-recommends nodejs
	rm -rf /var/lib/apt/lists/*
EOF
