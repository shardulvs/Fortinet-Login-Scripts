
#!/bin/bash

extract_magic() {
    echo "$1" | grep -oP '(?<=fgtauth\?)[a-f0-9]+'
}

initial_response=$(curl -i "https://webmail.iitj.ac.in" 2>/dev/null)

MAGIC=$(extract_magic "$initial_response")

if [ -z "$MAGIC" ]; then
    echo "Failed to extract magic number. Exiting."
    exit 1
fi

echo "Magic number: $MAGIC"

curl -i "https://gateway.iitj.ac.in:1003/fgtauth?$MAGIC" >/dev/null 2>&1

# IMPORTANT
# Replace USERNAME and PASSWORD in the line below
# with your actual username and password

login_response=$(curl -i 'https://gateway.iitj.ac.in:1003/' --data-raw "magic=$MAGIC&username=USERNAME&password=PASSWORD" 2>/dev/null)

if echo "$login_response" | grep -q "200 OK"; then
    echo "Login successful!"
else
    echo "Login failed. Please check your credentials or try again later."
fi
