# dotfiles
A very good blog to explain how this works:
[Using GNU Stow to manage your dotfiles](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)

# Manual work
After clone, use `stow` to create links to appropriate
place. Take vim for example:
```
$stow vim
```

Addtional steps needed to complete config
vim plugins, refore to:
https://github.com/VundleVim/Vundle.vim

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#Launch vim and run :PluginInstall
```
