# @act/act-archive-box
##### Box: OAuth 2.0 Bash Scripts

---

![](./doc/images/Box_Logo.png)

---

## Getting Box `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`

The following is gathering Box `access_token` using bash scripts in folder `scripts/oauth2/`.

#### 1. Create and Configure

Start with:

`$ cd scripts/oauth2/credentials/config/`

##### 1.a. `credentials/config/credentials.json`

1. Create a copy of `credentials.template.json` to `credentials.json`
1. Supply these values to `credentials.json`
    + `CLIENT_ID`: Dropbox setting is `App key`
    + `CLIENT_SECRET`: Dropbox setting is `App secret`

```json
{
  "client_id":"[** CLIENT_ID **]",
  "client_secret":"[** CLIENT_SECRET **]"
  ...
}
```

##### 1.b. `credentials/config/credentials_code.json`

1. Create a copy of `credentials_code.template.json` to `credentials_code.json`
1. Later you will be entering 60 seconds time-limited `[** AUTHENTICATION_CODE **]` value to this file.

```json
{
  "code": "[** AUTHENTICATION_CODE **]"
}
```

##### 1.c. `credentials/config/credentials_token.json`

1. Create a copy of `credentials_token.template.json` to `credentials_token.json`
1. Later you will be entering 4000 seconds time-limited `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]` values to this file.

#### 2. Getting OAuth 2.0 `[** AUTHENTICATION_CODE **]`, `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`

The goal here is to gather Box's provided `[** AUTHENTICATION_CODE **]` after successful login and grant, which will allow getting from 
Box's authentication service an `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`.

It is important to note that the provided `[** AUTHENTICATION_CODE **]`:
    + Used to gather `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`.
    + A one-time usage value and has an extremely short validity, 1 minute.

##### 2.a. Box Authorization Code then IMMEDIATELY Access Token

Steps:
1. Execute `$ ./oauth2_code.sh`
1. Browser window should appear with Box Login
   + Login 
        ![Box_OAuth2_Login](../doc/images/Box_Login.png)
   + Grant Access
        ![Box_OAuth2_Grant_Access](../doc/images/Box_Grant_Access.png)
1. **Quickly**, this following steps must be performed within less than 1 minute:
    + Box authenication service using configured `REDIRECT_URI=http://localhost` provides `[** AUTHENTICATION_CODE **]` within its path.
    + Copy `[** AUTHENTICATION_CODE **]` from Box authentication service's returned `http://localhost?...code=`.
    + Open previously created `credentials/config/credentials_code.json` and add copied `[** AUTHENTICATION_CODE **]`
    + Execute `$ ./oauth2_token.sh`

##### 2.b. Getting `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`

1. If executing `$ ./oauth2_token.sh` has been successful, then the following JSON should the response:
    ```json
    {
      "access_token": "[** ACCESS TOKEN **]",
      "expires_in": 3846,
      "restricted_to": [],
      "refresh_token": "[** REFRESH TOKEN **]",
      "token_type": "bearer"
    }
    ```
1. Open previously created `credentials/config/credentials_token.json` and copy this JSON in it entirety to this file.
1. `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]` in this file are only for less than 4000 seconds.

##### 3. Refreshing Timelimited `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`

When Box `[** ACCESS TOKEN **]` expires:
    + execute `$ oauth2_refresh_token.sh`.
    + Copy new JSON response to `credentials/config/credentials_token.json`


##### 4. Using `[** ACCESS TOKEN **]` and `[** REFRESH TOKEN **]`

There are two location within this code where time-limited contents of 
`scripts/oauth2/credentials/config/credentials_token.json` will be used:
    + `scripts/archive/credentials/config/credentials_token.json` for performing **Box API** calls using bash.
    + `test/integration/credentials/config/credentials_token.json` for performing `@act/act-archive-box` integration test.
    


