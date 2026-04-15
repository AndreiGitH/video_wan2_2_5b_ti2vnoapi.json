FROM runpod/worker-comfyui:5.8.5-base

# Força rebuild sem cache
ARG CACHE_BUST=2

RUN cd /comfyui && \
    git fetch && \
    git checkout 8f37471

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
RUN cd /comfyui && git log --oneline -1
