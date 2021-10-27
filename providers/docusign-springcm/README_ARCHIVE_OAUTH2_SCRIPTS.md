# @act/act-archive-docusign-springcm
##### DocuSign SpringCM: OAuth 2.0 Bash Scripts

---

![](./doc/images/DocuSign_SpringCM_Logo.png)

---

## MacOS Setup

Setup is required within MacOS environment:
+ Upgrade bash
+ Add command-line utilities

[README_BREW_SETUP_MACOS.md](../../README_BREW_SETUP_MACOS.md)

## OAuth 2.0 Authentication

The following is gathering Google `access_token` using bash scripts in folder `scripts/oauth2/`:

```bash
$ tree scripts/oauth2 --dirsfirst -FL 1 | grep -v /$

scripts/oauth2
├── get_config_credentials.sh
├── get_config_credentials_code.sh
├── get_config_credentials_token.sh
├── get_userinfo.sh
├── oauth2_code.sh
├── oauth2_refresh_token.sh
├── oauth2_login.sh
└── oauth2_token.sh
```

And provide credential configuration to:

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
1. Supply these Google Web App values to `credentials.json`
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
  DATACENTER_ENV: "uat"
  DATACENTER_LOC: "na11"
  AUTH_DOMAIN: springcm.com
  AUTH_URL: https://loginuat.springcm.com/oauth/authorize
  AUTH_TOKEN_URL: https://authuat.springcm.com/api/v201606/token
  AUTH_USER_URL: https://authuat.springcm.com/api/v201606/apiuser
  API_DOMAIN: springcm.com
  API_DATA_CENTER: uatna11
  API_VERSION: v201411
  API_BASE_URL: https://apiuatna11.springcm.com
  API_UPLOAD_URL: https://apiuploaduatna11.springcm.com
  SECURITY_TOKEN: 6df5662f-622b-485d-aff7-7b087a8016c3
  DOCUSIGN_ID: cb67ea1c-3264-498b-9039-b6cf801c2c59

-------------------------
```

### 2. Request `[** AUTHENTICATION_CODE **]`

1. Start with: `cd scripts/oauth2/`
1. Execute: `./oauth2_start.sh --verbose`
    + Uses: `credentials.json`
    + Opens default browser 
    + Accesses DocuSign SpringCM API endpoint to OAuth 2.0 Authentication Service
1. Example DocuSign SpringCM URL to begin OAuth 2.0  authenticaiton request:
    ```bash
    https://loginuat.springcm.com/oauth/authorize?
	response_type=code
	&client_id=[** CLIENT_ID **]
	&redirect_uri=http://localhost
	&state=[** STATE **]
    ``` 
1. Default browser opens
1. DocuSign SpringCM Login should appear
1. Login to DocuSign SpringCM account
1. Consent DocuSign SpringCM Web App to Grant Access to User's Account
1. Browser next opens with `REDIRECT_URI=http://localhost`
1. Copy Browser's Address Bar: `[** REDIRECT_URI RESPONSE **]`

### 3. Parse `[** REDIRECT_URI RESPONSE **]` to fetch `[** AUTHENTICATION_CODE **]`

**Quickly**, copy response redirect URI in browser's address bar, `[** REDIRECT_URI RESPONSE **]` 
because it contains in query string `[** AUTHENTICATION_CODE **]` that is time-limited to approximately one minute.

Authenticated response `REDIRECT_URI=http://localhost` will contain `[** AUTHENTICATION_CODE **]` within its query string.

1. Start with: `cd scripts/oauth2/`
1. Execute: `./oauth2_code.sh --url "[** REDIRECT URI RESPONSE **]"`
    + This script creates: `credentials.code.json`.
1. Parsed `[** REDIRECT URI RESPONSE **]` query parameters copied to `/scripts/credentials/config/credentials.code.json`
1. `/scripts/credentials/config/credentials.code.json` will contain `[** AUTHENTICATION_CODE **]`
1. With gathered time-limited `[** AUTHENTICATION_CODE **]`, go immediately go to Step 2 to request `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`.

Example requests to parse `[** REDIRECT URI RESPONSE **]`, requires wrapping URL with **double-quotes `"[URL]"`**:

```bash
$ ./oauth2_code.sh --url "[** REDIRECT_URI RESPONSE **]"
```

Example contents `scripts/credentials/config/credentials.code.json`:

```json
{
  "state": "[** STATE **]",
  "code": "[** AUTHENTICATION_CODE **]"
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
    + This script uses: `credentials.code.json`.
1. Success will copy `[** ACCESS_TOKEN **]` and `[** REFRESH_TOKEN **]` to `/scripts/credentials/config/credentials.token.json`

Example bash/curl request:

```bash
$ ./oauth2_token.sh --verbose

curl "https://authuat.springcm.com/api/v201606/token" \
    --request POST \
    --verbose \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --data 'grant_type=authorization_code' \
    --data-urlencode 'code=[** AUTHENTICATION_CODE **]' \
    --data-urlencode 'client_id=[** CLIENT_ID **]' \
    --data-urlencode 'client_secret=[** CLIENT_SECRET **]' \
    --data-urlencode 'redirect_uri=http://localhost'
```

Example contents `scripts/credentials/config/credentials.token.json`:

```json
{
  "access_token": "[** ACCESS_TOKEN **]",
  "token_type": "bearer",
  "expires_in": 3598,
  "refresh_token": "[** REFRESH_TOKEN **]",
  "api_base_url": "https://apiuatna11.springcm.com"

}
```

If configured correctly, then it should be parsable:

1. Start with: `$ cd scripts/oauth2/`
1. Execute: `$ ./get_config_credentials_token.sh`

```bash
  ACCESS_TOKEN: [** ACCESS_TOKEN **]
  TOKEN_TYPE: Bearer
  EXPIRES_IN: 3599
  REFRESH_TOKEN: [** REFRESH_TOKEN **]
  API_BASE_URL: https://apiuatna11.springcm.com
```

### 4. With `[** REFRESH_TOKEN **]`, Refresh `[** ACCESS_TOKEN **]` 

When expired, refresh `access_token`:

1. Start with: `cd scripts/oauth2/`
1. Execute `./oauth2_refresh_token.sh --verbose`
    + This script uses: `credentials.token.json`.
1. Success will copy refreshed `[** ACCESS_TOKEN **]` and initial `[** REFRESH_TOKEN **]` to `/scripts/credentials/config/credentials.token.json`

Example bash/curl request:

```bash
$ ./oauth2_refresh_token.sh --verbose

curl "https://www.googleapis.com/oauth2/v4/token" \
    --request POST \
    --verbose \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --data 'grant_type=refresh_token' \
    --data-urlencode 'client_id=[** CLIENT_ID **]' \
    --data-urlencode 'client_secret=[** CLIENT_SECRET **]' \
    --data-urlencode 'refresh_token=[** REFRESH_TOKEN **]'
```

Example refreshed contents `scripts/credentials/config/credentials.token.json`

```json
{
  "access_token": "[** ACCESS_TOKEN **]",
  "expires_in": 3599,
  "scope": "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/drive openid",
  "token_type": "Bearer",
  "id_token": "[** ID_TOKEN **]",
  "refresh_token": "[** REFRESH_TOKEN **]"
}
```

### 5. Test `[** ACCESS_TOKEN **]` by requesting DocuSign SpringCM User Info

1. Start with: `cd scripts/oauth2/`
1. Execute `./get_userinfo.sh --verbose`
    + This script uses: `credentials.token.json`.

```bash
$ ./get_userinfo.sh --verbose

curl 'https://apiuatna11.springcm.com/v201411/accounts/current' \
  --request GET \
  --verbose \
  --write-out 'HTTPSTATUS:%{http_code}' \
  --silent \
  --header "authorization: Bearer [** ACCESS_TOKEN **]"
```

Example response for DocuSign SpringCM user info:

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