# @act/act-archive-microsoft-onedrive
##### Microsoft OneDrive: OAuth 2.0 Scripts

---

![](./doc/images/OneDrive_logo.png)

---

## MacOS Setup

Setup is required within MacOS environment:
+ Upgrade bash
+ Add command-line utilities

[README_BREW_SETUP_MACOS.md](README_BREW_SETUP_MACOS.md)

## OAuth 2.0 Authentication

Folder `/scripts/oauth2/` contains bash scripts for requesting `access_token` required to perform archive requests:

```bash
$ tree scripts/oauth2 --dirsfirst -FL 1 | grep -v /$

scripts/oauth2
├── get_config_credentials.sh
├── get_config_credentials_code.sh
├── get_config_credentials_token.sh
├── get_user_profile.sh
├── oauth2_code.sh
├── oauth2_refresh_token.sh
├── oauth2_login.sh
└── oauth2_token.sh
```

Folder `/scripts/credentials/` contains configuration and parsing of Web app credentials and API urls:

```bash
$ tree scripts/credentials

scripts/credentials
├── config
│   └── credentials.template.json
├── credentials_code_parse.sh
├── credentials_parse.sh
└── credentials_token_parse.sh
```

### 1. Configure `credentials.json` with `[** CLIENT_ID **]` and `[** CLIENT_SECRET **]`

1. Start with: `$ cd scripts/credentials/config/`
1. Create a copy of `credentials.template.json` to `credentials.json`
1. Supply these Microsoft Web App values to `credentials.json`
    + `CLIENT_ID`
    + `CLIENT_SECRET`

```json
{
  "client_id":"[** CLIENT_ID **]",
  "client_secret":"[** CLIENT_SECRET **]",
  ...
}
```

If configured correctly, then it should be parsable:

1. Start with: `cd scripts/oauth2/`
1. Execute: `get_config_credentials.sh`

Example response of parsed `scripts/credentials/config/credentials.json`

```bash
-------------------------

  CLIENT_ID: [** CLIENT_ID **]
  CLIENT_SECRET: [** CLIENT_SECRET **]
  REDIRECT_URI: http://localhost
  PROTOCOL: https
  AUTH_URL: https://login.microsoftonline.com/common/oauth2/v2.0/authorize
  AUTH_TOKEN_URL: https://login.microsoftonline.com/common/oauth2/v2.0/token
  AUTH_USER_URL: https://graph.microsoft.com/v1.0/me/
  AUTH_SCOPE: User.Read%20User.ReadBasic.All%20Files.ReadWrite.All%20offline_access
  API_HOSTNAME: graph.microsoft.com
  API_VERSION: v1.0
  API_BASE_URL: https://graph.microsoft.com/v1.0

-------------------------
```

### 2. Request `[** AUTHENTICATION_CODE **]`

1. Start with: `cd scripts/oauth2/`
1. Execute: `./oauth2_start.sh --verbose`
    + Uses: `credentials.json`
    + Opens default browser 
    + Accesses Microsoft API endpoint to OAuth 2.0 Authentication Service
1. Example Microsoft URL to begin OAuth 2.0  authenticaiton request:
    ```bash
    https://login.microsoftonline.com/common/oauth2/v2.0/authorize?
    response_type=code
    &client_id=[** CLIENT_ID **]
    &redirect_uri=http://localhost
    &scope=User.Read%20User.ReadBasic.All%20Files.ReadWrite.All%20offline_access
    &state=[** STATE **]
    ``` 
1. Default browser opens
1. Microsoft Login should appear
1. Login
1. Consent Microsoft Web App to Grant Access to User's Account
1. Browser next opens with `REDIRECT_URI=http://localhost`
1. Copy Browser's Address Bar: `[** REDIRECT_URI RESPONSE **]`
    1. Copy Browser's Address Bar: `[** REDIRECT_URI RESPONSE **]`

### 3. Parse `[** REDIRECT_URI RESPONSE **]` to fetch `[** AUTHENTICATION_CODE **]`

**Quickly**, copy response redirect URI in browser's address bar, `[** REDIRECT_URI RESPONSE **]` 
because it contains in query string `[** AUTHENTICATION_CODE **]` that is time-limited to approximately one minute.

Authenticated response `REDIRECT_URI=http://localhost` will contain `[** AUTHENTICATION_CODE **]` within its query string.

1. Start with: `cd scripts/oauth2/`
1. Execute: `./oauth2_code.sh --url "[** REDIRECT URI RESPONSE **]"`
    + This script creates: `credentials_code.json`.
1. Parsed `[** REDIRECT URI RESPONSE **]` query parameters copied to `/scripts/credentials/config/credentials_code.json`
1. `/scripts/credentials/config/credentials_code.json` will contain `[** AUTHENTICATION_CODE **]`
1. With gathered time-limited `[** AUTHENTICATION_CODE **]`, go immediately go to Step 2 to request `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`.

Example requests to parse `[** REDIRECT URI RESPONSE **]`, requires wrapping URL with **double-quotes `"[URL]"`**:

```bash
$ ./oauth2_code.sh --url "[** REDIRECT_URI RESPONSE **]"
```

Example contents `scripts/credentials/config/credentials_code.json`:

```json
{
  "code": "[** AUTHENTICATION_CODE **]",
  "state": "[** STATE **]",
  "session_state": "[** SESSION STATE **]"
}
```

If configured correctly, then it should be parsable:

```bash
$ ./get_config_credentials_code.sh

-------------------------

  AUTHENTICATION_CODE: [** AUTHENTICATION_CODE **]

-------------------------
```

### 3. With `[** AUTHENTICATION_CODE **]`, request new `[** ACCESS_TOKEN **]` and `[** REFRESH_TOKEN **]`

**Quickly**, new gather tokens because `[** AUTHENTICATION_CODE **]` is time-limited to approximately one minute.

1. Start with: `cd scripts/oauth2/`
1. Execute `./oauth2_token.sh --verbose`
    + This script uses: `credentials_code.json`.
1. Success will copy `[** ACCESS_TOKEN **]` and `[** REFRESH_TOKEN **]` to `/scripts/credentials/config/credentials_token.json`

Example bash/curl request:

```bash
$ ./oauth2_token.sh --verbose

curl "https://login.microsoftonline.com/common/oauth2/v2.0/token"
    --request POST \
    --verbose \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --data 'grant_type=authorization_code' \
    --data-urlencode 'code=[** AUTHENTICATION_CODE **]' \
    --data-urlencode 'client_id=[** CLIENT_ID **]' \
    --data-urlencode 'client_secret=[** CLIENT_SECRET **]' \
    --data-urlencode 'redirect_uri=http://localhost' \
    --data-urlencode 'state=[** STATE **]'
```

Example contents `scripts/credentials/config/credentials_token.json`:

```json
{
  "token_type": "Bearer",
  "scope": "Files.ReadWrite.All Sites.Manage.All Sites.Read.All Sites.ReadWrite.All User.Read User.ReadBasic.All profile openid email",
  "expires_in": 3599,
  "ext_expires_in": 3599,
  "access_token": "[** ACCESS_TOKEN **]",
  "refresh_token": "[** REFRESH_TOKEN **]"
}
```

If configured correctly, then it should be parsable:

1. Start with: `$ cd scripts/oauth2/`
1. Execute: `$ get_config_credentials_token.sh`

```bash
  ACCESS_TOKEN: [** ACCESS_TOKEN **]
  TOKEN_TYPE: Bearer
  EXPIRES_IN: 3599
  REFRESH_TOKEN: [** REFRESH_TOKEN **]
```

### 4. With `[** REFRESH_TOKEN **]`, Refresh `[** ACCESS_TOKEN **]` 

When expired, refresh `access_token`:

1. Start with: `cd scripts/oauth2/`
1. Execute `./oauth2_refresh_token.sh --verbose`
    + This script uses: `credentials_token.json`.
1. Success will copy refreshed `[** ACCESS_TOKEN **]` and `[** REFRESH_TOKEN **]` to `/scripts/credentials/config/credentials_token.json`

Example bash/curl request:

```bash
$ ./oauth2_refresh_token.sh --verbose

curl "https://login.microsoftonline.com/common/oauth2/v2.0/token"
    --request POST \
    --verbose \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --data 'grant_type=refresh_token' \
    --data-urlencode 'code=[** AUTH CODE **]' \
    --data-urlencode 'client_id=[** CLIENT_ID **]' \
    --data-urlencode 'client_secret=[** CLIENT_SECRET **]' \
    --data-urlencode 'redirect_uri=http://localhost' \
    --data-urlencode 'refresh_token=[** REFRESH_TOKEN **]'
```

Example refreshed contents `scripts/credentials/config/credentials_token.json`

```json
{
  "token_type": "Bearer",
  "scope": "Files.ReadWrite.All Sites.Manage.All Sites.Read.All Sites.ReadWrite.All User.Read User.ReadBasic.All profile openid email",
  "expires_in": 3599,
  "ext_expires_in": 3599,
  "access_token": "[** ACCESS_TOKEN **]",
  "refresh_token": "[** REFRESH_TOKEN **]"
}
```

### 5. Test `[** ACCESS_TOKEN **]` by requesting Microsoft User Info

1. Start with: `cd scripts/oauth2/`
1. Execute `./get_user_profile.sh --verbose`
    + This script uses: `credentials_token.json`.

```bash
$ ./get_user_profile.sh --verbose

curl "https://graph.microsoft.com/v1.0/me"
  --request GET \
  --verbose \
  --write-out 'HTTPSTATUS:%{http_code}' \
  --silent \
  --header "authorization: Bearer [** ACCESS_TOKEN **]" \
  --header "Content-Type: application/json"
```

Example response for Microsoft user info:

```json
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
  "businessPhones": [
    "+12065765776"
  ],
  "displayName": "Jeffrey Tanner",
  "givenName": "Jeffrey",
  "jobTitle": "Senior Software Engineer, ACT",
  "mail": "Jeffrey.Tanner@docusign.com",
  "mobilePhone": "+12068498808",
  "officeLocation": "US-Seattle-3rd",
  "preferredLanguage": null,
  "surname": "Tanner",
  "userPrincipalName": "Jeffrey.Tanner@docusign.com",
  "id": "54cfd612-497b-462e-a2cd-4042c3809dde"
}
```