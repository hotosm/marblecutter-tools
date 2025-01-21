FROM ghcr.io/osgeo/gdal:ubuntu-full-3.10.1
ARG http_proxy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
    bc \
    ca-certificates \
    curl \
    git \
    jq \
    nfs-common \
    build-essential \
    parallel \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/marblecutter-tools

COPY requirements.txt /opt/marblecutter-tools/requirements.txt

ENV CPL_VSIL_CURL_ALLOWED_EXTENSIONS .vrt,.tif,.tiff,.ovr,.msk,.jp2,.img,.hgt
ENV GDAL_DISABLE_READDIR_ON_OPEN TRUE
ENV VSI_CACHE TRUE
ENV VSI_CACHE_SIZE 536870912

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN pip3 install --upgrade setuptools
RUN pip3 install rasterio haversine cython awscli requests

COPY bin/* /opt/marblecutter-tools/bin/

RUN chmod +x /opt/marblecutter-tools/bin/process.sh
RUN chmod +x /opt/marblecutter-tools/bin/process.py

RUN ln -s /opt/marblecutter-tools/bin/* /usr/local/bin/ && mkdir -p /efs
