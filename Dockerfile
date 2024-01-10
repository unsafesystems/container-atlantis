FROM ghcr.io/runatlantis/atlantis:v0.27.0 as deps

FROM ruby:3.3.0-alpine3.18

LABEL org.opencontainers.image.source = "https://github.com/unsafesystems/container-atlantis"

# copy binary
COPY --from=deps /usr/local/bin/atlantis /usr/local/bin/atlantis

ARG TARGETARCH
ENV TERRAGRUNT_VERSION=0.46.3
ENV TERRAFORM_VERSION=1.5.0
ENV TERRASPACE_VERSION=2.2.7

RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
	git~=2.40 && \
	apk add --no-cache curl build-base ruby-dev aws-cli && \
    gem install terraspace --no-document -v ${TERRASPACE_VERSION} && \
    curl -LOs "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" && \
	curl -LOs "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS" && \
	sed -n "/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip/p" "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum -c && \
	mkdir -p "/usr/local/bin/tf/versions/${TERRAFORM_VERSION}" && \
	unzip "terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" -d "/usr/local/bin/tf/versions/${TERRAFORM_VERSION}" && \
    mv "/usr/local/bin/tf/versions/${TERRAFORM_VERSION}/terraform" /usr/local/bin/terraform && \
    rm -rf "/usr/local/bin/tf" && \
	rm "terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" && \
	rm "terraform_${TERRAFORM_VERSION}_SHA256SUMS"; \
	wget "https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_$TARGETARCH" -O terragrunt && \
	chmod +x terragrunt && \
	mv terragrunt /usr/local/bin/terragrunt && \
	apk del curl build-base ruby-dev

ENTRYPOINT ["/bin/sh"]
