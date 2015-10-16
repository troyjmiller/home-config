# Vundle VIM Configuration

The only thing bad about using Vundle is that it sucks when managing
your `.vim` as a repo (or part of a repo) on GitHub as we do here.
The easiest fix is to remove all the `.git*` stuff before saving
this repo so that you are sure to add the actual point-in-time git
repos for each Vundle plugin instead of the undeclared submodule,
which will show up as empty directories in any clone of this repo
causing directory conflicts when you run `:PluginInstall`. In short,
after adding any plugin via Vundle always remove the `.git*` stuff
before committing your own `.vim` repo.

When and if you need a fresh copy of a given plugin, you can remove
it from the `bundles` directory and just redo `:PluginInstall`.
Then remove its `.git*` stuff so it commits correctly to your own
repo.

NOTE: `:PluginInstall` will return errors for all for plugins that
have had their `.git*` stuff removed obviously because it cannot
`git clone` them, but this is not a bad thing in this case. If and
when you need to update them `rm` the plugins from `bundle` and 
redo `:PluginInstall` to get latest versions.
