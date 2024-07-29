# Define the URL for the Proxmox API endpoint, replacing "0.0.0.0" with your actual Proxmox IP address
proxmox_api_url = "https://0.0.0.0:8006/api2/json"

# Specify the API Token ID used for authentication with the Proxmox API
# Format: <username>@<realm>!<token name>
proxmox_api_token_id = "terraform@pam!terraform"

# Provide the secret key associated with the API Token ID for secure access
proxmox_api_token_secret = "your-api-token-secret"
