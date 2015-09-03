# SkilStak Loves Solarized

We freaking love Solarized Dark at SkilStak. The color balance is
not only perfect it is very good on the eyes. Here are some helper
files to get you started quickly.

# Mac

To solarize your Mac terminal just download [the terminal settings
file](Solarized.terminal), open terminal (`command + space` then
type `term` + `<enter>`), and `Shell -> Import` the terminal file.
This bypasses the security warning you might get by double-clicking
on the terminal itself.

If you still feel a need to use iTerm there's a
[file](solarized-dark.itermcolor) as well. The terminal in Yosemite
is really nice so we don't use this much.

# Linux (Ubuntu)

We only use Ubuntu Linux 15.04 and above these days and Solarized is one of
the standard terminal themes.

# Linux (Raspbian)

You currently cannot solarize the LXTerminal on Raspberry Pi without
recompiling it (as far as we have been able to find). But this is
not a problem since we don't use the GUI (`startx`) Terminal with
our Pis anyway preferring to get them configured and then login
remotely to them from our Mac and Linux machines the way most do.

# Windows

If you are forced to use Windows you have a few ways to go. If you
are up to it and have the resources make a real or virtual Ubuntu
Linux machine and use that. Windows is a horrible development
environment for anything other than 3D games. 

If using another operating system besides Windows is not a choice
try getting the [SSH Chrome extension][] and "Restoring" [this
profile][] to get Solarized colors.

Another option is downloading [Putty Tray][], which can also run
from a USB stick, and following [these configuration instructions][].

## I can't see my text? What about the Solarized bug?

There is unfortunate bug for some configurations that render some
text invisible for applications that have been created without being
tested for Solarized. Their creators claim this is Solarized fault
and yet Solarized is now officially included in the Ubuntu terminal
preferences. To get around the problem it is wise to have two
terminal themes for when you need to switch, which is not that often
based on the prevalence, nay, ubiquity of the solarized terminal
palette.

[SSH Chrome extension]: https://chrome.google.com/webstore/detail/secure-shell/pnhechapfaindjhompbnflcldabbghjo
[Putty Tray]: https://puttytray.goeswhere.com
[these configuration instructions]: https://github.com/altercation/solarized/tree/master/putty-colors-solarized
[this profile]: https://raw.githubusercontent.com/skilstak/home-config/master/solarized/solarized-dark-chrome.json
