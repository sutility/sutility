FROM --platform=$BUILDPLATFORM alpine:latest
ARG TARGETARCH


RUN apk update && apk add --no-cache bash jq


RUN adduser -D -s /bin/sh sutility
USER sutility


CMD ["/bin/bash"]
