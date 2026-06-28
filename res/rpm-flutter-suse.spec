Name:       svahost
Version:    1.4.8
Release:    0
Summary:    RPM package
License:    GPL-3.0
URL:        https://vlanl.com
Vendor:     svahost <info@vlanl.com>
Requires:   gtk3 libxcb1 libXfixes3 alsa-utils libXtst6 libva2 pam gstreamer-plugins-base gstreamer-plugin-pipewire
Recommends: libayatana-appindicator3-1 xdotool
Provides:   libdesktop_drop_plugin.so()(64bit), libdesktop_multi_window_plugin.so()(64bit), libfile_selector_linux_plugin.so()(64bit), libflutter_custom_cursor_plugin.so()(64bit), libflutter_linux_gtk.so()(64bit), libscreen_retriever_plugin.so()(64bit), libtray_manager_plugin.so()(64bit), liburl_launcher_linux_plugin.so()(64bit), libwindow_manager_plugin.so()(64bit), libwindow_size_plugin.so()(64bit), libtexture_rgba_renderer_plugin.so()(64bit)

# https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/

%description
The best open-source remote desktop client software, written in Rust.

%prep
# we have no source, so nothing here

%build
# we have no source, so nothing here

# %global __python %{__python3}

%install

mkdir -p "%{buildroot}/usr/share/svahost" && cp -r ${HBB}/flutter/build/linux/x64/release/bundle/* -t "%{buildroot}/usr/share/svahost"
mkdir -p "%{buildroot}/usr/bin"
install -Dm 644 $HBB/res/svahost.service -t "%{buildroot}/usr/share/svahost/files"
install -Dm 644 $HBB/res/svahost.desktop -t "%{buildroot}/usr/share/svahost/files"
install -Dm 644 $HBB/res/svahost-link.desktop -t "%{buildroot}/usr/share/svahost/files"
install -Dm 644 $HBB/res/128x128@2x.png "%{buildroot}/usr/share/icons/hicolor/256x256/apps/svahost.png"
install -Dm 644 $HBB/res/scalable.svg "%{buildroot}/usr/share/icons/hicolor/scalable/apps/svahost.svg"

%files
/usr/share/svahost/*
/usr/share/svahost/files/svahost.service
/usr/share/icons/hicolor/256x256/apps/svahost.png
/usr/share/icons/hicolor/scalable/apps/svahost.svg
/usr/share/svahost/files/svahost.desktop
/usr/share/svahost/files/svahost-link.desktop

%changelog
# let's skip this for now

%pre
# can do something for centos7
case "$1" in
  1)
    # for install
  ;;
  2)
    # for upgrade
    systemctl stop svahost || true
  ;;
esac

%post
cp /usr/share/svahost/files/svahost.service /etc/systemd/system/svahost.service
cp /usr/share/svahost/files/svahost.desktop /usr/share/applications/
cp /usr/share/svahost/files/svahost-link.desktop /usr/share/applications/
ln -sf /usr/share/svahost/rustdesk /usr/bin/svahost
systemctl daemon-reload
systemctl enable svahost
systemctl start svahost
update-desktop-database

%preun
case "$1" in
  0)
    # for uninstall
    systemctl stop svahost || true
    systemctl disable svahost || true
    rm /etc/systemd/system/svahost.service || true
  ;;
  1)
    # for upgrade
  ;;
esac

%postun
case "$1" in
  0)
    # for uninstall
    rm /usr/bin/svahost || true
    rmdir /usr/lib/svahost || true
    rmdir /usr/local/svahost || true
    rmdir /usr/share/svahost || true
    rm /usr/share/applications/svahost.desktop || true
    rm /usr/share/applications/svahost-link.desktop || true
    update-desktop-database
  ;;
  1)
    # for upgrade
    rmdir /usr/lib/svahost || true
    rmdir /usr/local/svahost || true
  ;;
esac
