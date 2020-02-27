# SSH Credential Harvester

SSH Credential Harvester is a penetration testing and red teaming tool automates the setup of an SSH server that logs usernames and passwords.

## Installation

Clone the GitHub repository
```
git clone https://github.com/centralinfosec/SSH-Credential-Harvester /opt/Central-InfoSec/SSH-Credential-Harvester
```

## Usage

Run the following commands to install:
```
chmod +x /opt/Central-InfoSec/SSH-Credential-Harvester/installSshCredentialHarvester.sh
/opt/Central-InfoSec/SSH-Credential-Harvester/installSshCredentialHarvester.sh
```

## Viewing SSH Credentials

Run the following commands to view any logged SSH credentials:
```
chmod +x /opt/Central-InfoSec/SSH-Credential-Harvester/getCredentialsFromSshLogs.sh
/opt/Central-InfoSec/SSH-Credential-Harvester/getCredentialsFromSshLogs.sh
```

## Example Screenshot of Output from "getCredentialsFromSshLogs.sh"

![ExampleOutput-getCredentialsFromSshLogs](screenshot.png?raw=true "ExampleOutput-getCredentialsFromSshLogs")
