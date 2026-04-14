# clean base image
FROM runpod/worker-comfyui:5.5.1-base

CMD sh -c "\
    echo '>>> Iniciando worker...' && \
    python /start.py"
