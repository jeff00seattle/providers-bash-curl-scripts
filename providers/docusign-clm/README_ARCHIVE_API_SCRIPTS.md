# @act/act-archive-docusign-springcm
##### DocuSign SpringCM API: Bash Scripts

**[WORK IN PROGRESS]**

---

![](./doc/images/DocuSign_SpringCM_Logo.png)

---

## MacOS Setup

Setup is required within MacOS environment:
+ Upgrade bash
+ Add command-line utilities

See directions for updating MacOS environment:
[README_BREW_SETUP_MACOS.md](../../README_BREW_SETUP_MACOS.md)

## OAuth 2.0 Authentication

All archive scripts requires valid `access_token`, which requires refreshing every 3600 seconds. 
This is acquired through OAuth 2.0 Authentication Service.

See directions for getting OAuth 2.0 Access Token:
[README_ARCHIVE_OAUTH2_SCRIPTS.md](README_ARCHIVE_OAUTH2_SCRIPTS.md)

## DocuSign SpringCM API

**[TODO]**

## DocuSign SpringCM: Bash Scripts

The following bash scripts makes curl call to DocuSign SpringCM API and all expect a valid `[** DOCUSIGN_ACCESS_TOKEN **]`:

```bash
$ tree scripts/archive --dirsfirst -FL 1 | grep -v /$

scripts/archive
├── apiuser_access_token.sh
├── create_folder.sh
├── delete_file_by_id.sh
├── delete_folder_by_id.sh
├── get_file_by_id.sh
├── get_folder_by_id.sh
├── get_folder_by_name.sh
├── get_root_folder.sh
├── list_all.sh
├── list_files.sh
├── list_folders.sh
├── list_folders_by_name.sh
├── list_objects.sh
└── upload_file.sh
```

### OAuth 2.0

To use these bash scripts requires a valid `[** DOCUSIGN_ACCESS_TOKEN **]`. This can be
acquired using the OAuth 2.0 bash scripts defined in `scripts/oauth2` by following these instructions:

[README_ARCHIVE_OAUTH2_SCRIPTS](README_ARCHIVE_OAUTH2_SCRIPTS.md)

### DocuSign SpringCM UAT Account

| Key            | Value                               |
|:---------------|------------------------------------:|
| Site           | https://loginuat.springcm.com/Login |
| Login          | jeffrey.tanner@docusign.com         |
| Account Name   | Jeffrey_Tanner_DS                   |

## Request Client ID and Client Secret

For all forms of authentication a **CLIENT SECRET** and **CLIENT ID** must be 
provisioned from DocuSign SpringCM.  This is done currently by emailing **support@springcm.com**.  

Separate keys must be issued if you are working in the UAT and Production environments, 
as keys cannot be shared across these environments.  When requesting your 
keys please include the following information:

  * Application Name
  * Application Contact Email Address
  * DocuSign SpringCM Environment – Production or UAT
  * Callback URL – For use if using OAuth 2.0 Web Server Flow.  The callback URL must be registered at the time of provisioning your keys and will be associated with the provisioned Client Id.

#### Email Response

Email response will return a link to generate:

  * **CLIENT ID**
  * **CLIENT SECRET**
  
#### `credentials.json`

```json
{
  "client_id": "[** CLIENT ID **]",
  "client_secret": "[** CLIENT SECRET **]",
  "redirect_uri": "http://localhost:4500/auth/springcm/callback",
  "authorization_url": "https://loginuat.springcm.com/oauth/authorize",
  "token_url": "https://authuat.springcm.com/api/v201606/token",
  "api_base_url": "https://apiuatna11.springcm.com"
}
```
  
### Example DocuSign SpringCM `Client_ID` and `Client_Secret`

```text
Application Name:                   DocuSign SpringCM API
Application Contact Email Address:  jeffrey.tanner@docusign.com
DocuSign SpringCM Environment:               UAT
```

## DocuSign SpringCM API Set

https://developer.springcm.com/guides/oauth-20-web-server-flow

## Get `authorization_code`

```bash
$ cd scripts
$ ./springcm_api_oauth2_code.sh

CLIENT_ID=[** CLIENT ID **]
CLIENT_SECRET=[** CLIENT SECRET **]
AUTH_URL=https://loginuat.springcm.com/oauth/authorize
Open: https://loginuat.springcm.com/oauth/authorize?client_id=[** CLIENT ID **]&response_type=code
```

#### Login

![SpringCM_Login](../doc/images/SpringCM_Login.png)

#### Consent

![SpringCM_Login_Consent](../doc/images/SpringCM_Login_Consent.png)

#### Code

![SpringCM_Login_Auth_Code](../doc/images/SpringCM_Login_Auth_Code.png)

```text
http://localhost:4501/api/v1/auth/callback?
code=[** AUTHENTICATION CODE **]
&state=
```

#### Add `authorization_code` to `credentials.code.json`

```json
{
  "code": "[** AUTHENTICATION CODE **]"
}
```

### Get Auth Token

```bash
$ ./springcm_api_oauth2_token.sh

CLIENT_ID=[** CLIENT ID **]
CLIENT_SECRET=[** CLIENT SECRET **]

AUTH_URL=https://loginuat.springcm.com/oauth/authorize
AUTH_TOKEN_URL=https://authuat.springcm.com/api/v201606/token
CODE=[** AUTHENTICATION CODE **]
```

#### Add Auth Token JSON to `credentials.token.json`

```json
{
  "access_token": "[** ACCESS TOKEN **]",
  "token_type": "bearer",
  "expires_in": 3598,
  "refresh_token": "[** REFRESH TOKEN **]",
  "api_base_url": "https://apiuatna11.springcm.com"
}
```

### Get User Profile

```bash
$ ./springcm_api_user_current.sh

DOCUSIGN_ACCESS_TOKEN=[** ACCESS TOKEN **]
EXPIRES_IN=3598
DOCUSIGN_REFRESH_TOKEN=[** REFRESH TOKEN **]
TOKEN_TYPE=bearer
API_BASE_URL=https://apiuatna11.springcm.com
CURL_CMD=curl "https://apiuatna11.springcm.com/v201411/accounts/current" --header "Authorization: bearer [** ACCESS TOKEN **]" --header "Accept: application/json" --request GET --verbose --connect-timeout 60
```

```json
{
  "Id": "9668",
  "Name": "Jeffrey_Tanner_DS",
  "Type": "Enterprise",
  "DefaultCulture": "UseClient",
  "DefaultTimeZone": "(UTC-06:00) Central Time (US & Canada)",
  "AttributeGroups": {
    "Href": "https://apiuatna11.springcm.com/v201411/accounts/current/attributegroups"
  },
  "BrandingUrl": "https://uatna11.springcm.com/atlas/ThemeCss?aid=9668&v=_1",
  "Href": "https://apiuatna11.springcm.com/v201411/accounts/current"
}
```

### GET System Root's Attribute Groups

```bash
curl -X GET \
  'https://apiuatna11.springcm.com/v201411/folders?systemfolder=root&expand=attributegroups' \
  -H 'Authorization: Bearer [** ACCESS TOKEN **]' \
  -H 'cache-control: no-cache'
```

```json
{
    "Name": "Jeffrey_Tanner_DS",
    "CreatedDate": "2018-07-31T23:33:44.797Z",
    "CreatedBy": "support@springcm.com",
    "UpdatedDate": "2018-07-31T23:33:44.797Z",
    "UpdatedBy": "support@springcm.com",
    "Description": "",
    "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/a3fbae26-1a95-e811-9c16-3ca82a1e3f41",
    "AccessLevel": {
        "See": true,
        "Read": true,
        "Write": true,
        "Move": true,
        "Create": true,
        "SetAccess": true
    },
    "Documents": {
        "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/documents"
    },
    "Folders": {
        "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/folders"
    },
    "ShareLinks": {
        "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/sharelinks"
    },
    "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/documents{?name}",
    "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
}
```

### GET System Root's Folders

```bash
curl -X GET \
  'https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/folders' \
  -H 'Authorization: Bearer [** ACCESS TOKEN **]' \
  -H 'cache-control: no-cache'
```

```json
{
    "Items": [
        {
            "Name": "Trash",
            "CreatedDate": "2018-07-31T23:33:44.813Z",
            "CreatedBy": "support@springcm.com",
            "UpdatedDate": "2018-07-31T23:33:44.813Z",
            "UpdatedBy": "support@springcm.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/a6fbae26-1a95-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a6fbae26-1a95-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a6fbae26-1a95-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a6fbae26-1a95-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/a6fbae26-1a95-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/a6fbae26-1a95-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "Users",
            "CreatedDate": "2018-07-31T23:33:44.877Z",
            "CreatedBy": "support@springcm.com",
            "UpdatedDate": "2018-07-31T23:33:44.877Z",
            "UpdatedBy": "support@springcm.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/abfbae26-1a95-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/abfbae26-1a95-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/abfbae26-1a95-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/abfbae26-1a95-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/abfbae26-1a95-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/abfbae26-1a95-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "Other Sources",
            "CreatedDate": "2018-07-31T23:33:44.983Z",
            "CreatedBy": "support@springcm.com",
            "UpdatedDate": "2018-07-31T23:33:44.983Z",
            "UpdatedBy": "support@springcm.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/affbae26-1a95-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/affbae26-1a95-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/affbae26-1a95-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/affbae26-1a95-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/affbae26-1a95-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/affbae26-1a95-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "Shared",
            "CreatedDate": "2018-08-02T18:35:28.977Z",
            "CreatedBy": "ahmed.kamel@docusign.com",
            "UpdatedDate": "2018-08-02T18:35:29.07Z",
            "UpdatedBy": "ahmed.kamel@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/ad109bcf-8296-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/ad109bcf-8296-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/ad109bcf-8296-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/ad109bcf-8296-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/ad109bcf-8296-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/ad109bcf-8296-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "_Sales Contracts",
            "CreatedDate": "2018-09-07T20:28:04.347Z",
            "CreatedBy": "jeffrey.tanner@docusign.com",
            "UpdatedDate": "2018-09-07T20:45:38.71Z",
            "UpdatedBy": "jeffrey.tanner@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/e4804185-dcb2-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/e4804185-dcb2-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/e4804185-dcb2-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/e4804185-dcb2-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/e4804185-dcb2-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/e4804185-dcb2-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "Public Folder",
            "CreatedDate": "2018-09-07T20:39:46.293Z",
            "CreatedBy": "jeffrey.tanner@docusign.com",
            "UpdatedDate": "2018-09-07T20:39:46.293Z",
            "UpdatedBy": "jeffrey.tanner@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/8cdcdc22-deb2-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/8cdcdc22-deb2-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/8cdcdc22-deb2-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/8cdcdc22-deb2-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/8cdcdc22-deb2-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/8cdcdc22-deb2-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "_Admin",
            "CreatedDate": "2018-09-07T20:43:24.407Z",
            "CreatedBy": "jeffrey.tanner@docusign.com",
            "UpdatedDate": "2018-09-07T20:43:24.407Z",
            "UpdatedBy": "jeffrey.tanner@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/903e36a5-deb2-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/903e36a5-deb2-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/903e36a5-deb2-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/903e36a5-deb2-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/903e36a5-deb2-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/903e36a5-deb2-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "_Doc Launcher",
            "CreatedDate": "2018-09-07T20:43:53.71Z",
            "CreatedBy": "jeffrey.tanner@docusign.com",
            "UpdatedDate": "2018-09-07T20:43:53.71Z",
            "UpdatedBy": "jeffrey.tanner@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/c0ff25bb-deb2-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/c0ff25bb-deb2-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/c0ff25bb-deb2-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/c0ff25bb-deb2-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/c0ff25bb-deb2-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/c0ff25bb-deb2-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "SpringCM Training Documents",
            "CreatedDate": "2018-09-07T20:52:29.343Z",
            "CreatedBy": "jeffrey.tanner@docusign.com",
            "UpdatedDate": "2018-09-07T20:52:29.343Z",
            "UpdatedBy": "jeffrey.tanner@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/3948c3e8-dfb2-e811-9c16-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/3948c3e8-dfb2-e811-9c16-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/3948c3e8-dfb2-e811-9c16-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/3948c3e8-dfb2-e811-9c16-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/3948c3e8-dfb2-e811-9c16-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/3948c3e8-dfb2-e811-9c16-3ca82a1e3f41"
        },
        {
            "Name": "Workflow",
            "CreatedDate": "2018-10-24T00:02:30.19Z",
            "CreatedBy": "jeffrey.tanner@docusign.com",
            "UpdatedDate": "2018-10-24T00:02:30.283Z",
            "UpdatedBy": "jeffrey.tanner@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/d84d8d16-20d7-e811-9c19-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/d84d8d16-20d7-e811-9c19-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/d84d8d16-20d7-e811-9c19-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/d84d8d16-20d7-e811-9c19-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/d84d8d16-20d7-e811-9c19-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/d84d8d16-20d7-e811-9c19-3ca82a1e3f41"
        },
        {
            "Name": "Process Automation Training - 3 Days",
            "CreatedDate": "2018-10-24T18:33:22.463Z",
            "CreatedBy": "jeffrey.tanner@docusign.com",
            "UpdatedDate": "2018-10-24T18:33:22.463Z",
            "UpdatedBy": "jeffrey.tanner@docusign.com",
            "Description": "",
            "ParentFolder": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41"
            },
            "BrowseDocumentsUrl": "https://uatna11.springcm.com/atlas/Link/Folder/9668/b5d95843-bbd7-e811-9c19-3ca82a1e3f41",
            "AccessLevel": {
                "See": true,
                "Read": true,
                "Write": true,
                "Move": true,
                "Create": true,
                "SetAccess": true
            },
            "Documents": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/b5d95843-bbd7-e811-9c19-3ca82a1e3f41/documents"
            },
            "Folders": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/b5d95843-bbd7-e811-9c19-3ca82a1e3f41/folders"
            },
            "ShareLinks": {
                "Href": "https://apiuatna11.springcm.com/v201411/folders/b5d95843-bbd7-e811-9c19-3ca82a1e3f41/sharelinks"
            },
            "CreateDocumentHref": "https://apiuploaduatna11.springcm.com/v201411/folders/b5d95843-bbd7-e811-9c19-3ca82a1e3f41/documents{?name}",
            "Href": "https://apiuatna11.springcm.com/v201411/folders/b5d95843-bbd7-e811-9c19-3ca82a1e3f41"
        }
    ],
    "Href": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/folders",
    "Offset": 0,
    "Limit": 20,
    "First": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/folders",
    "Last": "https://apiuatna11.springcm.com/v201411/folders/a3fbae26-1a95-e811-9c16-3ca82a1e3f41/folders",
    "Total": 11
}
```



