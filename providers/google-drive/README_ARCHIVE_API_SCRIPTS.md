# @act/act-archive-google-drive
##### Google Drive: API Bash Scripts

**[WORK IN PROGRESS]**

---

![](./doc/images/Google_Drive_logo.png)

---

## MacOS Setup

Setup is required within MacOS environment:
+ Upgrade bash
+ Add command-line utilities

See directions for updating MacOS environment:
[README_BREW_SETUP_MACOS.md](README_BREW_SETUP_MACOS.md)

## OAuth 2.0 Authentication

All archive scripts requires valid `access_token`, which requires refreshing every 3600 seconds. 
This is acquired through OAuth 2.0 Authentication Service.

See directions for getting OAuth 2.0 Access Token:
[README_ARCHIVE_OAUTH2_SCRIPTS.md](README_ARCHIVE_OAUTH2_SCRIPTS.md)

## Google Drive API

This API reference is organized by resource type. Each resource type has one or more data representations and one or more methods.

* [API Reference](https://developers.google.com/drive/api/v3/reference)

## Google Drive API: Bash Scripts
The following bash scripts makes curl call to DocuSign OneDrive API and all expect a valid `[** ACCESS_TOKEN **]`:

```bash
$ tree scripts/archive --dirsfirst -FL 1 | grep -v /$

scripts/archive
├── delete_all_by_id.sh
├── delete_by_id.sh
├── get_config_credentials.sh
├── get_config_credentials_token.sh
├── get_file_metadata_by_id.sh
├── get_find_folder.sh
├── get_list_all.sh
├── get_list_files.sh
├── get_list_folders.sh
├── get_root.sh
├── post_create_folder.sh
└── post_upload_file.sh
```

## Google Drive API: Bash Scripts Usage


### Create Folder

**[TODO]**

```bash
$ ./create_folder.sh --verbose

curl "https://www.googleapis.com/drive/v3/files" \
    --request POST  \
    --verbose  \
    --header "authorization: Bearer [** ACCESS_TOKEN **]" \
    --header "cache-control: no-cache" \
    --header "Content-Type: application/json; charset=utf-8" \
    --header "Accept: application/json" \
    --write-out 'HTTPSTATUS:%{http_code}' \
    --silent \
    --data '{ \
        "mimeType":"application\/vnd.google-apps.folder", \
        "name": "1fd931bf-57d6-47c2-926c-2a154b4c314f" \
    }'

-------------------------

Success [HTTP status: 200]
{
  "kind": "drive#file",
  "id": "1jTEFPEXxjjA6pRLen3QlC_kxoavjEH3l",
  "name": "1fd931bf-57d6-47c2-926c-2a154b4c314f",
  "mimeType": "application/vnd.google-apps.folder"
}

-------------------------
```

### List Folders

**[TODO]**

### Upload File

**[TODO]**
