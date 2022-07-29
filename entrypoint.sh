#!/bin/sh -l
set -e

echo "path-to-pom                     : $1"
echo "path-to-p2-repo-created-by-maven: $2"
echo "path-to-p2-repo-target          : $3"
echo "target-branch-name              : $4"
echo "commit-message                  : $5"
echo "git-user                        : $6"
echo "git-email                       : $7"

# save current github actor for push later
# why? it will otherwise be replaced w/ git-user used for the commit
github_user=${GITHUB_ACTOR}

echo "Cleaning up update site folder..."
rm -r $3
echo "Configuring author for commit..."
git config user.name "'$6'"
git config user.email "'$7'"
echo "Checking out target branch (creating if necessary)..."
git checkout -B $4
echo "Replacing updatesite..."
git rm -r $3
mkdir -p $3
mv  -v $2/repository/* $3
git add -A
echo "Committing updatesite..."
git commit -m "$5"
echo "Pushing commit..."

# push
[ -z "'$8'" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};
remote_repo="https://${github_user}:$8@github.com/${GITHUB_REPOSITORY}.git"
echo remote repo is ${remote_repo}
git push "${remote_repo}" HEAD:$4 --force


