LRS (Learning Record Store)
=============================

Open source Ruby on Rails based Learning Record Store (http://en.wikipedia.org/wiki/Learning_Record_Store, http://tincanapi.com/learning-record-store/) which is compatible with TinCanAPI (http://tincanapi.com/) and Experience API (http://www.adlnet.gov/tla/experience-api).


*************************************************************************************

Current Status
--------------

### Setup
- `bundle install`
- `brew install mongodb`
- `brew services start mongodb`
- `cp config/mongoid.yml.template config/mongoid.yml`
- `rake db:setup`
- `rails s`

### Deps

You need mongodb running so install via brew and start it as a service with
`brew services start mongodb`

You can stop it again with `brew services stop mongodb`

