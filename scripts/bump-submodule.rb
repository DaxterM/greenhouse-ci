#!/usr/bin/env ruby

require_relative "./submodule-utils.rb"

Utils.trust_github
sha = Utils.find_repo_sha("submodule")
Dir.chdir("repo") do
  Utils.bump_submodule(ENV.fetch("SUBMODULE"),sha)

  Utils.git_config
  puts "----- Updating submodules"
  if Utils.submodules_changed?
    Utils.commit
  else
    puts "----- Nothing to commit"
  end
end

Utils.sh 'git clone ./repo ./bumped-repo'
