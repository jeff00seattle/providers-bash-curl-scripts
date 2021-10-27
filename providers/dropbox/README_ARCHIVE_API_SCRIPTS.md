# @act/act-archive-dropbox
##### Dropbox: API Bash Scripts

----

![](./doc/images/Dropbox_Logo.png)

----

## Dropbox API

* [Overview](https://www.dropbox.com/developers/documentation/http/overview)
* [Endpoints](https://www.dropbox.com/developers/documentation/http/documentation)

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

_Not required for Dropbox._

### List Content in "root" folder

* https://api.dropboxapi.com/2/files/list_folder
* [Explorer](https://dropbox.github.io/dropbox-api-v2-explorer/#files_list_folder)
* [Documentation](https://www.dropbox.com/developers/documentation/http/documentation#files-list_folder)

```bash
$ cd ./scripts/archive
$ ./list_all_by_id.sh --help

Usage: ./list_all_by_id.sh
 [-v|--verbose]
 [-h|--help]
 [-r|--recursive]
 [--id <string>]
```

```bash
$ ./list_folder_by_id.sh --verbose

curl "https://api.dropboxapi.com/2/files/list_folder" \
    --request POST \
    --verbose \
    --header "Authorization: Bearer [** ACCESS_TOKEN **]" \
    --header "Content-Type: application/json" \
    --header "Cache-Control: no-cache" \
    --data '{
        "path": "", 
        "recursive": false, 
        "include_media_info": false, 
        "include_deleted": false, 
        "include_has_explicit_shared_members": false, 
        "include_mounted_folders": false
    }'
```

```json
{
  "entries": [],
  "cursor": "AAEayqu5xPm0QzCtlLpDwlrAwP5N_CabusoN2akMdu0bn_fcs1ZQ6_f2YHgELXjzfEaSyFBzOZ6ipS-HdCAd-zTXY1L0td2byBwebgdNAtTOhdvqqw_r2dsoBXz6fTWeJqbztKKXLLZpAMXI2Eo1cxiGu9AfbTzFx3_6ToKEfx9EdzYGRwgqQQqlxnrFpAqFRE8",
  "has_more": false
}
```

### Create Folder

* https://api.dropboxapi.com/2/files/list_folder
* [Explorer](https://dropbox.github.io/dropbox-api-v2-explorer/#files_create_folder_v2)
* [Documentation](https://www.dropbox.com/developers/documentation/http/documentation#files-create_folder_v2)

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

curl "https://api.dropboxapi.com/2/files/create_folder_v2" \
--request POST \
--verbose \
--header "authorization: Bearer [** ACCESS_TOKEN **]" \
--header "cache-control: no-cache" \
--header "content-type: application/json; charset=utf-8" \
--header "Accept: application/json" \
--data '{"path": "/080df3d6-f94b-4ecc-a176-5420b43013e8", "autorename": false}'
```

#### Success

```bash
-------------------------

Success [HTTP status: 200]
[
  {
    "type": "folder",
    "name": "AAA",
    "path": "/AAA",
    "id": "id:D7L5tNn4AoAAAAAAAAAVmw"
  },
  {
    "type": "folder",
    "name": "698768b4-dd42-4c25-b0d0-370c58a69c9a",
    "path": "/698768b4-dd42-4c25-b0d0-370c58a69c9a",
    "id": "id:D7L5tNn4AoAAAAAAAAAVoA"
  },
  {
    "type": "folder",
    "name": "ebe4858a-4b38-4209-87ad-3cb948ff0f7b",
    "path": "/ebe4858a-4b38-4209-87ad-3cb948ff0f7b",
    "id": "id:D7L5tNn4AoAAAAAAAAAVoQ"
  },
]
```

#### Error

```bash
-------------------------

Error [HTTP status: 409]
{
  "error_summary": "path/not_found/...",
  "error": {
    ".tag": "path",
    "path": {
      ".tag": "not_found"
    }
  }
}

-------------------------
```

### Delete Folder by ID

```bash
$ ./delete_by_id.sh --help
 --help --

Usage: ./delete_by_id.sh
 [-v|--verbose]
 [-h|--help]
 [--id <string>]
```

```bash
$ ./delete_by_id.sh --verbose --id 'id:D7L5tNn4AoAAAAAAAAAS-A'

curl "https://api.dropboxapi.com/2/files/delete_v2" \
--request POST \
--verbose \
--header "authorization: Bearer [** ACCESS_TOKEN **]" \
--header "cache-control: no-cache" \
--header "Content-Type: application/json" \
--data '{ "path": "id:D7L5tNn4AoAAAAAAAAAS-A" }'
```

#### Success

```bash
-------------------------

Success [HTTP status: 200]
{
  "type": "folder",
  "name": "6cfcdb86-01cb-4d42-a251-7ba1797ef912",
  "path": "/6cfcdb86-01cb-4d42-a251-7ba1797ef912",
  "id": "id:D7L5tNn4AoAAAAAAAAAVyA"
}

-------------------------
```

#### Error

```bash
-------------------------

Error [HTTP status: 409]
{
  "error_summary": "path_lookup/not_found/.",
  "error": {
    ".tag": "path_lookup",
    "path_lookup": {
      ".tag": "not_found"
    }
  }
}

-------------------------
```

### Upload File

https://www.dropbox.com/developers/documentation/http/documentation#files-upload

```bash
$ ./upload_file.sh --verbose --id 'id:D7L5tNn4AoAAAAAAAAATWg' --upload './files/dummy.png'

curl 'https://content.dropboxapi.com/2/files/upload' \
--request POST \
--verbose \
--header 'authorization: Bearer [** ACCESS_TOKEN **]' \
--header 'Content-Type: application/octet-stream' \
--header 'Dropbox-API-Arg: {"path": "id:D7L5tNn4AoAAAAAAAAATWg/dummy.png", "mode": {".tag": "add"}, "autorename": true, "mute": false, "strict_conflict": false}' \
--data-binary @'./files/dummy.png'
```

```bash
< HTTP/1.1 100 Continue
```

```json
{
  "name": "dummy.png",
  "path_lower": "/26fe443e-62b9-4bc4-b33f-d27c13c7d2cd/dummy.png",
  "path_display": "/26fe443e-62b9-4bc4-b33f-d27c13c7d2cd/dummy.png",
  "id": "id:D7L5tNn4AoAAAAAAAAATYg",
  "client_modified": "2019-10-03T18:42:04Z",
  "server_modified": "2019-10-03T18:42:04Z",
  "rev": "59405f122c8f6fc6cebd0",
  "size": 102935,
  "is_downloadable": true,
  "content_hash": "e84ed169004a37908acb04f83af099995541f1bf85e8bcfff3039a332f84fc33"
}
```
