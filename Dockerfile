ARG ATLANTIS_VERSION
FROM ghcr.io/runatlantis/atlantis:${ATLANTIS_VERSION}

LABEL org.opencontainers.image.source = "https://github.com/unsafesystems/atlantis"

ARG TARGETARCH
RUN wget "https://github.com/gruntwork-io/terragrunt/releases/download/v0.46.1/terragrunt_linux_$TARGETARCH" -O terragrunt && \
	chmod +x terragrunt && \
	mv terragrunt /usr/local/bin/terragrunt
