# dotfiles

bunsenmcdubbs does dotfiles!

There are many many great repositories and
examples of dotfile repos online but the one I explored the most
(and used almost none of) was [@holman's dotfile repo](https://github.com/holman/dotfiles).
This repository's install/dotfile management script is essentially a
cruder, feature subset of the scripts in [holman's repo](https://github.com/holman/dotfiles/tree/master/script).

## Installation

```shell
git clone git@github.com:holman/dotfiles.git
cd dotfiles
./script/sync.sh
```

Profit!

## Usage

```shell
$EDITOR <dotfile-that-needs-editing>.symlink
# if the file is new/not previously in this repository
./script/sync.sh
```

The (very short) script takes files in this directory[^1] with file
extension `.symlink` and creates a corresponding symlink in the `$HOME`
directory without the `.symlink` extension and prepended with `.`.

Example: The file `dotfiles/spacemacs.symlink` will trigger the creation of
a symlink at `$HOME/.spacemacs` that links back to the file
(via something along the lines of `ln -s $(pwd)/spacemacs.symlink $HOME/.spacemacs`)

## Notes

The script will check if the files in question already exist and only create
the symlinks if there is no existing file.

## TODO

- [ ] add verbose option to make utility silent by default
- [ ] [^1] support subdirectories (either replicating the structure in the home
directory or just support (recursive?) subdirectory flattening as @holman does).
Currently any dotfiles in subdirectories will likely trigger an error when
the script tries to create a symlink.
- [ ] add flags to overwrite files (bonus points for individual file interactivity)
- [ ] create a new branch (or repo?) with only the script and manage the content
(actual dotfiles) separately

### `spacemacs.symlink`
- [ ] configure orgmode directories (orgmode capture template destinations)
with environment variables
- [ ] remove last section where emacs auto-generates settings etc.
