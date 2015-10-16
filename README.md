# SkilStak Home Config Helper

***You don't need this is you are only working from `skilstak.sh`. If
you are setting up your own multi-user Linux environment take a look at
[`usr-share-skilstak`](http://github.com/skilstak/usr-share-skilstak)
instead.***

This repo is to help you create a SkilStak-ish workspace on your
own Linux/Mac computer or Raspberry Pi. You can clone this directly
and make your own local changes and `git pull` on occasion with
something is added or you can fork the repo and save your own changes
and pull down upstream changes from time to time.

# Simple Clone Method

```bash 
cd ~
mkdir repos
cd repos
git clone git@github.com:skilstak/home-config.git
cd home-config
./setup
```

# Fork Method

 1. Fork from [github.com/skilstak/home-config](http://github.com/skiltak/home-config)
 2. Clone your copy of the repo
 3. Sync your master with upstream [like this](https://help.github.com/articles/syncing-a-fork/)
 4. Commit your synced changes with `save`

# Don't Rename

Unless you really know what you are doing stick with the
`$HOME/repos/home-config` location since that is coded into the
`setup` script.

# Dependencies

Eventually `setup` may including looking up dependencies and prompting
for installing them (packages, commands, apps). For now you will
have to ensure you have the following installed, (which you learn
to do in class if you don't know):

* [git/GitHub](http://github.com)
* [vim 7.4+](http://www.vim.org) (7.3 will work)
* [Python 3+](http://www.python.org)
* [Go 1.5+](http://www.golang.org)
* [Java OpenJDK 7+](http://openjdk.java.net)
* [Node/NPM](http://nodejs.org)
* [Harp](http://harpjs.com)
* [Surge](http://surge.sh)
* [Browser Sync](http://www.browsersync.io/)
* [Google Chrome](http://google.com/chrome)
* [Solarized terminal](solarized)
* [dtach](dtach)

On a Mac you have to install these as well:

* `brew`
* `brew install bash-completion`
