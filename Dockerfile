FROM docker-private.infra.cloudera.com/cloudera/dex/dex-spark-runtime-3.5.1-7.2.18.0:1.23.1-b114
USER root

RUN dnf -y install dnf-utils && \
    dnf config-manager --set-enabled appstream && \
    dnf config-manager --set-enabled powertools && \
    dnf -y groupinstall "Development Tools" && \
    dnf -y install \
    gcc \
    openssl-devel \
    libffi-devel \
    bzip2-devel \
    wget \
    python39 \
    python39-devel && \
    # Clean up cached data to reduce image size
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN update-alternatives --remove-all python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
RUN rm /usr/bin/python3
RUN ln -s /usr/bin/python3.9 /usr/bin/python3
RUN yum install python39-pip
RUN /usr/bin/python3.9 -m pip install numpy==1.22.0 pandas==1.2.5 pickleshare==0.7.5 py4j==0.10.9 pyarrow==4.0.1 python-dateutil==2.8.1 six==1.15.0 pyparsing==2.4.7 jmespath
RUN /usr/bin/python3.9 -m pip install dbldatagen
USER ${DEX_UID}
