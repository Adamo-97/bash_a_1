#!/usr/bin/env bash
set -euo pipefail

# --- 1) Declare & populate a map ---
declare -A capitals=()
capitals[se]="Stockholm"
capitals[us]="Washington, DC"
capitals[fr]="Paris"

# Access by key
echo "Capital of SE: ${capitals[se]}"

# Number of entries
echo "Size: ${#capitals[@]}"

# List all keys
echo "Keys: ${!capitals[@]}"

# List all values
echo "Values: ${capitals[@]}"

# Iterate (note: associative arrays are unordered)
echo "All entries:"
for k in "${!capitals[@]}"; do
  printf "  %s => %s\n" "$k" "${capitals[$k]}"
done

# Existence test (Bash-specific [[ -v ... ]])
if [[ -v 'capitals[uk]' ]]; then
  echo "UK exists"
else
  echo "UK missing"
fi

# Update & delete
capitals[us]="DC"         # update
unset 'capitals[fr]'      # delete
echo "After changes: ${!capitals[@]}"

# --- 2) Small “lookup table” example (like a switch) ---
declare -A mime_by_ext=(
  [png]="image/png"
  [jpg]="image/jpeg"
  [json]="application/json"
)
ext="json"
echo "MIME for .$ext: ${mime_by_ext[$ext]:-application/octet-stream}"  # default if missing

# --- 3) Reading key=value lines into a map ---
# (Example source; replace with your file)
conf_data=$'host=localhost\nport=5432\ndebug=true'
declare -A conf=()
while IFS='=' read -r k v; do
  [[ -n ${k:-} ]] && conf["$k"]="$v"
done <<< "$conf_data"
echo "Config host: ${conf[host]}  port: ${conf[port]}  debug: ${conf[debug]}"

# --- 4) Pass a map to a function via nameref ---
fill_defaults() {
  # $1 is the variable name of the assoc array; use a nameref to modify it in place
  local -n m="$1"
  : "${m[retries]:=3}"
  : "${m[timeout_ms]:=2000}"
}
declare -A opts=([timeout_ms]=500)
fill_defaults opts
echo "Opts => retries=${opts[retries]} timeout_ms=${opts[timeout_ms]}"

# --- 5) “Composite keys” trick (since nested maps aren't native) ---
declare -A users=()
users["1:name"]="Ada"
users["1:role"]="admin"
users["2:name"]="Linus"
users["2:role"]="dev"
echo "User 2 role: ${users["2:role"]}"
