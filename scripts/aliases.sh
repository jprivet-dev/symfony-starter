# Usage:
#   . scripts/alias.sh [options]

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G="\033[32m"
R="\033[31m"
Y="\033[33m"
S="\033[0m"

function aliases_create() {
  local name="${1}"
  alias ${name}="aliases_make ${name}" &&
    printf " ${G}✔${S} Create ${G}${name}${S} alias for ${G}make ${name}${S}\n"
}

function aliases_delete() {
  local name="${1}"
  unalias ${name} &&
    printf " ${R}⨯${S} Delete ${G}${name}${S} alias for ${G}make ${name}${S}\n"
}

function aliases_make() {
  local name="${1}"
  shift
  make ${name} p="${*}"
}

function aliases_help() {
  printf "\n"
  printf "${Y}Description:${S}\n"
  printf "  Create or delete alias for make commands\n"
  printf "\n"
  printf "${Y}Usage:${S}\n"
  printf "  . aliases [options]\n"
  printf "\n"
  printf "${Y}Options:${S}\n"
  printf "  ${G}--help, -h    ${S}Show help\n"
  printf "  ${G}--delete, -d  ${S}Delete all aliases\n"
  printf "\n"
  printf "${Y}Help:${S}\n"
  printf "  Create all aliases:\n"
  printf "\n"
  printf "    ${G}. aliases${S}\n"
  printf "\n"
  printf "  Delete all aliases:\n"
  printf "\n"
  printf "    ${G}. aliases --delete${S}\n"
  printf "\n"
}

function aliases_title() {
  printf "\n${Y}Aliases${S}"
  printf "\n${Y}-------${S}\n\n"
}

function aliases_info() {
  printf "\n"
  printf "Run ${G}. aliases -d${S} to delete all aliases.\n"
  printf "Run ${G}. aliases -h${S} to show help.\n"
  printf "\n"
}

function aliases_create_all() {
  aliases_title
  aliases_create symfony
  aliases_create sf
  aliases_create composer
  aliases_create php
  aliases_info
}

function aliases_delete_all() {
  aliases_title
  aliases_delete symfony
  aliases_delete sf
  aliases_delete composer
  aliases_delete php
  aliases_info
}

case ${1} in
-h | --help)
  aliases_help
  ;;
-d | --delete)
  aliases_delete_all
  ;;
*)
  aliases_create_all
  ;;
esac
