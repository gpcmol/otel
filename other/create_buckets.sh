#!/bin/bash

# Input your credentials and MinIO server details
ACCESS_KEY="enterprise-logs"
SECRET_KEY="supersecret"
MINIO_SERVER="localhost:9000"

# Array of bucket names to create
BUCKET_NAMES=("enterprise-metrics-admin" "mimir-ruler" "mimir-tsdb")

# Generate the current date in RFC 1123 format
DATE=$(date -u +"%a, %d %b %Y %H:%M:%S GMT")

# Function to create a single bucket
create_bucket() {
    local BUCKET_NAME=$1

    # Construct the string to sign
    STRING_TO_SIGN="PUT\n\n\n$DATE\n/$BUCKET_NAME"

    # Generate the signature using HMAC-SHA1
    SIGNATURE=$(echo -en "$STRING_TO_SIGN" | openssl dgst -sha1 -hmac "$SECRET_KEY" -binary | base64)

    # Execute the curl command to create the bucket
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT \
        -H "Authorization: AWS $ACCESS_KEY:$SIGNATURE" \
        -H "Date: $DATE" \
        "http://$MINIO_SERVER/$BUCKET_NAME")

    if [ "$RESPONSE" -eq 200 ]; then
        echo "Bucket '$BUCKET_NAME' created successfully."
    else
        echo "Failed to create bucket '$BUCKET_NAME'. HTTP status: $RESPONSE"
    fi
}

# Loop through all bucket names in the array
for BUCKET_NAME in "${BUCKET_NAMES[@]}"; do
    create_bucket "$BUCKET_NAME"
done
