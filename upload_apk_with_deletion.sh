#!/bin/bash

# Define variables
APK_PATH=build/app/outputs/flutter-apk/app-release.apk
FOLDER_ID="1CK55EUd0suHdmIm_cowoHI4LCzwczQfm"
SERVICE_ACCOUNT_FILE="gcloud-service-key.json"

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    echo "Error: APK file not found at $APK_PATH"
    exit 1
fi

# Debug: Check if the environment variable exists
echo "Checking for GCLOUD_SERVICE_ACCOUNT_JSON variable..."
if [ -z "$GCLOUD_SERVICE_ACCOUNT_JSON" ]; then
    echo "Error: GCLOUD_SERVICE_ACCOUNT_JSON environment variable is not set"
    exit 1
fi

# Write the JSON content to file
printf '%s' "$GCLOUD_SERVICE_ACCOUNT_JSON" > $SERVICE_ACCOUNT_FILE

# Debug: Check the content of the service account file
echo "First 50 characters of service account file:"
head -c 50 $SERVICE_ACCOUNT_FILE
echo # New line

# Get the current date for the APK name
# CURRENT_DATE=$(date +"%Y-%m-%d_%H-%M")
# APK_NAME="app-release_${CURRENT_DATE}.apk"
APK_NAME="gtrack_release.apk"

echo "Uploading APK as $APK_NAME to Google Drive folder $FOLDER_ID..."

# Create JWT signature using Python
JWT_SIGNATURE=$(python3 -c "
import jwt
import sys

try:
    with open('$SERVICE_ACCOUNT_FILE') as f:
        import json
        sa = json.load(f)
    
    header = {'alg': 'RS256', 'typ': 'JWT'}
    payload = {
        'iss': sa['client_email'],
        'scope': 'https://www.googleapis.com/auth/drive',
        'aud': 'https://oauth2.googleapis.com/token',
        'exp': int($(date +%s)) + 3600,
        'iat': int($(date +%s))
    }
    
    token = jwt.encode(payload, sa['private_key'], algorithm='RS256', headers=header)
    print(token)
except Exception as e:
    print(f'Error creating JWT: {str(e)}', file=sys.stderr)
    sys.exit(1)
")

echo "JWT token: $JWT_SIGNATURE"

# Exchange JWT for access token
OAUTH_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=$JWT_SIGNATURE" \
  https://oauth2.googleapis.com/token)

echo "OAuth response: $OAUTH_RESPONSE"

# Extract access token from response
ACCESS_TOKEN=$(echo $OAUTH_RESPONSE | jq -r '.access_token')

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
    echo "Error: Failed to get access token"
    exit 1
fi

echo "Successfully obtained access token"

# Check if file with same name already exists in the folder and delete it
echo "Checking for existing file with name $APK_NAME..."
EXISTING_FILE=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files?q=name='$APK_NAME'+and+'$FOLDER_ID'+in+parents+and+trashed=false")

FILE_ID=$(echo $EXISTING_FILE | jq -r '.files[0].id')

if [ -n "$FILE_ID" ] && [ "$FILE_ID" != "null" ]; then
    echo "Found existing file with ID: $FILE_ID. Deleting..."
    DELETE_RESPONSE=$(curl -s -X DELETE \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      "https://www.googleapis.com/drive/v3/files/$FILE_ID")
    
    if [ -z "$DELETE_RESPONSE" ]; then
        echo "Successfully deleted existing file"
    else
        echo "Error deleting file: $DELETE_RESPONSE"
    fi
else
    echo "No existing file found with the same name"
fi

# First, try to get folder info to check permissions
FOLDER_INFO=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files/$FOLDER_ID?fields=name,id,capabilities")

echo "Folder info: $FOLDER_INFO"

# Try uploading directly to the folder
echo "Attempting to upload directly to folder..."
FOLDER_RESPONSE=$(curl -s -X POST -L \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -F "metadata={name:'$APK_NAME',parents:['$FOLDER_ID']};type=application/json;charset=UTF-8" \
  -F "file=@$APK_PATH;type=application/vnd.android.package-archive" \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart")

echo "Folder upload response: $FOLDER_RESPONSE"

# Check if upload was successful
if [[ $FOLDER_RESPONSE == *"id"* ]]; then
    echo "Upload successful to folder!"
    echo "Response: $FOLDER_RESPONSE"
    
    # Clean up
    rm -f $SERVICE_ACCOUNT_FILE
    exit 0
else
    echo "Upload to folder failed, trying with root My Drive..."
fi

# Try uploading to root of My Drive as fallback
RESPONSE=$(curl -s -X POST -L \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -F "metadata={name:'$APK_NAME'};type=application/json;charset=UTF-8" \
  -F "file=@$APK_PATH;type=application/vnd.android.package-archive" \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart")

# Check if upload was successful
if [[ $RESPONSE == *"id"* ]]; then
    echo "Upload successful to My Drive root!"
    echo "Response: $RESPONSE"
    
    # Clean up
    rm -f $SERVICE_ACCOUNT_FILE
    exit 0
else
    echo "Upload failed!"
    echo "Response: $RESPONSE"
    exit 1
fi