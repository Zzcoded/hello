FROM ubuntu:22.04

WORKDIR /app

# 设置pip镜像源加快下载速度
ENV PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/
ENV PIP_TRUSTED_HOST=mirrors.aliyun.com
ENV DEBIAN_FRONTEND=nonin
ENV TZ=Asia/Shanghai

# 设置apt源为阿里云镜像并安装基本工具
# 后续再指定一些包的版本
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    # ffmpeg version 7.1.1 Copyright (c) 2000-2025 the FFmpeg developers
    ffmpeg \
    # Inkscape 1.4 (86a8ad7, 2024-10-11)
    inkscape \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    poppler-utils \
    libmagic1 \
    redis-tools \
    wget \
    curl \
    ca-certificates \
    iputils-ping \
    dnsutils \
    iproute2 \
    # golang 1.30.0
    golang \
    netcat-openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY . .

# 创建Python虚拟环境并安装依赖
RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install --no-cache-dir -r requirements.txt

# 设置环境变量
ENV PATH="/app/venv/bin:${PATH}"
ENV PYTHONPATH="/app/venv/lib/python3.10/site-packages:${PYTHONPATH}"
ENV GOPATH="/root/go"
ENV PATH="/root/go/bin:${PATH}"
