#!/usr/bin/env ruby

require_relative "./submodule-utils.rb"

def bump_downstream(submodule, sha)
  Dir.chdir("downstream-release") do
    Dir.chdir(submodule) do
      system("git remote update")
      system("git checkout #{sha.strip}")
    end
  end
end

SUBMODULES = ENV.fetch("SUBMODULES").split(",")
SUBMODULES.each do |submodule|
  downstream_sha = Utils.find_sha("downstream-release", submodule)
  upstream_sha = Utils.find_sha("upstream-release", submodule)
  if upstream_sha !=  downstream_sha
    bump_downstream(submodule, upstream_sha)
  end
end
Utils.trust_github
Dir.chdir("downstream-release") do
  Utils.git_config
  puts "----- Updating submodules"
  if Utils.submodules_changed?
    Utils.commit
  else
    puts "----- Nothing to commit"
  end
end

Utils.sh 'git clone ./downstream-release ./bumped-downstream-release'
