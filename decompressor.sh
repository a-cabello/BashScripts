#!/bin/bash
#Ctrl+c

function ctrl_c(){
  echo -e "\n\n[!] Saliendo...\n"
  exit 1
}

trap ctrl_c INT

first_file_name="data.gz"
decompressed_file_name="$(7z l data.gz | tail -3 | head -1 | awk 'NF{print $NF}')"

7z x $first_file_name &>/dev/null

while [ $decompressed_file_name ]; do
	echo -e "\n[+]Nuevo archivo descomprimido: $decompressed_file_name"
	7z x $decompressed_file_name &>/dev/null
	decompressed_file_name="$(7z l $decompressed_file_name 2>/dev/null | tail -3 | head -1 | awk 'NF{print $NF}')"
done
