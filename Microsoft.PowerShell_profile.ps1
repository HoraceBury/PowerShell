# The contents of this file are appropriate for the PowerShell profile, found by executing: echo $PROFILE
# More info: https://superuser.com/a/886960/356818

# This installation uses PoshGit: https://github.com/dahlbyk/posh-git
Import-Module posh-git

# My root git folder is on C: drive
Set-Location C:\git\

# Powershell history stored here: %userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\
# http://woshub.com/powershell-commands-history/


# Base64 de/encode

# https://eddiejackson.net/wp/?p=23393
function get-base-encode {
	$username = $args[0]
	$password = $args[1]
	$basicAuthEncoded = [System.Convert]::ToBase64String([System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($username+":"+$password))
	echo $basicAuthEncoded
}
set-alias -name encode -value get-base-encode

# https://eddiejackson.net/wp/?p=23393
function get-base-decode {
	[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($args[0]))
}
set-alias -name decode -value get-base-decode


# git stash

function get-git-status { git status }
set-alias -name gs -value get-git-status

function get-git-stash { git stash $args }
set-alias -name stash -value get-git-stash


# git pull all

function get-git-pull-all { git -c http.sslVerify=false pull --all }
set-alias -name gpa -value get-git-pull-all


# git clone

function get-git-clone { git -c http.sslVerify=false clone  $args }
set-alias -name clone -value get-git-clone


# git push

function get-git-push {
	$b = git symbolic-ref --short HEAD
	git push --set-upstream origin $b $args
}
new-alias -name push -value get-git-push


# git branch remote

function get-git-branch-remote { git branch -r }
set-alias -name gr -value get-git-branch-remote


# git branch local

function get-git-branch-local { git branch -a }
set-alias -name ga -value get-git-branch-local


# git log

function get-git-log { git log $args }
new-alias -name gl -value get-git-log -force -option allscope


# git commit

function get-commit { git commit -m $args }
new-alias -name commit -value get-commit -force -option allscope


# git checkout master

function get-git-checkout-master { git checkout master }
set-alias -name cm -value get-git-checkout-master


# git add .

function get-git-add {
	if ($args.length -eq 0) {
		git add .
	} else {
		git add $args[0]
	}
}
set-alias -name add -value get-git-add


# git branch new_branch

function get-git-create { git checkout -b $args }
set-alias -name create -value get-git-create


# git rebase continue

function get-git-rebase-continue { git rebase --continue }
set-alias -name continue -value get-git-rebase-continue


# git pull master; git pull branch; git rebase master;

function get-git-rebase {
	$branch = git symbolic-ref --short HEAD
	
	git checkout master
	git pull --all
	
	git checkout $branch
	git pull --all
	
	git rebase master
	
	$tmp = git symbolic-ref --short HEAD
	
	if ($tmp -eq $branch) {
		git push --force
		echo "rebase succeeded"
	} else {
		git rebase --abort
		echo "rebase failed"
	}
}
new-alias -name rebase -value get-git-rebase


# show commits created on the current branch

function show-commits {
	$name = git symbolic-ref --short HEAD
	git log --decorate --pretty=oneline --abbrev-commit --first-parent master..$name
}


# show files changed on the current branch
function show-file-changes {
	$name = git symbolic-ref --short HEAD
	git diff --name-only master $name
}
