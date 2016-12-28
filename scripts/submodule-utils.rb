class Utils
  def self.sh(cmd)
    puts cmd
    system(cmd) || exit(1)
  end

  def self.git_config
    puts "----- Set git identity"
    sh 'git config user.email "cf-netgarden-eng@pivotal.io"'
    sh 'git config user.name "CI (Automated)"'
  end

  def self.submodules_changed?
    !system("git diff --exit-code")
  end

  def self.trust_github
    system("mkdir ~/.ssh")
    system("ssh-keyscan github.com >> ~/.ssh/known_hosts")
  end

  def self.find_sha(release, submodule)
    Dir.chdir(release) do
      `git rev-parse :#{submodule}`.chomp
    end
  end

  def self.find_repo_sha(release)
    Dir.chdir(release) do
      `git rev-list --max-count=1 HEAD`.chomp
    end
  end

  def self.bump_submodule(submodule,sha)
    Dir.chdir(submodule) do
      system("git remote update")
      system("git checkout #{sha.strip}")
    end
  end

  def self.commit
    sh 'git add -A'
    sh %{git diff --cached --submodule | ruby -e "puts 'Bump submodules'; puts; puts STDIN.read" | git commit --file -}
    puts "----- DEBUG: show the commit we just created"
    sh 'git --no-pager show HEAD'
  end
end
