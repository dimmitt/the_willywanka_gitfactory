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