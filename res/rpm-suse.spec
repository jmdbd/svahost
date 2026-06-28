Name:       svahost
Version:    1.4.8
Release:    0
Summary:    RPM package
License:    GPL-3.0
Requires:   gtk3 libxcb1 libXfixes3 alsa-utils libXtst6 libva2 pam gstreamer-plugins-base gstreamer-plugin-pipewire
Recommends: libayatana-appindicator3-1 xdotool

# https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/

%description
The best open-source remote desktop client software, written in Rust.

%prep
# we have no source, so nothing here

%build
# we have no source, so nothing here

%global __python %{__python3}

%install
mkdir -p %{buildroot}/usr/bin/
mkdir -p %{buildroot}/usr/share/svahost/
mkdir -p %{buildroot}/usr/share/svahost/files/
mkdir -p %{buildroot}/usr/share/icons/hicolor/256x256/apps/
mkdir -p %{buildroot}/usr/share/icons/hicolor/scalable/apps/
install -m 755 $HBB/target/release/rustdesk %{buildroot}/usr/bin/svahost
install $HBB/libsciter-gtk.so %{buildroot}/usr/share/svahost/libsciter-gtk.so
install $HBB/res/svahost.service %{buildroot}/usr/share/svahost/files/
install $HBB/res/128x128@2x.png %{buildroot}/usr/share/icons/hicolor/256x256/apps/svahost.png
install $HBB/res/scalable.svg %{buildroot}/usr/share/icons/hicolor/scalable/apps/svahost.svg
install $HBB/res/svahost.desktop %{buildroot}/usr/share/svahost/files/
install $HBB/res/svahost-link.desktop %{buildroot}/usr/share/svahost/files/

%files
/usr/bin/svahost
/usr/share/svahost/libsciter-gtk.so
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
    rm /usr/share/applications/svahost.desktop || true
    rm /usr/share/applications/svahost-link.desktop || true
    update-desktop-database
  ;;
  1)
    # for upgrade
  ;;
esac
