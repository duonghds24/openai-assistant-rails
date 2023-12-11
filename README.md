# Openai-assistant-rails

## Setup
- copy env sample `cp .env.sample .env` then correct the require field
- go into `database.yml` and correct your database config
- run `rails db:create` to init database
- run `rails db:migrate` to setup tables
- then run `rails db:seed` to generate some seed data (`orgnisation` and `member`)
- finally, run `rails s` to start the server

## API
- on default, the server address is `localhost:3000`
- supported api:
  - get `localhost:3000/assistants/${assistant_id}` get one assistant
  - post `localhost:3000/assistants` create assistant into database
  - put `localhost:3000/assistants/${assistant_id}` update an assistant into database
  - get `localhost:3000/assistants` list all assistants from database
  - delete `localhost:3000/assistants/${assistant_id}` delete assistant both database and openai platform
  - post `localhost:3000/assistants/sync` sync all the asisstant unsynced to openai platform

## Example
```bash
curl --location 'localhost:3000/assistants' \
--header 'Content-Type: application/json' \
--data '{
    "member_id": "678990c0-4397-4b69-84a8-a21ff11dd3b8",
    "model": "gpt-3.5-turbo",
    "instructions": "Assistant Instructions"
}'
```
or download my postman collection `https://api.postman.com/collections/31324053-dba76c0a-60fe-4cd6-b95c-aea8da7d6618?access_key=PMAT-01HHC1J88R7R85Z01FRJMT6DQF`

## Run test
- run `rubocop --auto-correct` to run test
- see the result and look into `coverage/index.html` to check coverage