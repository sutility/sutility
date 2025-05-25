FROM --platform=$TARGETPLATFORM alpine:latest
ARG TARGETARCH


RUN apk update \
 && apk add --no-cache bash \
 && apk add --no-cache curl \
 && apk add --no-cache openssh \
 && apk add --no-cache openssl \
 && apk add --no-cache jq \
 && apk --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add yq \
 && apk add --no-cache apache2-utils \
 && apk --no-cache add git git-lfs gpg less openssh patch perl && git lfs install


RUN KUBECTL_VERSION="1.33.1" \
 && curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
 && curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl.sha256" \
 && echo "$(cat ./kubectl.sha256)  kubectl" | sha256sum -c \
 && rm ./kubectl.sha256 \
 && chmod +x kubectl \
 && mv kubectl /usr/local/bin/kubectl


RUN ORAS_VERSION="1.2.3" \
 && curl -LO "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz" \
 && curl -LO "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_checksums.txt" \
 && echo "$(cat ./oras_${ORAS_VERSION}_checksums.txt | grep oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz)" | sha256sum -c \
 && rm "./oras_${ORAS_VERSION}_checksums.txt" \
 && tar -xzvf "./oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz" "oras" \
 && rm "./oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz" \
 && mv oras /usr/local/bin/oras


RUN TRIVY_VERSION="0.62.1" \
 && TRIVY_ARCH="Linux-64bit"; if [ "${TARGETARCH}" = "arm64" ]; then TRIVY_ARCH="Linux-ARM64"; fi \
 && curl -LO "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz" \
 && curl -LO "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_checksums.txt" \
 && echo "$(cat ./trivy_${TRIVY_VERSION}_checksums.txt | grep trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz)" | sha256sum -c \
 && rm "./trivy_${TRIVY_VERSION}_checksums.txt" \
 && tar -xzvf "./trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz" "trivy" \
 && rm "./trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz" \
 && mv trivy /usr/local/bin/trivy


RUN adduser -D -s /bin/sh sutility
USER sutility
WORKDIR /home/sutility


CMD ["/bin/bash"]
