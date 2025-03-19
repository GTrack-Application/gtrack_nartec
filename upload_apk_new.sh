#!/bin/bash

# Define variables
APK_PATH=build/app/outputs/flutter-apk/app-release.apk
FOLDER_ID="1CK55EUd0suHdmIm_cowoHI4LCzwczQfm"
SERVICE_ACCOUNT_FILE="gcloud-service-key.json"
APK_NAME="gtrack_release.apk"

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    echo "Error: APK file not found"
    exit 1
fi

# Write service account JSON to file
printf '%s' "$GCLOUD_SERVICE_ACCOUNT_JSON" > $SERVICE_ACCOUNT_FILE

# Get current time
CURRENT_TIME=$(date +%s)
EXPIRY_TIME=$((CURRENT_TIME + 3600))

# Extract credentials
CLIENT_EMAIL=$(jq -r '.client_email' $SERVICE_ACCOUNT_FILE)
PRIVATE_KEY=$(jq -r '.private_key' $SERVICE_ACCOUNT_FILE)

# Create JWT
JWT_HEADER='{"alg":"RS256","typ":"JWT"}'
JWT_HEADER_BASE64=$(echo -n "$JWT_HEADER" | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
JWT_PAYLOAD="{\"iss\":\"$CLIENT_EMAIL\",\"scope\":\"https://www.googleapis.com/auth/drive\",\"aud\":\"https://oauth2.googleapis.com/token\",\"exp\":$EXPIRY_TIME,\"iat\":$CURRENT_TIME}"
JWT_PAYLOAD_BASE64=$(echo -n "$JWT_PAYLOAD" | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
JWT_UNSIGNED="$JWT_HEADER_BASE64.$JWT_PAYLOAD_BASE64"
echo "$PRIVATE_KEY" > private_key.pem
JWT_SIGNATURE=$(echo -n "$JWT_UNSIGNED" | openssl dgst -binary -sha256 -sign private_key.pem | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
rm private_key.pem
JWT_TOKEN="$JWT_UNSIGNED.$JWT_SIGNATURE"

# Get access token
OAUTH_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=$JWT_TOKEN" \
  https://oauth2.googleapis.com/token)
ACCESS_TOKEN=$(echo $OAUTH_RESPONSE | jq -r '.access_token')

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
    echo "Error: Failed to get access token"
    exit 1
fi

# Delete existing file if present
EXISTING_FILE=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files?q=name='$APK_NAME'+and+'$FOLDER_ID'+in+parents+and+trashed=false")
FILE_ID=$(echo $EXISTING_FILE | jq -r '.files[0].id')
if [ -n "$FILE_ID" ] && [ "$FILE_ID" != "null" ]; then
    curl -s -X DELETE -H "Authorization: Bearer $ACCESS_TOKEN" \
      "https://www.googleapis.com/drive/v3/files/$FILE_ID" > /dev/null
fi

# Upload APK
UPLOAD_RESPONSE=$(curl -s -X POST -L \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -F "metadata={name:'$APK_NAME',parents:['$FOLDER_ID']};type=application/json;charset=UTF-8" \
  -F "file=@$APK_PATH;type=application/vnd.android.package-archive" \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart")

# Clean up
rm -f $SERVICE_ACCOUNT_FILE

# Check upload status
if [[ $UPLOAD_RESPONSE == *"id"* ]]; then
    echo "Upload successful"
    exit 0
else
    echo "Upload failed"
    exit 1
fi