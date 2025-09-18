#!/bin/bash
function ctrl_c(){
  echo -e "\n\n [!] Saliendo...\n"
  exit 1
}


trap ctrl_c INT

for i in $(seq 1 254); do
  timeout 1 bash -c "ping -c 1 10.0.2.$i &>/dev/null" && echo "[+] Host 10.0.2.$i - ACTIVE" &
done;  wait
