# Base oficial leve e otimizada para serverless
FROM runpod/worker-comfyui:5.5.1-base

# Instalação dos Custom Nodes essenciais para Wan 2.2 e Vídeos
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# Copia o recepcionista (handler) para a raiz do container
COPY handler.py /handler.py

# Comando de Inicialização:
# 1. Garante que as pastas de modelos existam no container
# 2. Cria atalhos para os arquivos pesados (LoRA, VAE, Encoders) que estão no NVWan22
# 3. Inicia o motor do RunPod
CMD sh -c "\
    mkdir -p /comfyui/models/loras /comfyui/models/vae /comfyui/models/text_encoders && \
    ln -sf /runpod-volume/models/loras/* /comfyui/models/loras/ && \
    ln -sf /runpod-volume/models/vae/* /comfyui/models/vae/ && \
    ln -sf /runpod-volume/models/text_encoders/* /comfyui/models/text_encoders/ && \
    python -u /handler.py"
