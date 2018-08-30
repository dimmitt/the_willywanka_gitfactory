# the_willywanka_gitfactory
Want me to build you something in git? open an issue or direct message me on slack. 😁

## Things built so far:

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
commitNum=
targetBranch=
reverseCheckout() {   
  commitNum=$1;
  targetBranch=$2

  git checkout $targetBranch; 
  git rev-list --reverse HEAD | 
    sed -n ${commitNum}p | 
    xargs -I {} git checkout {}; 
}

## Then you can check out to the next parent easy!
parentCommit() {
  commitNum=$(($commitNum+1))
  git checkout $targetBranch; 
  git rev-list --reverse HEAD | 
    sed -n ${commitNum}p | 
    xargs -I {} git checkout {}; 
} ## note if you want to check out to the child its simply git checkout HEAD~

reverseCheckout 1 master
```
