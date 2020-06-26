# Push P2 Repo Docker Action
This action commits and pushes a p2 repository (aka. p2 update site) to the Github repository.

The action expects a p2 repository to be available.
-  Hint: It can be built w/ e.g. Maven:
-  See https://www.vogella.com/tutorials/EclipseTycho/article.html

In detail, the action performs the following steps:
* Checkout (create if necessary) the target branch
* Commit the update site to that branch
* Force-Push the commit

## Example usage
```
uses: ingomohr/push-p2-repo-action@v1
with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
  path-to-p2-repo-created-by-maven: 'releng-updatesite/target'
  path-to-p2-repo-target: 'updatesite'
```

## Example Workflow
This is an example for a workflow that performs a Maven build and commits and pushes the update site
built w/ Maven to a branch with name "builds-{original-branch-name}".
```
name: Build and Push P2 Updatesite

on: [push, pull_request]

jobs:
  build:

    runs-on: ubuntu-latest


    steps:
      - name: Fetch branch name
        run:
          echo "##[set-output name=branch;]$(echo ${GITHUB_REF#refs/heads/})"
        id: fetch_branch
      - uses: actions/checkout@v2
      - name: Set up JDK 1.11
        uses: actions/setup-java@v1
        with:
          java-version: 1.11
      - name: Build with Maven
        run: mvn -B package --file pom.xml
      - name: Push Updatesite
        uses: ingomohr/push-p2-repo-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          path-to-p2-repo-created-by-maven: 'releng-updatesite/target'
          path-to-p2-repo-target: 'updatesite'
          commit-message: 'add new updatesite'
          target-branch-name: builds-${{ steps.fetch_branch.outputs.branch }}
```


## Inputs

### Required
#### github-token
- the token for the repo.
- Can be passed in using ``${{ secrets.GITHUB_TOKEN }}``.

### Optional
#### path-to-p2-repo-created-by-maven
- the path to where the p2 update site has been built by Maven - i.e. where to find the p2 update site to be pushed
- default: ``releng-updatesite/target``

#### path-to-p2-repo-target
- the path to where the p2 update site is supposed to be moved in the Github repo
- default: ``updatesite``

#### path-to-pom
- the path to the ``pom.xml`` to build.
- Default ``pom.xml`` - supposing there is a root pom.

#### target-branch-name
- the name of the branch to push the p2 update site to
- default: ``builds-master``

#### commit-message
- description: the commit-message to use for the commit
- default: ``"github-action: add/replace updatesite"``

#### git-user
- the user to be configured for the commit
- default: ``GitHub Action``

#### git-email
- the email of the user to be configured for the commit
- default: ``github-action@users.noreply.github.com``

## Outputs
*There are no outputs for this action.*
