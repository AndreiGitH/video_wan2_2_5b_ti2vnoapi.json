# clean base image
FROM runpod/worker-comfyui:5.5.1-base

CMD sh -c "\
    echo '>>> Criando diretórios de modelos...' && \
    mkdir -p /comfyui/models/diffusion_models \
             /comfyui/models/loras \
             /comfyui/models/vae \
             /comfyui/models/text_encoders && \
    \
    echo '>>> Verificando volume montado...' && \
    if [ ! -d /runpod-volume/models ]; then \
        echo 'AVISO: /runpod-volume/models não encontrado! Continuando sem symlinks...'; \
    else \
        echo '>>> Criando symlinks para diffusion_models...' && \
        find /runpod-volume/models/diffusion_models -maxdepth 1 -type f 2>/dev/null | \
            xargs -I{} ln -sf {} /comfyui/models/diffusion_models/ && \
        \
        echo '>>> Criando symlinks para loras...' && \
        find /runpod-volume/models/loras -maxdepth 1 -type f 2>/dev/null | \
            xargs -I{} ln -sf {} /comfyui/models/loras/ && \
        \
        echo '>>> Criando symlinks para vae...' && \
        find /runpod-volume/models/vae -maxdepth 1 -type f 2>/dev/null | \
            xargs -I{} ln -sf {} /comfyui/models/vae/ && \
        \
        echo '>>> Criando symlinks para text_encoders...' && \
        find /runpod-volume/models/text_encoders -maxdepth 1 -type f 2>/dev/null | \
            xargs -I{} ln -sf {} /comfyui/models/text_encoders/ && \
        \
        echo '>>> Symlinks criados com sucesso!'; \
    fi && \
    \
    echo '>>> Iniciando worker...' && \
    python /start.py"
