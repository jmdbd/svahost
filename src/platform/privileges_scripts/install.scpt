on run {daemon_file, agent_file, user}

  set prefs_dir to "/Users/" & user & "/Library/Preferences/com.carriez.svahost/"
  set prefs_toml to quoted form of (prefs_dir & "svahost.toml")
  set prefs2_toml to quoted form of (prefs_dir & "svahost2.toml")

  set sh1 to "echo " & quoted form of daemon_file & " > /Library/LaunchDaemons/com.carriez.svahost_service.plist && chown root:wheel /Library/LaunchDaemons/com.carriez.svahost_service.plist;"

  set sh2 to "echo " & quoted form of agent_file & " > /Library/LaunchAgents/com.carriez.svahost_server.plist && chown root:wheel /Library/LaunchAgents/com.carriez.svahost_server.plist;"

  set sh3 to "cp -rf " & prefs_toml & " /var/root/Library/Preferences/com.carriez.svahost/;"

  set sh4 to "cp -rf " & prefs2_toml & " /var/root/Library/Preferences/com.carriez.svahost/;"

  set sh5 to "launchctl bootout system/com.carriez.svahost_service 2>/dev/null || launchctl unload -w /Library/LaunchDaemons/com.carriez.svahost_service.plist 2>/dev/null || true; launchctl bootstrap system /Library/LaunchDaemons/com.carriez.svahost_service.plist 2>/dev/null || launchctl load -w /Library/LaunchDaemons/com.carriez.svahost_service.plist;"

  set sh to sh1 & sh2 & sh3 & sh4 & sh5

  do shell script sh with prompt "svahost wants to install daemon and agent" with administrator privileges
end run
