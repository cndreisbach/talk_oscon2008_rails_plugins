#!/bin/sh
rails rails_app -d sqlite3
cd rails_app
script/plugin install git://github.com/mbleigh/acts-as-taggable-on.git
script/plugin install http://svn.techno-weenie.net/projects/plugins/acts_as_paranoid/
script/plugin install http://elitists.textdriven.com/svn/plugins/acts_as_state_machine/trunk/
script/plugin install http://svn.techno-weenie.net/projects/plugins/acts_as_versioned/
script/plugin install http://svn.extendviget.com/lab/bloget/trunk/
script/plugin install http://svn.rubyonrails.org/rails/plugins/exception_notification/
script/plugin install git://github.com/vigetlabs/foreign_key_migrations.git
script/plugin install http://ennerchi.googlecode.com/svn/trunk/plugins/jrails
script/plugin install git://github.com/jnewland/resource_this.git
script/plugin install git://github.com/technoweenie/restful-authentication.git
script/plugin install git://github.com/thoughtbot/shoulda.git
script/plugin install http://svn.rubyonrails.org/rails/plugins/ssl_requirement/
script/plugin install http://pmade.com/svn/oss/stickies/trunk
script/generate plugin test_plugin