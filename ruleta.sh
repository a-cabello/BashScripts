#!/bin/bash

#Colours, para ponerlos en codigo es ${greenColour}textoACambiarColor${endColour}
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!]${endColour} ${grayColour}Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso${endColour}${grayColour}:${endColour} ${blueColour}$0${endColour}\n"
  echo -e "\t ${purpleColour}-m${endColour} ${grayColour}<Dinero con el que se quiere jugar ${endColour}(INTEGER)${grayColour}>${endColour}"
  echo -e "\t ${purpleColour}-t${endColour} ${grayColour}<Tecnica que desea emplear ${endColour}(martingala / inverseLabrouchere)${grayColour}>${endColour}\n"
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual:${endColour} ${yellowColour}$money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}Cuanto dinero tienes pensado apostar? ->${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}A que deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar

  echo -e "${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con${endColour} ${yellowColour}$initial_bet€${endColour} ${grayColour}a${endColour} ${yellowColour}$par_impar${endColour}"

  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas=""

  tput civis #Ocultar el cursor
  while true; do
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Acabas de apostar${endColour} ${yellowColour}$initial_bet€${endColour} ${grayColour}y tienes${endColour} ${yellowColour}$money€${endColour}"
    random_number="$(($RANDOM % 37))"
#    echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el número${endColour} ${yellowColour}$random_number${endColour}"
    
    if [ "$money" -ge 0 ]; then
      if [ "$par_impar" == "par" ]; then
        if [ "$((random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el numero $random_number,${endColour} ${redColour}PIERDES!${endColour}"
            initial_bet=$(($initial_bet * 2))
            jugadas_malas+="$random_number "
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo te quedas en${endColour} ${yellowColour}$money${endColour}"
          else
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}El número $random_number es par, ${endColour}${greenColour}GANAS!${endColour}"
            reward=$(($initial_bet * 2))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de${endColour} ${yellowColour}$reward€${endColour}"
            money=$(($money + $reward))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money€${endColour}"
            initial_bet=$backup_bet
            jugadas_malas=""
          fi
        else
#          echo -e "${yellowColour}[+]${endColour} ${grayColour}El número $random_number es impar, ${endColour}${redColour}PIERDES!${endColour}"
          initial_bet=$(($initial_bet * 2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo te quedas en${endColour} ${yellowColour}$money${endColour}"
        fi
      else
        if [ "$((random_number % 2))" -eq 1 ]; then
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}El número $random_number es impar, ${endColour}${greenColour}GANAS!${endColour}"
            reward=$(($initial_bet * 2))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de${endColour} ${yellowColour}$reward€${endColour}"
            money=$(($money + $reward))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money€${endColour}"
            initial_bet=$backup_bet
            jugadas_malas=""
        else
#          echo -e "${yellowColour}[+]${endColour} ${grayColour}El número $random_number es par, ${endColour}${redColour}PIERDES!${endColour}"
          initial_bet=$(($initial_bet * 2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo te quedas en${endColour} ${yellowColour}$money${endColour}"
        fi
      fi

    else
      #Nos quedamos sin dinero
      echo -e "\n${redColour}[+] Te has quedado sin pasta cabron${endColour}\n"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Han habido un total de${endColour} ${yellowColour}$(($play_counter-1))${endColour} ${grayColour}jugadas${endColour}"

      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}A continuacion se van a representar las malas jugadas que han salido de forma consecutiva:${endColour}\n"
      echo -e "${blueColour}$jugadas_malas"
      tput cnorm; exit 0
    fi
    let play_counter+=1
  done

  tput cnorm #Recuperamos el cursor

}

function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual:${endColour} ${yellowColour}$money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}A que deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar 

  declare -a my_sequence=(1 2 3 4)
  declare -i play_counter=0
  
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comenzamos con la secuencia${endColour} ${greenColour}${my_sequence[@]}${endColour}"

  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

  tput civis
  while true; do
    random_number=$(($RANDOM % 37))
    if [ "$money" -gt 0 ]; then
      money=$(($money - $bet))
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Invertimos ${endColour}${yellowColour}$bet€${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour} ${yellowColour}$money€${endColour}"
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Ha salido el numero${endColour} ${blueColour}$random_number${endColour}"
      if [ "$par_impar" == "par" ]; then
      
        if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then

          echo -e "${yellowColour}[+]${endColour} ${grayColour}El numero${endColour} ${yellowColour}$random_number${endColour} ${grayColour}es par, ${endColour}${greenColour}GANAS!${endColour}"
          reward=$(($bet * 2))
          let money+=$reward
          my_sequence+=($bet)
          my_sequence=(${my_sequence[@]})
          if [ "${#my_sequence[@]}" -gt 1 ]; then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[+] Hemos perdido nuestra secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

          fi
          echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour} ${yellowColour}$money€${endColour}"


          echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra nueva secuencia es${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
          
        elif [ $(($random_number % 2)) -eq 1 ] || [ "$random_number" -eq 0 ]; then
          if [ $(($random_number %2 )) -eq 1 ]; then
          echo -e "${yellowColour}[+]${endColour} ${grayColour}El numero${endColour} ${yellowColour}$random_number${endColour} ${grayColour}es impar, ${endColour}${redColour}PIERDES!${endColour}"
          else
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el${endColour} ${yellowColour}$random_number${endColour} ${grayColour}, ${endColour}${redColour}PIERDES!${endColour}"

          fi
          unset my_sequence[0]
          unset my_sequence[-1] 2>/dev/null
          my_sequence=(${my_sequence[@]})

          echo -e "${yellowColour}[+]${endColour} ${grayColour}La secuencia se nos queda de la siguiente forma${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
          if [ "${#my_sequence[@]}" -gt 1 ]; then

            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi

        fi

      fi
    else
      #Nos quedamos sin dinero
      echo -e "\n${redColour}[!] Te has quedado sin pasta cabron${endColour}\n"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Han habido un total de${endColour} ${yellowColour}$(($play_counter-1))${endColour} ${grayColour}jugadas${endColour}"
      tput cnorm; exit 0
    fi

    let play_counter+=1
  done
  tput cnorm

}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) ;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La tecnica introducida no existe${endColour}"
    helpPanel

  fi
else
  helpPanel

fi

