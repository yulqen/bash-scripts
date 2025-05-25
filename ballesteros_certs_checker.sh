#!/bin/sh

# Configuration
SERVER="ballesteros" # Replace with your server's address or hostname
USER="lemon"                # Your user with sudo access on the server
# End Configuration

echo "Connecting to $USER@$SERVER to check certificate status..."

# Execute certbot command remotely and capture output and errors
REMOTE_CMD="sudo certbot certificates"
# Store output in a variable first
SSH_OUTPUT=$(ssh "$USER@$SERVER" "$REMOTE_CMD" 2>&1)
SSH_STATUS=$?

# Check if the SSH command was successful
if [ $SSH_STATUS -ne 0 ]; then
    echo "Error: Could not connect to server or run '$REMOTE_CMD'."
    echo "SSH Error output:"
    echo "$SSH_OUTPUT"
    exit 1
fi

echo "Certificate Status on $SERVER:"
echo "----------------------------------------"

# Use a temporary file to process output line by line in the main shell
tmp_cert_info=$(mktemp)
# Check if mktemp succeeded
if [ ! -f "$tmp_cert_info" ]; then
    echo "Error: Could not create temporary file."
    exit 1
fi
echo "$SSH_OUTPUT" > "$tmp_cert_info"

expired_certs=""
current_cert_name=""

# Read from the temporary file and process in the main shell process
# This ensures that variable updates (like expired_certs) persist
while IFS= read -r line; do
    # Look for lines starting with "Certificate Name:" to identify a new certificate block
    if echo "$line" | grep -q "Certificate Name:"; then
        # If we finished processing a previous certificate, print a separator
        if [ -n "$current_cert_name" ]; then
            echo ""
        fi
        # Extract the certificate name
        current_cert_name=$(echo "$line" | sed 's/.*Certificate Name: *//')
        echo "Certificate: $current_cert_name"
    # If we are inside a certificate block (current_cert_name is not empty)
    elif [ -n "$current_cert_name" ]; then
        # Look for Domains line
        if echo "$line" | grep -q "Domains:"; then
            domains=$(echo "$line" | sed 's/.*Domains: *//')
            echo "  Domains: $domains"
        # Look for Expiry Date line
        elif echo "$line" | grep -q "Expiry Date:"; then
            expiry_info=$(echo "$line" | sed 's/.*Expiry Date: *//')
            # Check if the expiry information contains "INVALID:", indicating expiration
            if echo "$expiry_info" | grep -q "INVALID:"; then
                echo "  Status: EXPIRED!"
                # Add the expired certificate name to our list (this variable is in the main shell)
                expired_certs="$expired_certs $current_cert_name"
            else
                echo "  Status: Valid (Expires $expiry_info)"
            fi
            # We've processed the expiry for this cert, reset for the next block
            current_cert_name=""
        fi
    fi
done < "$tmp_cert_info" # Redirect input from the temp file

# Clean up the temporary file
rm "$tmp_cert_info"

# Add a final blank line if the last certificate block was processed
if [ -n "$current_cert_name" ]; then
     echo ""
fi

echo "----------------------------------------"

# Now, $expired_certs contains the space-separated list of expired cert names
# Check if any certificates were found expired
if [ -n "$expired_certs" ]; then
    echo "ACTION REQUIRED: The following certificates are expired:"
    # Print each expired certificate name on a new line
    echo "$expired_certs" | tr ' ' '\n' | sed '/^$/d' | while IFS= read -r cert; do
        echo " - $cert"
    done
    echo "" # Blank line for spacing

    # Offer to renew the certificates
    read -r -p "Do you want to attempt to renew them now using 'sudo certbot renew' with Nginx stop/start hooks? (y/N) " response
    case "$response" in
        [yY]|[yY][eE][sS])
            echo "Attempting renewal on $SERVER..."
            # --- MODIFIED RENEWAL COMMAND ---
            # Include pre-hook to stop Nginx and post-hook to start Nginx
            # Single quotes around the hook commands are important!
            RENEW_CMD="sudo certbot renew --pre-hook 'systemctl stop nginx' --post-hook 'systemctl start nginx'"

            echo "Running command: ssh -t \"$USER@$SERVER\" \"$RENEW_CMD\"" # Show the command being executed

            # Use ssh -t for interactive output from certbot/sudo
            ssh -t "$USER@$SERVER" "$RENEW_CMD"
            RENEW_STATUS=$?
            if [ $RENEW_STATUS -eq 0 ]; then
                echo "Renewal attempt completed on $SERVER."
                echo "Certbot should have stopped Nginx before renewal and started it afterwards."
                echo "Please review the output above from 'sudo certbot renew' for specific outcomes for each certificate."
                echo "It is highly recommended to run this script again now to re-check the certificate statuses."
            else
                echo "Renewal command exited with status $RENEW_STATUS."
                echo "Please check the output above for any errors from 'sudo certbot renew' (especially regarding stopping/starting nginx)."
            fi
            ;;
        *)
            echo "Renewal skipped by user."
            ;;
    esac
else
    echo "All certificates reported by certbot are currently valid."
fi

exit 0
