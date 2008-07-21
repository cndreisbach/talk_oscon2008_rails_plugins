#!/bin/sh
rails rails_app -d sqlite3
cd rails_app
rake rails:freeze:gems
script/plugin install git://github.com/mbleigh/acts-as-taggable-on.git
script/plugin install git://github.com/technoweenie/acts_as_paranoid.git
script/plugin install http://elitists.textdriven.com/svn/plugins/acts_as_state_machine/trunk/
script/plugin install git://github.com/technoweenie/acts_as_versioned.git
script/plugin install git://github.com/vigetlabs/bloget.git
script/plugin install git://github.com/rails/exception_notification.git
script/plugin install git://github.com/crnixon/foreign_key_migrations.git
script/plugin install git://github.com/aaronchi/jrails.git
svn export http://pseudocursors.rubyforge.org/svn/tags/stable/ vendor/plugins/pseudocursors
script/plugin install git://github.com/jnewland/resource_this.git
script/plugin install git://github.com/technoweenie/restful-authentication.git
script/plugin install git://github.com/thoughtbot/shoulda.git
script/plugin install git://github.com/rails/ssl_requirement.git
script/plugin install http://pmade.com/svn/oss/stickies/trunk
script/generate plugin test_plugin
cp ../webmate script/webmate