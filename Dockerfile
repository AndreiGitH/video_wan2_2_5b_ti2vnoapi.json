# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
# No registry-verified custom nodes found.
# Unknown registry nodes present but no aux_id provided, cannot auto-install:
# - MarkdownNote (unknown_registry) — no aux_id, skipping
# - LoraLoaderModelOnly (unknown_registry) — no aux_id, skipping

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors --relative-path models/text_encoders --filename umt5_xxl_fp8_e4m3fn_scaled.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan2.2_vae.safetensors --relative-path models/vae --filename wan2.2_vae.safetensors
RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/blob/main/FastWan/Wan2_2_5B_FastWanFullAttn_lora_rank_128_bf16.safetensors --relative-path models/loras --filename Wan2_2_5B_FastWanFullAttn_lora_rank_128_bf16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors --relative-path models/diffusion_models --filename wan2.2_ti2v_5B_fp16.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
