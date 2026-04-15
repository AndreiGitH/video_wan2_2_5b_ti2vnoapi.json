FROM runpod/worker-comfyui:5.7.1-base

ENTRYPOINT ["/bin/sh", "-c", "\
    echo '>>> Verificando volumes...' && \
    echo '--- /workspace ---' && \
    ls /workspace 2>/dev/null || echo 'workspace nao existe' && \
    echo '--- /workspace/models ---' && \
    ls /workspace/models 2>/dev/null || echo 'workspace/models nao existe' && \
    echo '--- /runpod-volume ---' && \
    ls /runpod-volume 2>/dev/null || echo 'runpod-volume nao existe' && \
    echo '>>> Criando symlinks...' && \
    mkdir -p /comfyui/models/diffusion_models \
             /comfyui/models/loras \
             /comfyui/models/vae \
             /comfyui/models/text_encoders && \
    find /workspace/models/diffusion_models -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/diffusion_models/ && \
    find /workspace/models/loras -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/loras/ && \
    find /workspace/models/vae -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/vae/ && \
    find /workspace/models/text_encoders -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/text_encoders/ && \
    echo '--- /comfyui/models/diffusion_models ---' && \
    ls /comfyui/models/diffusion_models && \
    echo '>>> Iniciando...' && \
    python /start.py"]
