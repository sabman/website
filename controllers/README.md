# login flow

## /login -> /auth/github

- remember referer for returnTo behavior
- sign in via github, redirects to /people/me

## /auth/facebook

- remember referer for returnTo behavior
- sign in via facebook, redirects to /people/me

## /auth/twitter

- Do we want to add Twitter as an authentication mechanism?

## /people/me

- if on a team
  - redirects to /people/show of the logged in person
- if invited to a team (based on session invite code [see below])
  - joins the team
    - deletes the invite
    - clears out session invite code
- if created a team (still not on it, and still no confirmed invite)
  - redirect to the created team
- else
  - redirects to /teams/new

## /teams/new

- create a team
  - name
  - emails -> invites

- invite links go to /teams/:id?invite=key

## /teams/:id?invite=:code

- given an invitation, saves to a session invite code. will override the
  session invite code if another invite code is given, but won't null it out.

- shows a team and its members

- if on the team
  - shows you more cool stuff

- if invited (based on session invite code)
  - big button to accept invitation to /auth/github
