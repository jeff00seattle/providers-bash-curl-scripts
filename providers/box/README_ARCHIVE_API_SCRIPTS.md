# @act/act-archive-box
##### Box: API Bash Scripts

----

![](./doc/images/Box_Logo.png)

----

## Box API

* [Overview](https://developer.box.com/reference)


## Setup

```bash
$ cd ./scripts/oauth2
$ cp ./src/config/credentials_token.template.json ./src/config/credentials_token.json
```

### Config

Provide values for `./src/config/credentials_token.json`

```json
{
  "access_token": "[** ACCESS_TOKEN **]",
  "token_type": "bearer"
}
```

## Start

```bash
$ bash --version
GNU bash, version 5.0.7(1)-release (x86_64-apple-darwin18.5.0)

$ curl --version
curl 7.54.0 (x86_64-apple-darwin18.0) libcurl/7.54.0 LibreSSL/2.6.5 zlib/1.2.11 nghttp2/1.24.1
```

To run these bash scripts requires installing in Mac OS bash function `getopt`, which parses options from shell script command line. 

```bash
$ brew link --force gnu-getopt
$ brew install gnu-getopt
```

### Go To Archive Scripts Folder

```bash
$ cd ./scripts/archive
```

### Refresh Access Token

```bash
$ cd ./scripts/archive
$ ./get_refresh_access_token.sh --verbose

curl "https://api.box.com/oauth2/token" \
--request POST \
--connect-timeout 60 \
--header "Content-Type: application/json; charset=utf-8" \
--header "Accept: application/json" \
--verbose \
--data "grant_type=refresh_token" \
--data "refresh_token=[** REFRESH_TOKEN **]" \
--data "client_id=[** CLIENT_ID **]" \
--data "client_secret=[** CLIENT_SECRET **]" \
--header "cache-control: no-cache"
```

```json
{
  "access_token": "[** NEW ACCESS_TOKEN **]",
  "expires_in": 3958,
  "restricted_to": [],
  "refresh_token": "[** NEW REFRESH_TOKEN **]",
  "token_type": "bearer"
}
```

### List Content in "root" folder

* https://developer.box.com/reference
* `https://api.box.com/2.0/folders/folder_id/items`

```bash
$ cd ./scripts/archive
$ ./list_folder_by_id.sh --help

Usage: ./list_all.sh
 [-v|--verbose]
 [-h|--help]
 [--id <string>]
```

```bash
$ ./list_all.sh --verbose

curl "https://api.box.com/2.0/folders/0/items" \
    --request GET \
    --verbose -G \
    --data-urlencode "fields=id,name,type,item_collection,modified_at" \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --header "authorization: Bearer [** ACCESS_TOKEN **]" \
    --header "cache-control: no-cache"

-------------------------

Success [HTTP status: 200]
[
  {
    "type": "folder",
    "name": "157214a3-8a1d-4ff6-811e-67153dd601be",
    "id": "90050186517"
  },
  {
    "type": "folder",
    "name": "cdd56fe2-1f4b-4937-ae2f-406c8e704a91",
    "id": "90051120980"
  }
]

-------------------------
```

### Create Folder

```bash
$ ./create_folder.sh --help
 --help --

Usage: ./create_folder.sh
 [-v|--verbose]
 [-h|--help]
 [--folder <string>]
 [--parent <string>]
```

```bash
$ ./create_folder.sh --verbose

curl "https://api.box.com/2.0/folders" \
    --request POST \
    --verbose \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --header "authorization: Bearer [** ACCESS_TOKEN **]" \
    --header "cache-control: no-cache" \
    --header "content-type: application/json; charset=utf-8" \
    --header "Accept: application/json" \
    --data '{"name": "f07388e4-d42e-4b01-be3b-25b204163edb", "parent": {"id": "0"}}'

-------------------------

Success [HTTP status: 201]
{
  "type": "folder",
  "name": "99ccbcf7-0d24-4367-87d9-eba0b7de0e62",
  "id": "90056417172",
  "parent": {
    "type": "folder",
    "name": "All Files",
    "id": "0"
  }
}

-------------------------
```

### Delete Folder by id

```bash
$ ./delete_by_id.sh --help
 --help --

Usage: ./delete_by_id.sh
 [-v|--verbose]
 [-h|--help]
 [--id <string>]
```

```bash
$ ./delete_by_id.sh --id '88771669787' --verbose

curl "https://api.box.com/2.0/folders/88771669787?recursive=true" \
--request DELETE \
--verbose \
--header "authorization: Bearer [** ACCESS_TOKEN **]"

-------------------------

Success [HTTP status: 204]

-------------------------
```

### Upload File

```bash
$ /upload_file.sh --verbose --id '90050186517' --file './files/dummy.png'

curl 'https://upload.box.com/api/2.0/files/content' \
    --request POST \
    --verbose \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --header 'authorization: Bearer [** ACCESS_TOKEN **]' \
    --header 'Content-Type: multipart/form-data' \
    --form attributes='{ "name": "dummy.png", "parent": { "id": "90050186517" } }' \
    --form file=@'./files/dummy.png'

-------------------------

Success [HTTP status: 201]
[
  {
    "type": "file",
    "name": "dummy.png",
    "id": "540085968751"
  }
]

-------------------------
```


