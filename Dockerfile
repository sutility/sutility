FROM --platform=$BUILDPLATFORM alpine:latest
ARG TARGETARCH


RUN apk update && apk add --no-cache curl bash openssh jq yq


RUN KUBECTL_VERSION="v1.33.0-rc.1" \
 && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
 && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl.sha256" \
 && echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c \
 && chmod +x kubectl \
 && mv kubectl /usr/local/bin/kubectl


RUN adduser -D -s /bin/sh sutility
USER sutility
WORKDIR /home/sutility


CMD ["/bin/bash"]
