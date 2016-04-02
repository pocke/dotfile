require 'fileutils'

def exec(cmd)
  puts "> #{cmd}"
  fail(cmd) unless system(cmd)
end

FileUtils.mkdir_p(File.expand_path('~/.bundle'))
FileUtils.mkdir_p(File.expand_path('~/.vim/bundle'))
FileUtils.mkdir_p(File.expand_path('~/.zsh'))
FileUtils.mkdir_p(File.expand_path('~/.config/awesome/'))
FileUtils.mkdir_p(File.expand_path('~/.config/fontconfig/'))
FileUtils.mkdir_p(File.expand_path('~/.config/peco/'))


%w[
  .gemrc .rspec .tigrc .vimperatorrc .xinitrc .yaourtrc
  .tmux.conf .vimrc .Xmodmap .ctags .gvimrc
  .config/awesome/rc.lua .config/awesome/themes .config/fontconfig/fonts.conf .config/peco/config.json
  .bundle/config
  .vim/after
  .vim/colors
].each do |file|
  unless File.exist?(File.expand_path("~/#{file}"))
    exec("ln -s ~/dotfiles/#{file} ~/#{file}")
  end
end

is_arch = File.exist?('/etc/pacman.conf')
exec('sudo pacman -S words nodejs npm go tmux tig') if is_arch

unless File.exist?(File.expand_path("~/.gitconfig"))
  exec(<<-EOS
cat <<EOF > ~/.gitconfig
[include]
  path = dotfiles/.gitconfig
[core]
  excludesfile = #{File.expand_path("~/dotfiles/.gitignore_global")}
EOF
       EOS
  )
end

unless File.exist?(File.expand_path("~/.zshrc"))
  exec('echo "source dotfiles/.zshrc" >> ~/.zshrc')
end

unless Dir.exist?(File.expand_path('~/.vim/bundle/neobundle.vim'))
  exec('git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim')
end

unless Dir.exist?(File.expand_path('~/.zsh/zsh-syntax-highlighting'))
  exec('git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting')
end

exec('vim +NeoBundleInstall +q')
exec('sudo npm install -g jshint bower jsonlint typescript typescript-tools tslint')
exec('gem install bundler')
exec('bundle install')
exec('go get github.com/motemen/ghq github.com/jteeuwen/go-bindata/... github.com/pocke/www github.com/golang/lint/golint github.com/peco/peco/... github.com/motemen/ghq github.com/pocke/www')
