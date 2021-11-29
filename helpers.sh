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

function isMacOS() {
  if [[ $OSTYPE == 'darwin'* ]]; then
    return 1
  fi
  return 0
}

function checked() {
  echo "✅ $1"
}

function missing() {
  echo "❌ $1"
}

function skip() {
  echo "🥸  $1"
}

function warn() {
  echo "⚠️  $1"
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
  echo "    $1"
}
