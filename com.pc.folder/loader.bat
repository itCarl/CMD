@echo off
set "dropbox_directory=%userprofile%\dropbox
reg add HKCU\Environment\com.pc.dropbox
reg add HKCU\Environment\com.pc.dropbox /v dropbox_directory /d %dropbox_directory% /f
reg add HKCU\Environment\com.pc.dropbox /v installed /d 1 /f