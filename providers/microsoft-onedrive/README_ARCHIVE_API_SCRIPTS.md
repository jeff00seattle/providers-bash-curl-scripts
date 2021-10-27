# @act/act-archive-microsoft-onedrive
##### Microsoft OneDrive: Bash Scripts

**[WORK IN PROGRESS]**

---

![](./doc/images/OneDrive_logo.png)

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

## Microsoft Graph API for OneDrive

This API reference is organized by resource type. Each resource type has one or more data representations and one or more methods.

* [API Reference](https://developers.google.com/drive/api/v3/reference)

## Microsoft Graph API for OneDrive: Bash Scripts

Folder `/scripts/archive` contains bash scripts making curl calls to Microsoft Graph API using `access_token` 
acquired by OAuth 2.0 bash scripts in `/scripts/oauth2`:

```bash
$ tree scripts/archive --dirsfirst -FL 1 | grep -v /$

scripts/archive
├── delete_user_drive_file_by_id.sh
├── delete_user_drive_folder_by_id.sh
├── get_config_credentials.sh
├── get_config_credentials_token.sh
├── get_user_drive_folders_list_by_id.sh
├── get_user_drive_folders_list_by_path.sh
├── get_user_drive_item_by_id.sh
├── get_user_drive_items_list_by_id.sh
├── get_user_drive_root.sh
├── get_user_drive_root_folders_list.sh
├── get_user_drive_root_item_by_path.sh
├── get_user_drives.sh
├── get_user_profile.sh
├── post_user_drive_parent_file_upload.sh
├── post_user_drive_parent_folder_create.sh
├── post_user_drive_root_file_upload.sh
├── post_user_drive_root_folder_create.sh
├── put_user_drive_parent_file_upload.sh
└── put_user_drive_root_file_upload.sh
```

## Microsoft Graph API for OneDrive: Bash Scripts Usage

#### `get_user.sh`

Current user:

```http request
GET https://graph.microsoft.com/v1.0/me
```

```bash
$ ./get_user.sh

curl "https://graph.microsoft.com/v1.0/me"
  --request GET
   --verbose
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header "authorization: Bearer [** ACCESS_TOKEN **]"
  --header "Content-Type: application/json"
```

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

#### `get_list_drives.sh`

List the current user's drives:

```http request
GET https://graph.microsoft.com/v1.0/me/drives
```

```bash
$ ./get_list_drives.sh
```

```json
{
    "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#drives",
    "value": [
        {
            "createdDateTime": "2018-06-16T15:47:04Z",
            "description": "",
            "id": "b!5P4caSKNA0q5DPV6CWwJjDszVhagtDROhQ0vSunkb9bIi-3iiqnjToxdZ5_S1_Ir",
            "lastModifiedDateTime": "2018-06-16T15:47:04Z",
            "name": "OneDrive",
            "webUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/Documents",
            "driveType": "business",
            "createdBy": {
                "user": {
                    "displayName": "System Account"
                }
            },
            "lastModifiedBy": {
                "user": {
                    "email": "Jeffrey.Tanner@docusign.com",
                    "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
                    "displayName": "Jeffrey Tanner"
                }
            },
            "owner": {
                "user": {
                    "email": "Jeffrey.Tanner@docusign.com",
                    "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
                    "displayName": "Jeffrey Tanner"
                }
            },
            "quota": {
                "deleted": 0,
                "remaining": 1099504326293,
                "state": "normal",
                "total": 1099511627776,
                "used": 5205199
            }
        }
    ]
}
```

#### `./get_list_root_folder.sh`

```http request
GET https://graph.microsoft.com/v1.0/me/drive/root/children
```

```bash
$ ./get_list_root_folder.sh
```

```json
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users('54cfd612-497b-462e-a2cd-4042c3809dde')/drive/root/children",
  "value": [
    {
      "createdDateTime": "2019-11-05T20:19:42Z",
      "eTag": "\"{AE65F567-BC87-48E1-A495-BB29A5E0F9F6},1\"",
      "id": "013DGZ5ZDH6VS25B544FEKJFN3FGS6B6PW",
      "lastModifiedDateTime": "2019-11-05T20:19:42Z",
      "name": "TEST_A",
      "webUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/Documents/TEST_A",
      "cTag": "\"c:{AE65F567-BC87-48E1-A495-BB29A5E0F9F6},0\"",
      "size": 140146,
      "createdBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "lastModifiedBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "parentReference": {
        "driveId": "b!5P4caSKNA0q5DPV6CWwJjDszVhagtDROhQ0vSunkb9bIi-3iiqnjToxdZ5_S1_Ir",
        "driveType": "business",
        "id": "013DGZ5ZF6Y2GOVW7725BZO354PWSELRRZ",
        "path": "/drive/root:"
      },
      "fileSystemInfo": {
        "createdDateTime": "2019-11-05T20:19:42Z",
        "lastModifiedDateTime": "2019-11-05T20:19:42Z"
      },
      "folder": {
        "childCount": 2
      }
    },
    {
      "@microsoft.graph.downloadUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/_layouts/15/download.aspx?UniqueId=0b61e019-9011-4180-8182-4b77e84bd703&Translate=false&tempauth=eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvZG9jdXNpZ24yY29tLW15LnNoYXJlcG9pbnQuY29tQDIzN2U3MDFjLTMyN2YtNGNhZC1hNWExLWRkYTI0MTJkODlkOSIsImlzcyI6IjAwMDAwMDAzLTAwMDAtMGZmMS1jZTAwLTAwMDAwMDAwMDAwMCIsIm5iZiI6IjE1NzI5OTIzMjQiLCJleHAiOiIxNTcyOTk1OTI0IiwiZW5kcG9pbnR1cmwiOiJxRHBLbnFEcFB2eFQ2MUFQWHpmbHZVNDByaXl0c212aXptQlJWWW1Ub3RvPSIsImVuZHBvaW50dXJsTGVuZ3RoIjoiMTYzIiwiaXNsb29wYmFjayI6IlRydWUiLCJjaWQiOiJPV1UwWmpjNE5URXRaR1pqWVMwMFpEZzJMVGhrWkRJdE5qbGhZMlpsT0RZME56ZzMiLCJ2ZXIiOiJoYXNoZWRwcm9vZnRva2VuIiwic2l0ZWlkIjoiTmpreFkyWmxaVFF0T0dReU1pMDBZVEF6TFdJNU1HTXRaalUzWVRBNU5tTXdPVGhqIiwiYXBwX2Rpc3BsYXluYW1lIjoiZG9jdXNpZ24tYWN0LWRlbW8tcHJvdG8iLCJnaXZlbl9uYW1lIjoiSmVmZnJleSIsImZhbWlseV9uYW1lIjoiVGFubmVyIiwic2lnbmluX3N0YXRlIjoiW1wia21zaVwiXSIsImFwcGlkIjoiMjkzZGViNGEtMDBkZi00YzQyLWE0OGYtNjMzMjFhZmI1MmEzIiwidGlkIjoiMjM3ZTcwMWMtMzI3Zi00Y2FkLWE1YTEtZGRhMjQxMmQ4OWQ5IiwidXBuIjoiamVmZnJleS50YW5uZXJAZG9jdXNpZ24uY29tIiwicHVpZCI6IjEwMDMzRkZGQUMyRTI3NjYiLCJjYWNoZWtleSI6IjBoLmZ8bWVtYmVyc2hpcHwxMDAzM2ZmZmFjMmUyNzY2QGxpdmUuY29tIiwic2NwIjoiYWxsZmlsZXMud3JpdGUgYWxscHJvZmlsZXMucmVhZCIsInR0IjoiMiIsInVzZVBlcnNpc3RlbnRDb29raWUiOm51bGx9.OWYzdVg1MjdBcGhUZzdPYXl4Z2tDeEw1ZTZtSVFNSFZXRUxoRGxCT0p2MD0&ApiVersion=2.0",
      "createdDateTime": "2019-10-16T00:26:30Z",
      "eTag": "\"{0B61E019-9011-4180-8182-4B77E84BD703},1\"",
      "id": "013DGZ5ZAZ4BQQWEMQQBAYDASLO7UEXVYD",
      "lastModifiedDateTime": "2019-10-16T00:26:30Z",
      "name": "AACT Integration Accounts.docx",
      "webUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/_layouts/15/Doc.aspx?sourcedoc=%7B0B61E019-9011-4180-8182-4B77E84BD703%7D&file=AACT%20Integration%20Accounts.docx&action=default&mobileredirect=true",
      "cTag": "\"c:{0B61E019-9011-4180-8182-4B77E84BD703},1\"",
      "size": 46638,
      "createdBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "lastModifiedBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "parentReference": {
        "driveId": "b!5P4caSKNA0q5DPV6CWwJjDszVhagtDROhQ0vSunkb9bIi-3iiqnjToxdZ5_S1_Ir",
        "driveType": "business",
        "id": "013DGZ5ZF6Y2GOVW7725BZO354PWSELRRZ",
        "path": "/drive/root:"
      },
      "file": {
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "hashes": {
          "quickXorHash": "ZIS9HboXrv0e+KIo5GB38Mx8mhQ="
        }
      },
      "fileSystemInfo": {
        "createdDateTime": "2019-10-16T00:26:30Z",
        "lastModifiedDateTime": "2019-10-16T00:26:30Z"
      }
    },
    {
      "createdDateTime": "2018-06-27T00:45:26Z",
      "eTag": "\"{8082686E-4C52-4D29-B132-A722FA6EE0DC},5\"",
      "id": "013DGZ5ZDONCBIAUSMFFG3CMVHEL5G5YG4",
      "lastModifiedDateTime": "2018-08-07T19:26:17Z",
      "name": "Jeffrey @ Work",
      "webUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/_layouts/15/WopiFrame.aspx?sourcedoc=%7B8082686E-4C52-4D29-B132-A722FA6EE0DC%7D&file=Jeffrey%20@%20Work&action=default&wdorigin=Sharepoint",
      "cTag": "\"c:{8082686E-4C52-4D29-B132-A722FA6EE0DC},0\"",
      "size": 4989011,
      "createdBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "lastModifiedBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "parentReference": {
        "driveId": "b!5P4caSKNA0q5DPV6CWwJjDszVhagtDROhQ0vSunkb9bIi-3iiqnjToxdZ5_S1_Ir",
        "driveType": "business",
        "id": "013DGZ5ZF6Y2GOVW7725BZO354PWSELRRZ",
        "path": "/drive/root:"
      },
      "fileSystemInfo": {
        "createdDateTime": "2018-06-27T00:45:26Z",
        "lastModifiedDateTime": "2018-08-07T19:26:17Z"
      },
      "package": {
        "type": "oneNote"
      }
    }
  ]
}
```

#### `get_list_folder.sh`

```http request
GET https://graph.microsoft.com/v1.0/me/drive/root/children
```

```bash
./get_list_folder.sh --path '/TEST_A'
```

```json
Success [HTTP status: 200]
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users('54cfd612-497b-462e-a2cd-4042c3809dde')/drive/root/children",
  "value": [
    {
      "@microsoft.graph.downloadUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/_layouts/15/download.aspx?UniqueId=40991f35-b09d-484a-96c5-4f3a931bc3ae&Translate=false&tempauth=eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvZG9jdXNpZ24yY29tLW15LnNoYXJlcG9pbnQuY29tQDIzN2U3MDFjLTMyN2YtNGNhZC1hNWExLWRkYTI0MTJkODlkOSIsImlzcyI6IjAwMDAwMDAzLTAwMDAtMGZmMS1jZTAwLTAwMDAwMDAwMDAwMCIsIm5iZiI6IjE1NzI5OTMxODkiLCJleHAiOiIxNTcyOTk2Nzg5IiwiZW5kcG9pbnR1cmwiOiJDczhxUS9BVE1oWXl1Z3B1TWdlWW1MdzUxOGxxdWNHZUltTnhGTzlvZE04PSIsImVuZHBvaW50dXJsTGVuZ3RoIjoiMTYzIiwiaXNsb29wYmFjayI6IlRydWUiLCJjaWQiOiJOR00xT0dSa09EVXRabVJqTkMwME5EVTBMVGsyTW1RdE1UYzNaVEpsTm1JeE56TmsiLCJ2ZXIiOiJoYXNoZWRwcm9vZnRva2VuIiwic2l0ZWlkIjoiTmpreFkyWmxaVFF0T0dReU1pMDBZVEF6TFdJNU1HTXRaalUzWVRBNU5tTXdPVGhqIiwiYXBwX2Rpc3BsYXluYW1lIjoiZG9jdXNpZ24tYWN0LWRlbW8tcHJvdG8iLCJnaXZlbl9uYW1lIjoiSmVmZnJleSIsImZhbWlseV9uYW1lIjoiVGFubmVyIiwic2lnbmluX3N0YXRlIjoiW1wia21zaVwiXSIsImFwcGlkIjoiMjkzZGViNGEtMDBkZi00YzQyLWE0OGYtNjMzMjFhZmI1MmEzIiwidGlkIjoiMjM3ZTcwMWMtMzI3Zi00Y2FkLWE1YTEtZGRhMjQxMmQ4OWQ5IiwidXBuIjoiamVmZnJleS50YW5uZXJAZG9jdXNpZ24uY29tIiwicHVpZCI6IjEwMDMzRkZGQUMyRTI3NjYiLCJjYWNoZWtleSI6IjBoLmZ8bWVtYmVyc2hpcHwxMDAzM2ZmZmFjMmUyNzY2QGxpdmUuY29tIiwic2NwIjoiYWxsZmlsZXMud3JpdGUgYWxscHJvZmlsZXMucmVhZCIsInR0IjoiMiIsInVzZVBlcnNpc3RlbnRDb29raWUiOm51bGx9.WVJRY0VRSk5WUjJZR3BYVjdaVDBmN1YySThMU2xVVDltNkFuemxqZkkxcz0&ApiVersion=2.0",
      "createdDateTime": "2019-11-05T20:20:47Z",
      "eTag": "\"{40991F35-B09D-484A-96C5-4F3A931BC3AE},2\"",
      "id": "013DGZ5ZBVD6MUBHNQJJEJNRKPHKJRXQ5O",
      "lastModifiedDateTime": "2019-11-05T20:20:48Z",
      "name": "ATT_Phone.pdf",
      "webUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/Documents/TEST_A/ATT_Phone.pdf",
      "cTag": "\"c:{40991F35-B09D-484A-96C5-4F3A931BC3AE},2\"",
      "size": 29404,
      "createdBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "lastModifiedBy": {
        "user": {
          "email": "Jeffrey.Tanner@docusign.com",
          "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
          "displayName": "Jeffrey Tanner"
        }
      },
      "parentReference": {
        "driveId": "b!5P4caSKNA0q5DPV6CWwJjDszVhagtDROhQ0vSunkb9bIi-3iiqnjToxdZ5_S1_Ir",
        "driveType": "business",
        "id": "013DGZ5ZDH6VS25B544FEKJFN3FGS6B6PW",
        "path": "/drive/root:/TEST_A"
      },
      "file": {
        "mimeType": "application/pdf",
        "hashes": {
          "quickXorHash": "+YorMFfF0iEGFkqKCgb3QC47KGY="
        }
      },
      "fileSystemInfo": {
        "createdDateTime": "2019-11-05T20:20:47Z",
        "lastModifiedDateTime": "2019-11-05T20:20:48Z"
      }
    },
...
}
```

#### `get_folder_metadata.sh`

```http request
GET https://graph.microsoft.com/v1.0/me/drive/root:/${ITEM_PATH}
```

```bash
./get_folder_metadata.sh --path '/TEST_A'
```

```json
Success [HTTP status: 200]
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users('54cfd612-497b-462e-a2cd-4042c3809dde')/drive/root/$entity",
  "createdDateTime": "2019-11-05T20:19:42Z",
  "eTag": "\"{AE65F567-BC87-48E1-A495-BB29A5E0F9F6},1\"",
  "id": "013DGZ5ZDH6VS25B544FEKJFN3FGS6B6PW",
  "lastModifiedDateTime": "2019-11-05T20:19:42Z",
  "name": "TEST_A",
  "webUrl": "https://docusign2com-my.sharepoint.com/personal/jeffrey_tanner_docusign_com/Documents/TEST_A",
  "cTag": "\"c:{AE65F567-BC87-48E1-A495-BB29A5E0F9F6},0\"",
  "size": 140146,
  "createdBy": {
    "user": {
      "email": "Jeffrey.Tanner@docusign.com",
      "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
      "displayName": "Jeffrey Tanner"
    }
  },
  "lastModifiedBy": {
    "user": {
      "email": "Jeffrey.Tanner@docusign.com",
      "id": "54cfd612-497b-462e-a2cd-4042c3809dde",
      "displayName": "Jeffrey Tanner"
    }
  },
  "parentReference": {
    "driveId": "b!5P4caSKNA0q5DPV6CWwJjDszVhagtDROhQ0vSunkb9bIi-3iiqnjToxdZ5_S1_Ir",
    "driveType": "business",
    "id": "013DGZ5ZF6Y2GOVW7725BZO354PWSELRRZ",
    "path": "/drive/root:"
  },
  "fileSystemInfo": {
    "createdDateTime": "2019-11-05T20:19:42Z",
    "lastModifiedDateTime": "2019-11-05T20:19:42Z"
  },
  "folder": {
    "childCount": 2
  }
}
```