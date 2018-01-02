# DBM

## Instructions

1. Precompile assets

		RAILS_ENV=production bundle exec rake assets:precompile

2. Reset database

		rake db:drop db:create db:migrate db:seed:default db:seed 
		
		rake db:drop db:create db:migrate db:seed:default db:seed:development RAILS_ENV=production

3. Translation tool

		rake tolk:sync

		rake tolk:import