#!/bin/bash
#source build-esen.sh

# check if slack webhook url is present
if [ -z "$WERCKER_NANOLEAF_NOTIFIER_URL" ]; then
  fail "Please provide a Nanoleaf URL"
fi

export COLOR="passed"

if [ -z "$WERCKER_RESULT" ]; then
  export COLOR="deploying"
fi

if [ "$WERCKER_RESULT" = "failed" ]; then
  export COLOR="failed"
fi

# construct the json
json="{\"project\":\"$WERCKER_NANOLEAF_NOTIFIER_PROJECT\",\"color\":\"$COLOR\"}"

# post the result to the nanoleaf webhook
RESULT=$(curl -d "$json" -s "$WERCKER_NANOLEAF_NOTIFIER_URL" -H "Content-Type: application/json" --output "$WERCKER_STEP_TEMP"/result.txt -w "%{http_code}")
cat "$WERCKER_STEP_TEMP/result.txt"

if [ "$RESULT" = "500" ]; then
  if grep -Fqx "No token" "$WERCKER_STEP_TEMP/result.txt"; then
    fail "No token is specified."
  fi

  if grep -Fqx "No hooks" "$WERCKER_STEP_TEMP/result.txt"; then
    fail "No hook can be found for specified subdomain/token"
  fi

  if grep -Fqx "Invalid channel specified" "$WERCKER_STEP_TEMP/result.txt"; then
    fail "Could not find specified channel for subdomain/token."
  fi

  if grep -Fqx "No text specified" "$WERCKER_STEP_TEMP/result.txt"; then
    fail "No text specified."
  fi
fi

if [ "$RESULT" = "404" ]; then
  fail "Subdomain or token not found."
fi