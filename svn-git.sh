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

# copying this way will prevent the copy of hidden .git directories or .gitignore. 
# so every checkout preserves it's reference to it's own origin.
cp -rf * ../${GIT_CHECKOUT_DIR}

# check for any changes and commit
echo "Pulling from the local git into ${GIT_CHECKOUT_DIR}"
cd ../${GIT_CHECKOUT_DIR}
git pull
git status

# It might be wise to check for the “index.lock” and remove it
rm -f ${GIT_CHECKOUT_DIR}/.git/index.lock

echo "Committing and pushing changes to the local git repo’s master"
git add -A
git commit -a -m "Updated from SVN"
git push ${LOCAL_GIT_URL} master

#remove temp data
echo "Removing temporary data"
cd ..
rm -rf ${GIT_CHECKOUT_DIR}
rm -rf ${SVN_CHECKOUT_DIR}

