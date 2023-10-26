FROM docker.io/nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/7fa2af80.pub && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 libglib2.0-0 wget git curl vim python3.10 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/QwenLM/Qwen.git && \
    cd /Qwen && \
    pip3 install -r requirements.txt && \
    pip3 install -r requirements_web_demo.txt

COPY --from=registry.cn-beijing.aliyuncs.com/xiangxian-ali/qwen:model-only-7b /Qwen-7B-Chat/ /Qwen/models/Qwen-7B-Chat

WORKDIR /Qwen/

CMD ["python3", "web_demo.py", "--checkpoint-path=/Qwen/models/Qwen-7B-Chat", "--server-name=0.0.0.0","--server-port=8888"]
