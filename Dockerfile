FROM runpod/worker-comfyui:5.5.1-base

CMD sh -c "\
    echo '>>> Criando diretórios...' && \
    mkdir -p /comfyui/models/diffusion_models \
             /comfyui/models/loras \
             /comfyui/models/vae \
             /comfyui/models/text_encoders && \
    \
    if [ ! -d /workspace/models ]; then \
        echo 'AVISO: Volume não montado!'; \
    else \
        find /workspace/models/loras -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/loras/ && \
        find /workspace/models/vae -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/vae/ && \
        find /workspace/models/text_encoders -maxdepth 1 -type f 2>/dev/null | xargs -I{} ln -sf {} /comfyui/models/text_encoders/ && \
        echo '>>> Symlinks OK!'; \
    fi && \
    \
    python /start.py"
