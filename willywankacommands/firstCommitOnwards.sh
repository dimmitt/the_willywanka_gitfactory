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