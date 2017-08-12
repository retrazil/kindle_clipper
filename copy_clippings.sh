#!/bin/bash

# A shell script to automatically copy and upload all of your kindle 
# clippings (My Clippings.txt) to github pages. 

# Run this script evertime you want to upload new clippings

# CREATE A REPO ON GITHUB BEFORE RUNNING THIS SCRIPT
# Create an empty repo on github called "kindle_notes"
# grab the url (it should be of the form https://github.com/username/kindle_notes.git)


# newline for cleaner output
echo ""

# if the working dir already exists, use it
# otherwise create a new one
if [ -d "$HOME/kindle_notes" ]
then
   WORKING_DIR="$HOME/kindle_notes"
   echo "$HOME/kindle_notes already exists."
   echo "Using $HOME/kindle_notes as working directory."
else
  cd $HOME
  mkdir kindle_notes 
  $WORKING_DIR="$HOME/kindle_notes"
  echo "created a new working directory.. $WORKING_DIR"
fi

# newline
echo ""

# exit if above case fails 
if [ $? -ne 0 ]
then
  echo "could not create working directory. :/"
  echo "exiting.."
  exit -1
fi

# where kindle is mounted
DISK=/media/$USER/Kindle

cd $DISK

# print status or exit if cd fails
if [ $? -eq 0 ]  
then
  echo "inside Kindle.. $DISK"
else
  echo "could not get into Kindle. Make sure Kindle is plugged (check if you can open it using file manager)."
  echo "exiting..."
  exit 1
fi

# show inside of Kindle
# ls 

# cd to documents folder inside Kindle 
cd "$DISK/documents"

# print status
if [ $? -eq 0 ]
then
   echo "inside Kindle documents..$DISK/documents"
else
  echo "could not get into Kindle/documents."
  echo "exiting.."
  exit 2
fi

# show contents of documents

# copy clippings to home/user
CLIPPING=My\ Clippings.txt
cp "$CLIPPING" "$WORKING_DIR"

if [ $? -eq 0 ]
then
  echo "copied $CLIPPING into $WORKING_DIR. :)"
else
  echo "could not copy the $CLIPPING file. :("
  exit 3
fi

# return to working dir
cd $WORKING_DIR
echo ""
echo "inside $WORKING_DIR"

# change file name to clippings.txt
mv "$CLIPPING" clippings.txt
echo "renamed $CLIPPING -> clippings.txt"

# create html file from clippings.txt
# head part of html, styling
echo '<html>
                <head>
                        <title>Kindle Clippings</title>
                </head>
                <body style="padding: 10px; 
                             margin: auto; 
                             max-width:800px; 
                             font-size: 14px;">
                <pre style="white-space: pre-wrap">
' > html_head.txt

# close all tags
echo '</pre></body></html>' > html_tail.txt

# wrap html around clippings
cat html_head.txt clippings.txt html_tail.txt  > index.html
echo ""
echo "created html file from clippings.txt."
echo "you can view your clippings in browser now :)"

COMMIT_MESSAGE=$(date +"%a %dth %b %Y, %I:%M:%S %p %Z") 

# newline
echo ""

# Create an empty repo on github called "kindle_notes"
# grab the url (it should be of the form https://github.com/username/kindle_notes.git)
# substitute your git repo url here
MY_REMOTE="https://github.com/retrazil/kindle_notes.git"

# add a new commit if git already exists
# otherwise initiate a new git repo
if [ -d ".git" ]
then
  git add -A
  git commit -m "$COMMIT_MESSAGE"
  git push origin master
else
  git init
  git remote add origin $MY_REMOTE
  git add -A
  git commit -m "first commit"
  git push origin master
fi
  
# go to repository's Settings 
# and under Github Pages heading
# change Source to 'master branch'
# your should be able to view the webpage at https://username.github.io/kindle_notes
# in my case it is https://retrazil.github.io/kindle_notes/
