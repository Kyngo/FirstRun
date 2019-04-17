# First Run Scripts

These scripts are done thinking on what I or my colleagues need for my machines. A script for OS or distro, read the name to see what you're looking for.

## Script name standard

Script will probably have two or three words. 

* First one is major OS (like "ubuntu", "mac" or "windows").

* Second one will be a minor version, like "bionic", "mojave" or "vista".

* Third one will be a subtype, usually used only on linux, like "desktop" or "server".

Script name examples:

* ubuntu-bionic-desktop.sh

* mac-mojave.sh

* windows-10.ps1

## Script internals standard

The script should be coded in a language which the OS understands without adding any package per se. In example, bash for macOS or Linux and PowerShell for Windows Vista or higher.

If you *must* make it in a different language, make a bootstrap script in a native language that first checks if the script can be run. In example, a script that verifies if Python is installed before running a .pyc file.

If you want to install a third-party software from a third-party repo, make sure to verify if the repo is already known before re-adding it.

If the same script must run a command which could *not* be installed, please apply the step above before executing it. In example, Ubuntu doesn't come anymore with `curl`, but to get a public key you might need it. Install the software first, then run the command.

## Updating or adding scripts

Make a PR in order to do so. Simple as pie.

## Disclaimer

Using this scirpt could damage your machine if a different OS or distro is used, so I'm not responsible for your Mac catching fire due to APT or your PowerShell crying like a baby because it can't brew shit.