# the_willywanka_gitfactory
Want me to build you something in git? open an issue or direct message me on slack. 😁

## Things built so far:
[1) Read the history starting from the oldest commit of a project?](https://github.com/MichaelDimmitt/the_willywanka_gitfactory#1-want-to-read-the-commit-history-of-a-project)
 - requested by Dimmitt

[2) Rebase to cleanup a pr but only changes in my branch](https://github.com/MichaelDimmitt/the_willywanka_gitfactory#2-rebase-to-cleanup-a-pr-but-only-changes-in-my-branch)
 - requested by Boyd, https://github.com/ohboyd

## Simplified Implementations:
Hopefully people think this is simpler. If not and have a better idea please open an issue and let me know a different way to implement these commands.
```bash
## download the willi wanka commands to home folder
## download the commands folder to the home directory.
cd $HOME && rm -rf willywankacommands; 
svn checkout https://github.com/MichaelDimmitt/the_willywanka_gitfactory/trunk/willywankacommands; 
cd -;

## if willywanka alias's exist remove the willywanka alias's
grep -vwE "(willywonkacommands)" ~/.bashrc > ~/.bashrc 

## add alias's that source the functions.
{ cat <<\EOF
alias initialCommit=$(source -f ~/willywonkacommands/firstCommitOnwards.sh reverseCheckout)
alias checkoutParentCommit=$(source -f ~/willywonkacommands/firstCommitOnwards.sh parentCommit)

alias rebaseCurrentBranch=$(source -f ~/willywonkacommands/rebaseCurrentBranch.sh rebaseOnlyChangesInMyBranch)
EOF } >> ~/.bashrc 

```
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
  ## If no commit number is submitted default to 1.
  ## If no compareBranch is passed, default to master.
  commitNum=${1:1};
  targetBranch=${2:master}

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

## example: reverseCheckout 1 master

```

### 2) Rebase to cleanup a pr but only changes in my branch
directions: 
<br> use `cherry` to find out how your commits are different from the branch
<br> the first line will be the oldest commit that is different
<br> use cut and awk to just give the sha of that oldes commit.
<br> rebase to the sha of the oldest command but put tilde on the end of it to get the commit before that!
<br> also that xargs thing just lets me put the piped output wherever I want to put it.
<br> let me know if these directions/this description is unclear. 😁

```bash
rebaseOnlyChangesInMyBranch() {
  ## If no compareBranch is passed, default to master
  compareBranch=${1:master}
  currentBranch=$(git branch | grep \* | cut -d ' ' -f2)
  
  sha=$(git cherry -v $1 | 
    sed -n 1p | 
    cut -c 2- | 
    awk '{print $1;}')

  if ! [ -z "$sha" ]; then
    passValidResultToRebase $compareBranch $currentBranch
  else
    echo "The command did nothing, you need to pass a compare branch as an argument."
    echo "try these commands in your terminal as an example:" 
    echo "rebaseOnlyChangesInMyBranch dev;"
    echo "rebaseOnlyChangesInMyBranch master;"
  fi
}
passValidResultToRebase() {
  currentBranch=$2
  compareBranch=$1
  echo ;
  echo 'Think of this command as the rebase before the rebase!';
  echo "Current branch:                 $currentBranch";  
  echo "Branch  being compared:         $compareBranch";
  echo ;
  echo "Paste the below command to rebase/(prep) commits for your current branch: $currentBranch";
  echo "without worrying about new commits developers added to $compareBranch branch in the interim.";
  echo "git rebase -i $sha~";
}

## example: rebaseOnlyChangesInMyBranch master

```