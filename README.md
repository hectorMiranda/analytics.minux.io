#A web based analytics tool

A live version for this app can be found [here](https://marcetuxexplorer.herokuapp.com/)


## Getting started

To run this web application locally you will need a locally installed version of Ruby 2.3.1, Rubygems, Bundler and Rails 5+, Postgresql and Redis

Follow these steps to run the app locally:


###1. Install dependencies

Running the command below will genera a new Gemfile.lock
```
bundle install
```
Now create the database, postgresql is required.
```
rails db:create
```

###2. Install redis

```
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
make install
```

###4. Set up environment variables for the Twitter API
API secrets are being read from environment variables
Add the following to your ~/.bashrc file

```
export REDIS_URL="redis://yourredisurl:18459"
export TWITTER_CONSUMER_KEY_API="24WGsVF..."
export TWITTER_API_SECRET="7k428br1x...."
export TWITTER_OAUTH_ACCESS_TOKEN="17267...."
export TWITTER_OAUTH_ACCESS_TOKEN_SECRET="AEIPtSI8zi...."
```

##Application Design

To the protect the application from the general public I have used the devise gem, which is a flexible authentication solution based on Warden. The application only uses an User to support the devise functionality, below is the model definition:

```
create_table "users", force: :cascade do |t|
  t.string   "email",                  default: "", null: false
  t.string   "encrypted_password",     default: "", null: false
  t.string   "reset_password_token"
  t.datetime "reset_password_sent_at"
  t.datetime "remember_created_at"
  t.integer  "sign_in_count",          default: 0,  null: false
  t.datetime "current_sign_in_at"
  t.datetime "last_sign_in_at"
  t.inet     "current_sign_in_ip"
  t.inet     "last_sign_in_ip"
  t.datetime "created_at",                          null: false
  t.datetime "updated_at",                          null: false
  t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
end
```

To interact with the Twitter API I choose the Twitter gem as it provides the boilerplate around interacting with the Twitter API. The TwitterClient class implements the caching logic and the handle of the REST requests.

The twitter gem raise Twitter::Error if it can’t connect to the server, if the credentials are not working or if the handle do not exist. For all those cases I decided to return empty hashes I’m opting for a handle_errors function that takes a block. If the block raises an exception, handle_timeouts will catch the exception and return an empty hash.

I'm using Redis as my cache server, all of the caching logic is in handle_caching(options) and cache_key(options), the latter of which builds a unique key to store the cached response based on a given Twitter handle.

handle_caching(options) checks for the existence of a key and returns the payload if available. Otherwise, it yields to the block passed in and stores the result in Redis.


##Testing

To run the test

```
rails spec
```

The following gems are being used for testing support:

* rpsec: is the testing framework that I use for testing
* factory_girl: allow us to code smart database fixtures in ruby, in things called factories
* capybara: lets helps you test web applications by simulating how a real user would interact with your app.
* guard: makes rerunning tests a snap, by watching the filesystem for when you save files and triggering events automatically
* webmock: locks down the test environment from talking to the internet
* vcr: record the test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests
* rspec-rails: is the rails integration with rspec, which depends upon rspec itself.
factory_girl_rails: is the rails integration with factory_girl.
* guard-rspec: is rspec integration with guard
* spring-commands-rspec: lets you integrate rspec with spring, which means that your tests will run much faster.
