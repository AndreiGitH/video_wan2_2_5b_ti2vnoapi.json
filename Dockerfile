FROM runpod/worker-comfyui:5.7.1-base

ENTRYPOINT ["/bin/sh", "-c", "\
    echo '>>> Criando symlinks...' && \
    mkdir -p /comfyui/models/diffusion_models \
             /comfyui/models/loras \
             /comfyui/models/vae \
             /comfyui/models/text_encoders && \
    find /runpod-volume/models/diffusion_models -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/diffusion_models/ && \
    find /runpod-volume/models/loras -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/loras/ && \
    find /runpod-volume/models/vae -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/vae/ && \
    find /runpod-volume/models/text_encoders -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/text_encoders/ && \
    echo '>>> Symlinks OK, iniciando...' && \
    python /start.py"]
