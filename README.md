# the_willywanka_gitfactory
Want me to build you something in git? open an issue or direct message me on slack. 😁

## Things built so far:
[1) Want to read the commit history of a project?](https://github.com/MichaelDimmitt/the_willywanka_gitfactory#1-want-to-read-the-commit-history-of-a-project)
 - requested by Dimmitt

[2) Rebase to cleanup a pr but only changes in my branch](https://github.com/MichaelDimmitt/the_willywanka_gitfactory#2-rebase-to-cleanup-a-pr-but-only-changes-in-my-branch)
 - requested by Boyd, https://github.com/ohboyd
## The Actual Implementations Are Below:

### 1) Want to read the commit history of a project?
directions: 
<br> list commits in reverse.
<br> checkout to a specific commit based on a number.
```bash
## In the future this commit could store the HEAD commit
## And check to ensure we are in the correct project/branch-location
## If the criteria is not met it will 
## echo: nothing done use reverseCheckout
## echo: and then parentCommit should start working.
## Initialize these globals to empty.
headCommitBeforeOperations=
commitNum=
targetBranch=
reverseCheckout() {   
  commitNum=$1;
  targetBranch=$2

  git checkout $targetBranch; 
  headCommitBeforeOperations=$(git rev-parse HEAD)
  echo "well looks like we have $headCommitBeforeOperations"

  git rev-list --reverse HEAD | 
    sed -n ${commitNum}p | 
    xargs -I {} git checkout {}; 
}

## Then you can check out to the next parent easy!
parentCommit() {
  git checkout $targetBranch
  if [ "$headCommitBeforeOperations" == $(git rev-parse HEAD) ]; then
    echo tellMeYourParentsName
  else 
    echo 'dont trust strangers!'
    echo 'let me explain: for this command - parentCommit'
    echo 'we are not in the correct project/branch-location'
    echo 'reinstantiate the location with command:'
    echo 'reverseCheckout <targetBranch> <commit num to checkout>'
  fi

} ## note if you want to check out to the child its simply git checkout HEAD~
tellMeYourParentsName() {
  headCommitBeforeOperations=$(git rev-parse HEAD)
  commitNum=$(($commitNum+1))
  git checkout $targetBranch; 
  git rev-list --reverse HEAD | 
    sed -n ${commitNum}p | 
    xargs -I {} git checkout {}; 
}

reverseCheckout 1 master
```

### 2) Rebase to cleanup a pr but only changes in my branch
** Coming Soon **