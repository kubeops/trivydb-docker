FROM alpine

LABEL org.opencontainers.image.source https://github.com/kubeops/trivydb-docker

ARG TARGETOS
ARG TARGETARCH

ARG ORAS_VERSION=0.16.0
ARG KUBECTL_VERSION=1.25.2
ARG KURL_VERSION=0.1.5

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

RUN set -x \
  && wget https://github.com/segmentio/kubectl-curl/releases/download/v${KURL_VERSION}/kubectl-curl_v${KURL_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz \
  && mkdir -p curl-install/ \
  && tar -zxf kubectl-curl_v${KURL_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz -C curl-install/ \
  && mv curl-install/kubectl-curl_v${KURL_VERSION}_${TARGETOS}_${TARGETARCH} /usr/bin/kubectl-curl \
  && rm -rf kubectl-curl_v${KURL_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz curl-install/

ADD update-trivydb.sh /scripts/update-trivydb.sh
ADD extract.sh /scripts/extract.sh
ADD upload-report.sh /scripts/upload-report.sh
