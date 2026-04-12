# clean base image
FROM runpod/worker-comfyui:5.5.1-base

# Instalando os motores e ferramentas de sistema
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# Copia o recepcionista (handler) para a raiz do container
COPY handler.py /handler.py

# Comando de Inicialização Ajustado:
# Se no Pod você usou /workspace/models/, no Serverless o caminho vira /runpod-volume/models/
CMD sh -c "\
    mkdir -p /comfyui/models/loras /comfyui/models/vae /comfyui/models/text_encoders && \
    ln -sf /runpod-volume/models/loras/* /comfyui/models/loras/ && \
    ln -sf /runpod-volume/models/vae/* /comfyui/models/vae/ && \
    ln -sf /runpod-volume/models/text_encoders/* /comfyui/models/text_encoders/ && \
    python -u /handler.py"
