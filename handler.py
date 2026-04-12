import runpod
import requests
import json
import time

# Endereço interno do ComfyUI no container
COMFY_URL = "http://127.0.0.1:8188"

def handler(job):
    try:
        # Pega o JSON que você enviou do seu script local
        job_input = job['input']
        workflow = job_input.get('workflow')

        if not workflow:
            return {"error": "Workflow não fornecido no JSON de input."}

        # 1. Envia o workflow para a fila do ComfyUI
        p = {"prompt": workflow}
        data = json.dumps(p).encode('utf-8')
        response = requests.post(f"{COMFY_URL}/prompt", data=data).json()
        prompt_id = response['prompt_id']

        # 2. Monitora o processamento (Poll)
        while True:
            history = requests.get(f"{COMFY_URL}/history/{prompt_id}").json()
            if prompt_id in history:
                # O vídeo terminou de renderizar!
                output_data = history[prompt_id]['outputs']
                
                # Procura pelo nó de SaveVideo (Node 58 no seu JSON)
                # Retorna o nome do arquivo para o seu script local baixar
                return {
                    "status": "completed",
                    "output": output_data,
                    "refresh_worker": False
                }
            
            time.sleep(2) # Espera 2 segundos para checar novamente

    except Exception as e:
        return {"error": str(e)}

# Inicia o serviço serverless
runpod.serverless.start({"handler": handler})
