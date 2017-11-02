#!/bin/bash
#source build-esen.sh

# check if slack webhook url is present
if [ -z "$WERCKER_NANOLEAF_NOTIFIER_URL" ]; then
  fail "Please provide a Nanoleaf URL"
fi

export COLOR="Passed"

if [ -z "$WERCKER_RESULT" ]; then
  echo "WERCKER RESULT: PASSED"
  export COLOR="Deploying"
fi

if [ "$WERCKER_RESULT" = "failed" ]; then
  echo "WERCKER RESULT: FAILED"
  export COLOR="Failed"
fi

# construct the json
json="{
    \"project\": \"$WERCKER_NANOLEAF_NOTIFIER_PROJECT\",
    \"color\": \"$COLOR\"
}"

echo "Post the result to the nanoleaf webhook"
curl -d "$json" "$WERCKER_NANOLEAF_NOTIFIER_URL" -H "Content-Type: application/json" -v