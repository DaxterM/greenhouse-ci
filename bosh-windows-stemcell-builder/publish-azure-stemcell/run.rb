#!/usr/bin/env ruby

require_relative '../../../stemcell-builder/lib/exec_command'

Dir.chdir "stemcell-builder" do
  exec_command("bundle install")
  exec_command("rake publish:azure")
end