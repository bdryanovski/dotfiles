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
