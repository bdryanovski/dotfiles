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



function checked() {
  echo "✅ $1"
}

function missing() {
  echo "❌ $1"
}

function infod() {
  echo "   "
  echo "+👇 Info ----------+"
  echo "| $1"
  echo "+------------------------------+"
  echo "  "
}

function warnd() {
  echo "WARN: $1"
}

function errd() {
  echo "ERR: $1"
}

function packagedone() {
  echo "🧁 $1"
}

function helpblock() {
  echo "  "
  echo "🥸  !! Help ------------+"
}

function helpline() {
  echo "| $1"
}

function helpend() {
  echo "+------------------------------+"
}
