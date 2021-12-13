
# Colors
c_green=$(tput setaf 2)
c_yellow=$(tput setaf 3)
c_red=$(tput setaf 1)
c_reset=$(tput sgr0)
c_dim=$(tput setaf 5)

# Check if command is installed 
function commandExist() {
  if ! test -x "$(command -v $1)"; then
    return 1
  fi
  return 0 
}

function fileExist() {
  if ! test -f $1; then 
    return 1 
  fi 
  return 0 
}

function directoryExist() {
  if ! test -d $1; then
    return 1
  fi
  return 0
}

function isMacOS() {
  if [[ $OSTYPE == 'darwin'* ]]; then
    return 1
  fi
  return 0
}

function checked() {
  echo -e "${c_green}✅ $1${c_reset}"
}

function missing() {
  echo -e "${c_red}❌ $1${c_reset}"
}

function skip() {
  echo -e "${c_yellow}👋  $1${c_reset}"
}

function warn() {
  echo -e "${c_yellow}⚠️  $1${c_reset}"
}

function askQuestion {
  local msg=${1}
  local waitingforanswer=true
  while ${waitingforanswer}; do
    read -p "${msg} (hit 'y/Y' to continue, 'n/N' to cancel) " -n 1 ynanswer
    case ${ynanswer} in
      [Yy] ) waitingforanswer=false; break;;
      [Nn] ) echo ""; missing "Operation cancelled as requested!"; exit;;
      *    ) echo ""; echo "Please answer either yes (y/Y) or no (n/N).";;
    esac
  done
  echo ""
}

function infod() {
  echo "   "
  echo "  🤌  $1"
  echo "  "
}

function packagedone() {
  echo "🧁 $1"
}

function helptext() {
  echo "${c_dim}    $1${c_reset}"
}
