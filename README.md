# Dotfile

---

* .editorconfig
* .eslintrc
* .gitmessage.txt
* .stylelintrc
* .vimrc
* .zpreztorc
* .zprofile
* .zshrc

## Use zsh

```sh
yum install zsh
zsh
cd ~
rm .zlogin .zlogout .zprofile .zshenv .zshrc
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
exec $SHELL
```

## Use my dotfiles

```sh
cd ~
git clone https://github.com/katzkb/dotfile.git
cp -r dotfile/.* .
```

## Use my gitfiles

```sh
git config --global core.commentchar ";"
git config --global commit.template ~/dotfile/.gitmessage.txt
git config --global init.templatedir '~/dotfile/.git_template'
```

## Use pre-commit

```sh
cd "project path"
cp ~/dotfile/.git_template/hooks/pre-commit .git/hooks/
```

## Use prepare-commit-msg

```sh
cd "project path"
cp ~/dotfile/.git_template/hooks/prepare-commit-msg .git/hooks/
```

### Test prepare-commit-msg

```sh
git checkout id/000
touch test
git add test
git commit
```
