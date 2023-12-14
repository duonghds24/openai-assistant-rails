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
  - get `localhost:3000/v1/assistants/${assistant_id}` get one assistant
  - post `localhost:3000/v1/assistants` create assistant into database
  - put `localhost:3000/v1/assistants/${assistant_id}` update an assistant into database
  - get `localhost:3000/v1/assistants` list all assistants from database
  - delete `localhost:3000/v1/assistants/${assistant_id}` delete assistant both database and openai platform
  - post `localhost:3000/v1/assistants/sync` sync all the asisstant unsynced to openai platform
- Note: API authorized the user is `admin` through `pundit`. pass the header `Authorization` is `member_id` into request
## Example
```bash
curl --location 'localhost:3000/api/v1/assistants' \
--header 'Authorization: dc296c25-9754-4d27-82be-96b23202930a' \
--header 'Content-Type: application/json' \
--data '{
    "assistant": {
        "member_id": "dc296c25-9754-4d27-82be-96b23202930a",
        "model": "gpt-3.5-turbo",
        "instructions": "Assistant Instructions"
    }
}'
```
or download my postman collection `https://api.postman.com/collections/31324053-dba76c0a-60fe-4cd6-b95c-aea8da7d6618?access_key=PMAT-01HHC1J88R7R85Z01FRJMT6DQF`

## Run test
- run `rubocop --auto-correct && bundle exec rspec` to correct linter and run test
- see the result and look into `coverage/index.html` to check coverage

## Sidekiq
- grant permissions for `start_cron_job.sh`, `chmod +x start_cron_job.sh`
- run `./start_cron_job.sh` to start cron job in background or run and debug in console with `bundle exec sidekiq`
- read log in `sidekiq.log`
- edit the job in `config/sidekiq_schedule.yml`