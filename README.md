[![Build Status](https://travis-ci.org/mydrive/capistrano-detect-migrations.png)](https://travis-ci.org/mydrive/capistrano-detect-migrations)
Capistrano Detect Migrations
============================
This plugin to Capistrano leverages the capistrano-deploytags plugin
to have Git identify Rails migrations before you deploy code to any
remote systems. This is handy in an environment where you deploy
often and want to release the newest code but only if it's not
complicated by running migrations. You may also just want a list
of migrations that will need to be run before deploying and this
plugin makes that easy.

What It Does
------------
It makes it automatic to detect pending migrations in any environment.
You won't be surprised by deploying code that doesn't work until
the migrations have been run.  If I were to issue the command:

`cap production deploy`

This would compare the current changes with the most recent deployment
tag for the environment (here: production) and look for any migrations
that have appeared or changed in the code since the last run. You
are then presented with a prompt allowing you to cancel the deployment
after reviewing the list of migrations.

Usage
-----
capistrano-detect-migrations is available on
[rubygems.org](https://rubygems.org/gems/capistrano-detect-migrations).
You can install it from there with:

`gem install capistrano-detect-migrations`

If you use Bundler, be sure to add the gem to your Gemfile.
In your Capistrano `config/deploy.rb` you should add:

`require 'capistrano-detect-migrations'`

This will create one task that hooks into one of the tasks installed
by the capistrano-deploytags gem. You can always review tasks that
have been added by running `cap -T` from your application directory.

Credits
-------
This software was written by [Karl Matthias](https://github.com/relistan)
with help from [Gavin Heavyside](https://github.com/gavinheavyside) and the
support of [MyDrive Solutions Limited](http://mydrivesolutions.com).

License
-------
This plugin is released under the BSD two clause license which is
available in both the Ruby Gem and the source repository.
