#!/usr/bin/env bash

if [ -z "${MODEL+x}" ]; then
  MODEL="TheBloke/Synthia-34B-v1.2-GPTQ"
fi

# Replace slashes with underscores
MODEL="${MODEL//\//_}"

echo "Worker Initiated"

echo "Starting Oobabooga Text Generation Server"
cd /workspace/text-generation-webui
mkdir -p /workspace/logs
nohup python3 server.py \
  --listen \
  --api \
  --loader ExLlama \
  --model ${MODEL} \
  --listen-port 3000 \
  --api-blocking-port 5000 \
  --api-streaming-port 5005 &> /workspace/logs/textgen.log &

echo "Starting RunPod Handler"
export PYTHONUNBUFFERED=1
python -u /rp_handler.py
