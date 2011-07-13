# login flow

## /auth/github

- sign in via github, redirects to /people/me

## /people/me

- if on a team
  - renders /people/show with the logged in person
- if invited to a team (based on session invite code [see below])
  - joins the team
    - deletes the invite
    - clears out session invite code
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
