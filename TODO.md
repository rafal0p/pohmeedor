TODO:
* deploy somewhere (heroku, gigalixir)
* cors
* ssl (mixed content)
* for GET return duration and percentage, not start_time
* mock utc_now in tests instead of checking 2 seconds diff
* make Timer.name optional
* unique id constraint violation should return existing entity (based on that views can decide if reinsert with different id or it's a case of double POST and can be safely ignored)
* get timer by name
* document API by swagger
* list of only active timers
* paging on timers list
* each name belongs to someone (cookie based)
* sign in / sign up in order to be able to clear cookies and still be yourself
* group users to teams
* non-public timer (for team-members only)

DONE:
* generate start_time server-side
* get timer by link (non human readable is enough)
* once added timer cannot be modified
* timers list (could grow looooong)
* generate id by client

DECIDED:
* start_time must be generated server-side. who knows what clock skew clients have.