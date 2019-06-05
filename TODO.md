TODO:
* start_time can now contain datetime without timezone. Enforce either full information, or accept epoch.
* generate id by client
* cors
* ssl (mixed content)
* deploy somewhere (heroku, gigalixir)
* get timer by name
* document API by swagger
* list of only active timers
* paging on timers list
* each name belongs to someone (cookie based)
* sign in / sign up in order to be able to clear cookies and still be yourself
* group users to teams
* non-public timer (for team-members only)

TO DECIDE:
* should start_time be posted or inserted server-side?

DONE:
* get timer by link (non human readable is enough)
* once added timer cannot be modified
* timers list (could grow looooong)
