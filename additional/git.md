# Work with GIT (cheat sheet)

__Git__ (pronounced "git" [^1]) is a distributed version control system. The project was created by Linus Torvalds to manage the development of the Linux kernel, and the first version was released on April 7, 2005.

Version control systems allow developers to manage development and be sure that any new change will not "break" the code. More details can be found in the official GIT manual [^2].

## Terminology

* __repository__ - a place to store source code.
* __version tracking__ - tracking changes in documents (e.g., source code). This tracking allows you to manage the history of changes. Version tracking is performed by specialized programs - _version control systems_.
* __version control__ - also known as __source control__, the practice of tracking changes in source code and managing those changes.
* __version control system__ - a specialized software product that allows version control. The most well-known programs are [CVS](https://en.wikipedia.org/wiki/Concurrent_Versions_System), [SVN](https://en.wikipedia.org/wiki/Apache_Subversion), [GIT](https://en.wikipedia.org/wiki/Git).
* __branch__ - a development direction independent of others. A branch is a copy of part of the repository (e.g., one directory) where changes can be made without affecting other branches. Documents in different branches have the same history up to the branching point and different histories after it.
* __commit__ - saving (remembering) code changes in the version control system.
* __project version__ - the state of the project at a specific point in time.
* __pull version__ - get a version from a remote repository.
* __push version__ - send a version to a remote repository.
* __merge branch__ - merging changes from one branch into another.
* __pull request__ - a request to merge changes from one branch into another.
* __merge request__ - a request to merge changes from one branch into another.
* __merge conflict__ - a situation where two branches change the same file and the version control system cannot automatically merge the changes.
* __stash__ - a temporary storage area for changes that are not ready to be committed.
* __tag__ - a label for a specific commit.
* __fork__ - a copy of a repository that is stored in another user's account.
* __clone__ - a copy of a repository that is stored on the local machine.
* __remote__ - a repository that is stored on another machine.
* __origin__ - the default name for the remote repository.
* __upstream__ - the original repository from which the fork was made.

## Cheat sheet

| action | command |
| ------ | ------- |
| View existing branches: | `git branch` |
| Create a branch `my-cool-branch`: | `git branch my-cool-branch` |
| Switch to the `my-cool-branch` branch: | `git checkout my-cool-branch` |
| Delete the `my-cool-branch` branch: | `git branch -D my-cool-branch` |
| Create and switch: | `git checkout -B my-cool-branch` |
| View status: | `git status` |
| Add all files: | `git add *` |
| Add the `mycoolfile` file: | `git add mycoolfile` |
| Create a commit with the message `test message`: | `git commit -m "test message"` |
| Send changes to the remote repository | `git push` |

## Start working with GITHUB

Create an account on GITHUB. After that, you will be able to create your repositories, both public and private.

To interact with GITHUB, you need to install GIT. To download it and get acquainted with the installation process, go to the [GIT Installation](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) page and follow the instructions.

## Security key

Let's say you registered an account with the email address `my@cool.email`.

After installing GIT, the GIT BASH menu will appear in the OS. Open this console and create authentication keys for GITHUB. To do this, run the following command:

```shell
ssh-keygen -C "my@cool.email"
```

Two files will be created in the user's computer folder (`~/.ssh`): private and public keys. The public key must be registered in GITHUB.

> If you want, you can assign your name to the keys, then you need to create a file `~/.ssh/config` in which the key name for a specific client - github is specified.

## Creating a repository

The simplest way to create a repository is to create it through the Web interface and then clone it.

## The minimum working scenario

The minimum working scenario includes the following steps:

1. Switch to the main branch
2. Get the latest changes from the remote server
3. Create a new branch (for new functionality) and switch to it
4. _Implement new functionality - GIT is not related to this_
5. Add changed files to tracked files
6. Create a checkpoint (commit)
7. Send the checkpoint to the server

After that a new branch will be created on the remote server, which will need to be merged into the main branch. To do this, a request (pull request or merge request) is created through the web interface of the repository. After the code is checked and approved, the new branch is merged into the main one.

```shell
git checkout main
git pull
git checkout -B <new-branch>
# some work inside
git add *
git commit -m <message>
git push
```

## Bibliography

[^1]: [Wiki GIT](https://ru.wikipedia.org/wiki/Git)
[^2]: [Pro GIT](https://git-scm.com/book/ru/v2)
