#!/bin/bash
### Generate token
docker exec -ti gitlab-ce gitlab-rails runner "token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api','admin_mode'], name: 'Generated token', expires_at: 365.days.from_now); token.set_token('this-is-my-secret-token123'); token.save!"


TOKEN=this-is-my-secret-token123
GITLAB_URL=https://localhost:8443

## Create Project
curl -k --request POST --header "PRIVATE-TOKEN: $TOKEN" \
        --header "Content-Type: application/json" \
        --data '{"name": "dev-workspace", "description": "dev-workspace", "path": "dev-workspace"}' \
        --url "$GITLAB_URL/api/v4/projects/" -s | jq .

## Create users
for user in back_dev front_dev; do
   curl -k --request POST --header "PRIVATE-TOKEN: $TOKEN" \
         --header "Content-Type: application/json" \
         --data '{"email": "'$user'@email.com", "name": "'$user'", "username": "'$user'","password":"Abcd1234@@@"}' \
         --url "$GITLAB_URL/api/v4/users/" -s | jq .
done

## Create GROUPS
for group in backend frontend; do
   curl -k --request POST --header "PRIVATE-TOKEN: $TOKEN" \
         --header "Content-Type: application/json" \
         --data '{"name": "'$group'", "path": "'$group'"}' \
         --url "$GITLAB_URL/api/v4/groups" -s | jq .
done

## Share project with group
for group in backend frontend; do
   GROUP_ID=$(curl -k --request GET --header "PRIVATE-TOKEN: $TOKEN" --header "Content-Type: application/json" --url "$GITLAB_URL/api/v4/groups" -s | jq '.[] | select(.name =="'$group'") | .id')
   curl -k --request POST --header "PRIVATE-TOKEN: $TOKEN" \
         --header "Content-Type: application/json" \
         --data '{"group_access": '40', "group_id": "'$GROUP_ID'"}' \
         --url "$GITLAB_URL/api/v4/projects/1/share" -s | jq .
done

