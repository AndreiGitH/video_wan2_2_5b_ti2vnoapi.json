FROM runpod/worker-comfyui:5.7.1-base

RUN cd /comfyui && \
    git fetch && \
    git checkout 8f37471 && \
    pip install --quiet -r requirements.txt

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
