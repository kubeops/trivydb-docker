FROM registry.access.redhat.com/ubi10/ubi-minimal

LABEL org.opencontainers.image.source https://github.com/kubeops/trivydb-docker

ARG TARGETOS
ARG TARGETARCH
ARG TAG

ARG ORAS_VERSION=1.0.0
ARG KUBECTL_VERSION=1.31.14

LABEL org.opencontainers.image.source="https://github.com/kubeops/trivydb-docker" \
    name="trivydb" \
    maintainer=AppsCode \
    vendor=AppsCode \
    version=${TAG} \
    release=${TAG} \
    summary="Trivy CVE Database" \
    description="Trivy CVE Database"

RUN mkdir -p /licenses
COPY LICENSE /licenses/

RUN set -x \
  && microdnf update -y \
  && microdnf install -y ca-certificates curl gzip tar tzdata wget \
  && microdnf clean all

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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
