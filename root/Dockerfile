FROM alpine

LABEL org.opencontainers.image.source https://github.com/kubeops/trivydb-docker

ARG TARGETOS
ARG TARGETARCH

ARG ORAS_VERSION=1.0.0
ARG KUBECTL_VERSION=1.31.14

RUN set -x \
	&& apk add --update --no-cache ca-certificates curl

RUN set -x \
  && wget https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz \
  && mkdir -p oras-install/ \
  && tar -zxf oras_${ORAS_VERSION}_*.tar.gz -C oras-install/ \
  && mv oras-install/oras /bin/ \
  && rm -rf oras_${ORAS_VERSION}_*.tar.gz oras-install/

RUN set -x \
	&& curl -fsSL https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-${TARGETOS}-${TARGETARCH}.tar.gz | tar -zxv \
    && mv /kubernetes/client/bin/kubectl /usr/bin/kubectl \
    && rm -rf /kubernetes

ADD scripts/update-trivydb.sh /scripts/update-trivydb.sh
ADD scripts/extract.sh /scripts/extract.sh
