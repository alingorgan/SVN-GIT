SVN-GIT
=======

## What's this?

This is a bash script which saves you the trouble of merging to git from SVN.
This script was written to be used either in the OSX terminal or with OSX Server and XCode for Continuous Integration purposes.

## It's purpose

Long story short, OSX Server doesn't play well with pure SVN repos, and if neither SVN over ssh or merging to git are feasible options, then you're just have to do it the hard way.

There are some tools out there, which help you keep SVN and Git in sync. But if you really want to control the process and make a one way only communication, from SVN to Git, then you'll have to come up with your own script to do that. Or just use mine, at least as a reference point.

## Use it within you CI process or GIT merge

These script can also be used as a pre/post script action for various xcode phases(build, test, archive) of a scheme which an XCode bot runs on. A bit confusing, right? In other words, to be used in the process of automating builds within the CI process, with the help of OSX Server, XCode and bots.
```bash
#
# This script is used to pull data from the SVN and push it to git
#

CHECKOUT_DIR=your_temp_checkout_dir
SVN_URL=your_svn_repo_url
LOCAL_GIT_URL=your_git_url

#
# DO NOT EDIT BELOW THIS LINE
#


cd ${CHECKOUT_DIR}

# remove any old data from the local git
GIT_CHECKOUT_DIR=tempgit
echo "Removing old data from ${GIT_CHECKOUT_DIR}"
rm -rf ${GIT_CHECKOUT_DIR}

# get the latest revision from the local git
echo "Cloning ${LOCAL_GIT_URL} into ${GIT_CHECKOUT_DIR}"
mkdir ${GIT_CHECKOUT_DIR}
git clone ${LOCAL_GIT_URL} ${GIT_CHECKOUT_DIR}

# if we’re not always cloning the git repo, for getting the latest data we should
# git reset --hard
# git clean -fd
# git pull

# remove any old data from SVN
SVN_CHECKOUT_DIR=tempsvn
echo "Removing old data from ${SVN_CHECKOUT_DIR}"
rm -rf ${SVN_CHECKOUT_DIR}
mkdir ${SVN_CHECKOUT_DIR}

# get the latest revision from the SVN repo
echo "Cloning ${SVN_URL} into ${SVN_CHECKOUT_DIR}"
git svn clone ${SVN_URL} ${SVN_CHECKOUT_DIR}

# if we’re not always cloning the svn, for getting the latest data we should
# git svn rebase
# git svn fetch

# copy the latest SVN data into the git clone directory 
echo "Copying new data into ${GIT_CHECKOUT_DIR}"
cd ${SVN_CHECKOUT_DIR}
cp -rf * ../${GIT_CHECKOUT_DIR}

# check for any changes and commit
echo "Pulling from the local git into ${GIT_CHECKOUT_DIR}"
cd ../${GIT_CHECKOUT_DIR}
git pull
git status

# It might be wise to check for the “index.lock” and remove it
rm -f ${GIT_CHECKOUT_DIR}/.git/index.lock

echo "Committing and pushing changes to the local git repo’s master"
# look also for newly added files
git add -A

# commit changes to the master branch
git commit -a -m "Updated from SVN"
git push ${LOCAL_GIT_URL} master

#remove temp data
echo "Removing temporary data"
cd ..
rm -rf ${GIT_CHECKOUT_DIR}
rm -rf ${SVN_CHECKOUT_DIR}
```



