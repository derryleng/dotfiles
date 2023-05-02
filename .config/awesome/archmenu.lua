 local menu98edb85b00d9527ad5acebe451b3fae6 = {
     {"Bottles", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=bottles --file-forwarding com.usebottles.bottles @@u  @@"},
     {"Bulk Rename", "thunar --bulk-rename ", "/usr/share/icons/hicolor/16x16/apps/org.xfce.thunar.png" },
     {"Disks", "gnome-disks"},
     {"Flatseal", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=com.github.tchx84.Flatseal com.github.tchx84.Flatseal"},
     {"Fonts", "gnome-font-viewer "},
     {"Neovim", "xterm -e nvim ", "/usr/share/icons/hicolor/128x128/apps/nvim.png" },
     {"OpenRGB", "openrgb", "/usr/share/icons/hicolor/128x128/apps/OpenRGB.png" },
     {"Youtube Downloader", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=youtubedl-gui io.github.JaGoLi.ytdl_gui", "/var/lib/flatpak/exports/share/icons/hicolor/16x16/apps/io.github.JaGoLi.ytdl_gui.png" },
     {"picom", "picom"},
 }

 local menud334dfcea59127bedfcdbe0a3ee7f494 = {
     {"Ristretto Image Viewer", "ristretto ", "/usr/share/icons/hicolor/16x16/apps/org.xfce.ristretto.png" },
 }

 local menuc8205c7636e728d448c2774e6a4a944b = {
     {"Avahi SSH Server Browser", "/usr/bin/bssh"},
     {"Avahi VNC Server Browser", "/usr/bin/bvnc"},
     {"Discord", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=discord com.discordapp.Discord", "/var/lib/flatpak/exports/share/icons/hicolor/256x256/apps/com.discordapp.Discord.png" },
     {"Firefox Web Browser", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=firefox --file-forwarding org.mozilla.firefox @@u  @@", "/var/lib/flatpak/exports/share/icons/hicolor/16x16/apps/org.mozilla.firefox.png" },
     {"qBittorrent", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=qbittorrent --file-forwarding org.qbittorrent.qBittorrent @@u  @@", "/var/lib/flatpak/exports/share/icons/hicolor/16x16/apps/org.qbittorrent.qBittorrent.png" },
 }

 local menue6f43c40ab1c07cd29e4e83e4ef6bf85 = {
     {"Visual Studio Code", "/usr/bin/code --unity-launch ", "/usr/share/icons/visual-studio-code.png" },
 }

 local menu52dd1c847264a75f400961bfb4d1c849 = {
     {"PulseAudio Volume Control", "pavucontrol"},
     {"Spotify", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=spotify --file-forwarding com.spotify.Client @@u  @@"},
     {"VLC media player", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=/app/bin/vlc --file-forwarding org.videolan.VLC --started-from-file @@u  @@", "/var/lib/flatpak/exports/share/icons/hicolor/16x16/apps/org.videolan.VLC.png" },
     {"Youtube Downloader", "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=youtubedl-gui io.github.JaGoLi.ytdl_gui", "/var/lib/flatpak/exports/share/icons/hicolor/16x16/apps/io.github.JaGoLi.ytdl_gui.png" },
 }

 local menuee69799670a33f75d45c57d1d1cd0ab3 = {
     {"Alacritty", "alacritty", "/usr/share/pixmaps/Alacritty.svg" },
     {"Avahi Zeroconf Browser", "/usr/bin/avahi-discover"},
     {"Disk Usage Analyser", "baobab "},
     {"Htop", "xterm -e htop", "/usr/share/pixmaps/htop.png" },
     {"Logs", "gnome-logs"},
     {"Octopi", "/usr/bin/octopi", "/usr/share/icons/octopi.png" },
     {"Octopi CacheCleaner", "/usr/bin/octopi-cachecleaner", "/usr/share/icons/octopi.png" },
     {"Thunar File Manager", "thunar ", "/usr/share/icons/hicolor/16x16/apps/org.xfce.thunar.png" },
     {"dconf Editor", "dconf-editor"},
     {"fish", "xterm -e fish", "/usr/share/pixmaps/fish.png" },
 }

xdgmenu = {
    {"Accessories", menu98edb85b00d9527ad5acebe451b3fae6},
    {"Graphics", menud334dfcea59127bedfcdbe0a3ee7f494},
    {"Internet", menuc8205c7636e728d448c2774e6a4a944b},
    {"Programming", menue6f43c40ab1c07cd29e4e83e4ef6bf85},
    {"Sound & Video", menu52dd1c847264a75f400961bfb4d1c849},
    {"System Tools", menuee69799670a33f75d45c57d1d1cd0ab3},
}

