FROM ghcr.io/runatlantis/atlantis:v0.24.2

LABEL org.opencontainers.image.source = "https://github.com/unsafesystems/container-atlantis"

ARG TARGETARCH
RUN wget "https://github.com/gruntwork-io/terragrunt/releases/download/v0.46.2/terragrunt_linux_$TARGETARCH" -O terragrunt && \
	chmod +x terragrunt && \
	mv terragrunt /usr/local/bin/terragrunt
