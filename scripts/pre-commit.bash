#!/usr/bin/env sh

# This hook has a focus on portability.
# This hook will attempt to setup your environment before running checks.
#
# If you would like `pre-commit` to get out of your way and you are comfortable
# setting up your own environment, you can install the manual hook using:
#
#     pre-commit install --manual
#

# This is a work-around to get GitHub for Mac to be able to run `node` commands
# https://stackoverflow.com/questions/12881975/git-pre-commit-hook-failing-in-github-for-mac-works-on-command-line
PATH=$PATH:/usr/local/bin:/usr/local/sbin


cmd=`git config pre-commit.ruby 2>/dev/null`
if   test -n "${cmd}"
then true
elif which rvm   >/dev/null 2>/dev/null
then cmd="rvm default do ruby"
elif which rbenv >/dev/null 2>/dev/null
then cmd="rbenv exec ruby"
else cmd="ruby"
fi

export rvm_silence_path_mismatch_check_flag=1

${cmd} -rrubygems -e '
  begin
    require "pre-commit"
    true
  rescue LoadError => e
    $stderr.puts <<-MESSAGE
pre-commit: WARNING: Skipping checks because: #{e}
pre-commit: Did you set your Ruby version?
MESSAGE
    false
  end and PreCommit.run
'

echo "Running pre-commit hooks"

./scripts/run-rubocop.bash

# $? stores exit value of the last command
if [ $? -ne 0 ]; then
 echo "One or more pre-commit checks failed. Aborting commit."
 exit 1
fi
