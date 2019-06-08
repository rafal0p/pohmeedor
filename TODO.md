TODO:
* generate id by client
* unique id constraint violation should return existing entity (based on that views can decide if reinsert with different id or it's a case of double POST and can be safely ignored)
* start_time can now contain datetime without timezone. Enforce either full information, or accept epoch.
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
