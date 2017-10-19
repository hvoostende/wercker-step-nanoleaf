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
json="{
    \"project\": \"$WERCKER_NANOLEAF_NOTIFIER_PROJECT\",
    \"color\":\"$WERCKER_NANOLEAF_NOTIFIER_COLOR\"
}"

# post the result to the nanoleaf webhook
RESULT=$(curl -d "$json" -s "$WERCKER_NANOLEAF_NOTIFIER_URL" --output "$WERCKER_STEP_TEMP"/result.txt -w "%{http_code}")
cat "$WERCKER_STEP_TEMP/result.txt"
echo $RESULT