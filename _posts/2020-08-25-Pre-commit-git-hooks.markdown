---
layout: post
title:  "Running a Git client-side pre-commit hook"
date:   2020-08-25 07:00:00 +0100
---
# How to run a test before every git commit

Summary:
- Configure a git client-side `prepare-commit-msg` hook to run a test before every commit.
- Setup `.gitconfig` file in the root of the repository and set `hooksPath = git_hooks`.
- Write a bash script inside `git_hooks\prepare-commit-msg` that runs your tests before a commit.
- You can distribute the hooks in the repository but you **cannot** enforce the (client-side) hooks use.

[example-code] is available.

## Running a Git client-side pre-commit hook

Git hooks allow you to hook into the pull/commit/push process that git is built around. A hook is useful if you want to extend or customise the behaviour of your repository. There are two types of hooks, server-side commits and client-side commits. Server-side hooks live on a git server (i.e. somewhere people push to, like a centralised github server). Client-side hooks live on each individual contributors development machine.

Server-side hooks are a way you can enforce certain behaviours on the server. I'm not going to talk about them here. Instead, I'm going to look at client-side hooks.

Have you ever wanted to run some sort of check on the code you are about to commit? You can do this with a client-side hook. However, one issue with client-side hooks is that they are not versioned in the git repository. I used to think this prohibited 'distrbution' of the client-side git hooks with the repository. Which sucks. Because, lets say you introduce a new developer to your repo, perhaps you'd like them to run the same checks as you do, they way you do. Traditionally, that's not been possible with client-side hooks. However, there is a way (since git version 2.9). You need to configure the 'hooksPath'.

## Setting up client-side hooks so everyone runs them

In the root of your git repo, add the file `.gitconfig` with this content:

```
[core]
    hooksPath = git_hooks
```

When the repository is cloned, it points git to run hooks from the `git_hooks` subdirectory. Normally, git hooks are stored in `.git/hooks`, and that `.git/` directory is not stored in the version-control (thus prohibiting distribution with the source-code). But with the (new as of git 2.9) `hooksPath` option, you can instead point to another directory in the repository that does store the hooks.

However, git will _not_ use the `.gitconfig` automatically. Apparently it's a security issue (see [stackoverflow-store-gitconfig]). Instead, the user who has cloned the repository must explicitly tell git to use the `.gitconfig`.  They only need to run this command once. I have it as a [setup_repo.sh] They can do that with this command

```bash
git config --local include.path '../.gitconfig'
```

This is an essential detail, if you want the distributed client-side hooks to run.

## Running something that changes the commit message

Now you need to write a hook inside the `git_hooks` directory. I am going to write a hook that runs just before the user is asked to input a commit message. The hook is just a bash shell (though it does not have .sh as the filename suffix). If the shell exists with 0, the commit is allowed. Any other exit code blocks the commit. That's how git hooks work.

In your git repo, inside 'git_hooks/', create a 'prepare-commit-msg' file with the contents

{% highlight bash %}
#!/bin/sh
# Providing an environment variable override is helpful, if users need to by-pass your hook for some reason.
# Set SKIP_HOOK environment variable if you don't want pre-commit tests.
# Example:
# > $env:SKIP_HOOK=1
# > git commit
# > $env:SKIP_HOOK=0
# The next 3 parameters are the parameters git supplies to the prepare-commit-msg hook. Different hooks get
# different parameters.
COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3

if [[ "$SKIP_HOOK" == 1 ]]; then
    printf "\nWarning: SKIP_HOOK set, skipping pre-commit hook!\n"
    exit 0
fi

# Run tests when this file changes.
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
printf "\nRunning pre-commit tests Pester tests are passing at $SCRIPTPATH...\n"
# Check Pester tests are passing.
.\run_tests.sh
if [[ $? != 0 ]]; then
    printf "\nERROR: detected test failures. Please fix before commiting changes."
    exit 1
fi
printf "\nPre-commits tests have passed, continuing with commit.\n"
echo "[Pre-commit tests ran at $(date)]" >> "$COMMIT_MSG_FILE"

{% endhighlight %}

## Outcome

- If the tests pass, the user will be offered a default commit message that includes the 'Pre-commit tests ran ...' message. You can see this in the commit [956d3fd00d] in the example repository.
- If the tests fail, the commit is blocked with the error message.

## References

- [example-code]
- [setup_repo.sh]
- [956d3fd00d]
- [Git-SCM-Book-Git-Hooks]
- [git-hooks-practical-users]
- [stackoverflow-core-hookspath]
- [stackoverflow-store-gitconfig]

[example-code]: https://github.com/ddmee/git-hooks/tree/master/git_hooks
[setup_repo.sh]: https://github.com/ddmee/git-hooks/blob/master/setup_repo.sh
[956d3fd00d]: https://github.com/ddmee/git-hooks/commit/956d3fd00d9ba0fb9195796b7fc2aea402d848be
[Git-SCM-Book-Git-Hooks]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
[git-hooks-practical-users]: https://www.tygertec.com/git-hooks-practical-uses-windows/
[stackoverflow-core-hookspath]: https://stackoverflow.com/a/39338979
[stackoverflow-store-gitconfig]: https://stackoverflow.com/questions/18329621/how-to-store-a-git-config-as-part-of-the-repository
