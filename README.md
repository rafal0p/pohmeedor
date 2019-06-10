# Pohmeedor

Do you use Pomodoro Technique on the daily basis? Do you work remotely? Do you want to inform all members of your team when you are doing creative work? If yes - this API can help you!

## Usage

API is deployed on `https://pohmeedor.herokuapp.com`

* Adding timer: `POST /api/timers`:
```json
{
  "id": "9d8f128f-e6ec-413d-b4d0-31fa948bab2b",
  "duration": 60000,
  "name": "my awesome timer"
}
```
`duration` is in milliseconds, you are responsible for generating UUID
* Getting timer: `GET /api/timers/{id}`
* Getting all timers: `GET /api/timers`

For unknown reason database connection sometimes break for couple of seconds. Until the issue is resolved best workaround is to retry after HTTP 500 (even couple of times).