import runpod
import requests
import json
import time

COMFY_URL = "http://127.0.0.1:8188"

def wait_for_comfyui():
    """Aguarda o ComfyUI estar pronto para receber conexões."""
    retries = 30  # Tenta por até 60 segundos
    for i in range(retries):
        try:
            requests.get(f"{COMFY_URL}/object_info")
            print("ComfyUI está ONLINE!")
            return True
        except requests.exceptions.ConnectionError:
            print(f"Aguardando ComfyUI... (Tentativa {i+1}/{retries})")
            time.sleep(2)
    return False

def handler(job):
    if not wait_for_comfyui():
        return {"error": "ComfyUI não iniciou a tempo."}

    try:
        job_input = job['input']
        workflow = job_input.get('workflow')

        # Se houver uma imagem no input, você deve salvá-la como 'example.png' aqui
        # para satisfazer o Node 56 do seu JSON.

        p = {"prompt": workflow}
        data = json.dumps(p).encode('utf-8')
        response = requests.post(f"{COMFY_URL}/prompt", data=data).json()
        prompt_id = response['prompt_id']

        while True:
            history = requests.get(f"{COMFY_URL}/history/{prompt_id}").json()
            if prompt_id in history:
                return {"status": "completed", "output": history[prompt_id]['outputs']}
            time.sleep(2)

    except Exception as e:
        return {"error": str(e)}

runpod.serverless.start({"handler": handler})
