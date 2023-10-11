source ./configuration.sh

# Colors
c_green=$(tput setaf 2)
c_yellow=$(tput setaf 3)
c_red=$(tput setaf 1)
c_magenta=$(tput setaf 5)
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
  echo -e "${c_green}👍 $1${c_reset}"
}

function error() {
  echo -e "${c_red}🚨 $1${c_reset}"
}

function info() {
  echo -e "${c_magenta}ℹ️  $1${c_reset}"
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
      [Nn] ) echo ""; error "Operation cancelled as requested!"; exit;;
      *    ) echo ""; echo "Please answer either yes (y/Y) or no (n/N).";;
    esac
  done
  echo ""
}

function packagedone() {
  echo "🧁 $1"
}

function helptext() {
  echo "${c_dim}    $1${c_reset}"
}

# 1 - package
# 2 - version
function updateVersion() {

  makeSureDotfileVersionFileExist

  source $DVCFG

  clearVersion

  #
  # TODO This code below could be refactor
  #
  for i in packages/*; do
    if test -f "${i%/}/init.sh"; then
      packageName=$(basename $i)
      if [[ $packageName == $1 ]]; then
        writeVersion $1 $2
      else
        packageCurrentVersion="${!packageName}"
        writeVersion $packageName $packageCurrentVersion 
      fi
    fi
  done
}

function clearVersion() {
  rm -rf $DVCFG
}

function writeVersion() {
  makeSureDotfileVersionFileExist
  echo "$1=$2" >> $DVCFG
}

function syncVersions() {
  clearVersion
  for i in packages/*; do
    if test -f "${i%/}/init.sh"; then
      packageName=$(basename $i)
      packageDotfileVersion="$(bash "${i%/}/init.sh" --version)"
      writeVersion $packageName $packageDotfileVersion
    fi
  done
}

function makeSureDotfileVersionFileExist() {
  if ! fileExist $DVCFG; then
    touch $DVCFG
  fi
}

function compareFile() {
    echo " "
    echo "🤙 Comparing $1 to $2 "
    echo " "
    diff -y --ignore-blank-lines --width 150 --color $1 $2
}
