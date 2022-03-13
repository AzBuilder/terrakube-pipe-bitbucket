# Bitbucket Pipelines Pipe: Terrakube Integration

This pipe is an example to show how easy is to create pipes for Bitbucket Pipelines.

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
script:
  - pipe: azbuilder/terrakube-pipe:1.0.0
    variables:
      LOGIN_ENDPOINT: "<string>" #optional Default: https://login.microsoftonline.com
      TERRAKUBE_TENANT_ID: "<string>"
      TERRAKUBE_APPLICATION_ID: "<string>"
      TERRAKUBE_APPLICATION_SECRET: "<string>"
      TERRAKUBE_APPLICATION_SCOPE: "<string>" #optional Default: api://Terrakube/.default
      TERRAKUBE_ORGANIZATION: "<string>"
      TERRAKUBE_WORKSPACE: "<string>"
      TERRAKUBE_TEMPLATE: "<string>"
      TERRAKUBE_ENDPOINT: "<string>"
      DEBUG: "<boolean>" # Optional Default: false
```
## Variables

| Variable                         | Usage                                              |
| -------------------------------- | -------------------------------------------------- |
| LOGIN_ENDPOINT                   | Default values: https://login.microsoftonline.com  |
| TERRAKUBE_TENANT_ID (*)          | Azure AD Application tenant ID                     |
| TERRAKUBE_APPLICATION_ID (*)     | Azure AD Application tenant ID                     |
| TERRAKUBE_APPLICATION_SECRET (*) | Azure AD Application tenant ID                     |
| TERRAKUBE_APPLICATION_SCOPE      | Default value: api://Terrakube/.default            |
| TERRAKUBE_ORGANIZATION (*)       | Terrakube organization name                        |
| TERRAKUBE_WORKSPACE (*)          | Terrakube workspace name                           |
| TERRAKUBE_TEMPLATE (*)           | Terrakube template name                            |
| TERRAKUBE_ENDPOINT (*)           | Terrakbue api endpoint                             |

_(*) = required variable._

## Prerequisites

## Examples

Basic example:

```yaml
script:
  - pipe: azbuilder/terrakube-pipe:1.0.0
    variables:
      TERRAKUBE_TENANT_ID: "36857254-c824-409f-96f5-d3f2de37b016"
      TERRAKUBE_APPLICATION_ID: "36857254-c824-409f-96f5-d3f2de37b016"
      TERRAKUBE_APPLICATION_SECRET: "SuperSecret"
      TERRAKUBE_ORGANIZATION: "terrakube"
      TERRAKUBE_WORKSPACE: "bitbucket"
      TERRAKUBE_TEMPLATE: "vulnerability-snyk"
      TERRAKUBE_ENDPOINT: "https://terrakube.interal/service"
```

Advanced example:

```yaml
script:
  - pipe: azbuilder/terrakube-pipe:1.0.0
    variables:
      LOGIN_ENDPOINT: "https://login.microsoftonline.com"
      TERRAKUBE_TENANT_ID: "36857254-c824-409f-96f5-d3f2de37b016"
      TERRAKUBE_APPLICATION_ID: "36857254-c824-409f-96f5-d3f2de37b016"
      TERRAKUBE_APPLICATION_SECRET: "SuperSecret"
      TERRAKUBE_APPLICATION_SCOPE: "api://TerrakubeApp/.default"
      TERRAKUBE_ORGANIZATION: "terrakube"
      TERRAKUBE_WORKSPACE: "bitbucket"
      TERRAKUBE_TEMPLATE: "vulnerability-snyk"
      TERRAKUBE_ENDPOINT: "https://terrakube.interal/service"
      DEBUG: "true"
```

## Docker Compose Example

This can be used to test the bitbucket pipeline in your local machine.

Build the image:
```bash
docker build -t terrakube-pipe:latest .
```

Run the bitbucket pipe locally:
```yaml
version: "3.8"
services:
  api-server:
    image: terrakube-pipe:latest
    container_name: terrakube-pipe
    environment:
      - TERRAKUBE_TENANT_ID=XXXXX
      - TERRAKUBE_APPLICATION_ID=XXXX
      - TERRAKUBE_APPLICATION_SECRET=XXXX
      - TERRAKUBE_ORGANIZATION=XXX
      - TERRAKUBE_WORKSPACE=XXX
      - TERRAKUBE_TEMPLATE=XXX
      - TERRAKUBE_ENDPOINT=XXX
      - TERRAKUBE_APPLICATION_SCOPE=XXX
```
## Support
If you’d like help with this pipe, or you have an issue or feature request, let us know.

If you’re reporting an issue, please include:

- the version of the pipe
- relevant logs and error messages
- steps to reproduce
