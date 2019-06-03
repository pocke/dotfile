directory File.expand_path('~/.vim/bundle')
directory File.expand_path('~/.zsh')
directory File.expand_path('~/.config/')
directory File.expand_path('~/.config/awesome/')
directory File.expand_path('~/.config/fontconfig/')
directory File.expand_path('~/.config/sakura/')
directory File.expand_path('~/.config/peco/')

include_recipe '../cookbooks/ruby-trunk-build'
include_recipe '../cookbooks/pacman-syuw'
include_recipe '../cookbooks/dotfiles-private'

%w[
  .gemrc .rspec .tigrc .xinitrc .pryrc .irbrc
  .tmux.conf .vimrc .Xmodmap .ctags .gvimrc
  .config/awesome/rc.lua .config/awesome/themes .config/fontconfig/fonts.conf .config/peco/config.json .config/sakura/sakura.conf .config/karabiner/
  .vim/after
  .vim/colors
  .vim/spell
  bin
].each do |file|
  from = File.expand_path("~/#{file}")
  to = File.expand_path("~/dotfiles/#{file}")
  link from do
    to to
  end
end

git File.expand_path('~/.zsh/zsh-syntax-highlighting') do
  repository 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
end

if File.exist?('/etc/arch-release')
  %w[
    curl
    docker
    docker-compose
    fcitx fcitx-gtk2 fcitx-gtk3 fcitx-mozc  fcitx-qt5
    gnome-keyring
    go
    gvim
    maim
    mate-system-monitor
    nodejs
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    npm
    openssh
    peek
    python
    ragel
    ristretto
    ruby
    sakura
    slop
    thunar
    tig
    tmux
    unzip
    wget
    words
    xorg-xbacklight
    xorg-xev
    xorg-xmodmap
    xorg-xprop
    xorg-xrandr
    xorg-xset
    xsel
    yarn
    zip
    zsh
  ].each do |pack|
    package pack do
      user 'root'
    end
  end

  # Install yay
  execute "curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" do
    cwd '/tmp/'
    not_if 'which yay'
  end

  execute "tar -xvf yay.tar.gz" do
    cwd '/tmp/'
    not_if 'which yay'
  end

  execute "makepkg -si --noconfirm" do
    cwd '/tmp/yay'
    not_if 'which yay'
    only_if 'test -d /tmp/yay'
  end

  pkgs = %w[
    google-chrome
    hub
    ruby-build
    rbenv
    ttf-ricty
  ]
  execute "yay -S --noconfirm --needed #{pkgs.join(' ')}"
end
