## GET /api/v1/photo.json
All photos of user.

### Example

#### Request
```
GET /api/v1/photo.json?access_token=0c5eafe698e53c927e50f011373ef7f98afe149595a8bb4f7a63d63484301019 HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 0
Content-Type: application/x-www-form-urlencoded
Host: www.example.com
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 503
Content-Type: application/json
ETag: "e4a49c0599929adcd927d94c74cc8e10"
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: 6627d477-3c95-418e-887f-63d8539fb72d
X-Runtime: 0.004974
X-UA-Compatible: chrome=1
X-XSS-Protection: 1; mode=block

[
  {
    "id": 2,
    "user_id": 1,
    "platform_id": "101",
    "provider": "hoge",
    "format": "jpg",
    "message": null,
    "width": null,
    "height": null,
    "posted_at": "2014-02-01T06:48:28.754Z",
    "optional": null,
    "created_at": "2014-02-01T06:48:28.755Z",
    "updated_at": "2014-02-01T06:48:28.755Z"
  },
  {
    "id": 1,
    "user_id": 1,
    "platform_id": "100",
    "provider": "hoge",
    "format": "jpg",
    "message": null,
    "width": null,
    "height": null,
    "posted_at": "2014-01-31T06:48:28.751Z",
    "optional": null,
    "created_at": "2014-02-01T06:48:28.753Z",
    "updated_at": "2014-02-01T06:48:28.753Z"
  }
]
```
