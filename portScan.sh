#!/bin/bash
function ctrl_c(){
  echo -e "\n\n [!] Saliendo...\n" 
  tput cnorm;  exit 1
}


trap ctrl_c INT

tput civis #Oculta el cursor
for port in $(seq 1 65535); do
  (echo '' > /dev/tcp/localhost/$port) 2>/dev/null && echo "[+] $port - OPEN" &
done; wait

#Recuperamos el cursor
tput cnorm
