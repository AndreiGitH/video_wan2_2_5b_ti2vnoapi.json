import runpod
import requests
import json
import time

COMFY_URL = "http://127.0.0.1:8188"

def wait_for_comfyui():
    """Tenta conectar ao ComfyUI por até 2 minutos (tempo de carregar o Wan 2.2)"""
    max_retries = 60
    for i in range(max_retries):
        try:
            # Tenta acessar a API de info do ComfyUI
            requests.get(f"{COMFY_URL}/object_info", timeout=2)
            print("ComfyUI está ONLINE e pronto!")
            return True
        except:
            print(f"Aguardando ComfyUI carregar modelos... ({i+1}/{max_retries})")
            time.sleep(2)
    return False

def handler(job):
    # O handler agora espera o motor ligar antes de qualquer coisa
    if not wait_for_comfyui():
        return {"error": "O ComfyUI demorou demais para iniciar (Timeout)."}

    try:
        job_input = job['input']
        workflow = job_input.get('workflow')

        if not workflow:
            return {"error": "Workflow não fornecido."}

        # Envia o prompt de texto
        p = {"prompt": workflow}
        data = json.dumps(p).encode('utf-8')
        response = requests.post(f"{COMFY_URL}/prompt", data=data).json()
        prompt_id = response['prompt_id']

        # Monitora a fila
        while True:
            history = requests.get(f"{COMFY_URL}/history/{prompt_id}").json()
            if prompt_id in history:
                return {
                    "status": "completed",
                    "output": history[prompt_id]['outputs']
                }
            time.sleep(2)

    except Exception as e:
        return {"error": str(e)}

runpod.serverless.start({"handler": handler})
