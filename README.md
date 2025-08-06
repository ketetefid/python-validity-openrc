# Validity sensors enablement in OpenRC

This is a set of ebuilds to enable use of Validity fingerprint sensors in Gentoo with OpenRC init system. It has been revived from vowstar's repo and updated with patches and proper initialization. 

This set will not work with Systemd and you can already use [vowstar's](https://github.com/vowstar/vowstar-overlay/tree/6eb7c6a74cc95e8764d07d724f8bacdcfbb949ad/sys-auth) for that.

## Howto

Clone this repo as a local one or integrate it with an already existing one.

```sh
emerge sys-auth/python-validity
rc-update add validity-dbus
```

Consult [https://wiki.gentoo.org/wiki/Fingerprint_Reader](https://wiki.gentoo.org/wiki/Fingerprint_Reader) to enable the sensor for various occasions such as PAM logins and sudo.

## Notes

To have a seamless experience with suspend and resume, you need to restart the service with [elogind](https://wiki.gentoo.org/wiki/Elogind). Create a file in `/etc/elogind/system-sleep/`

#### /etc/elogind/system-sleep/validity-enabler.sh
```sh
#!/bin/bash
case $1/$2 in
  pre/*)
    # Put here any commands you want to be run when suspending or hibernating.
    ;;
  post/*)
    /etc/init.d/validity-dbus restart
    # Put here any commands you want to be run when resuming from suspension or thawing from hibernation.
    ;;
esac
```
The script must be made executable.

If a service needs the sensors to be ready (like display-manager), it should start after `validity-dbus`. So, for example:

#### /etc/init.d/display-manager
```sh
depend() {
        need localmount display-manager-setup
        after validity-dbus # add soft dependency on validity-dbus
```		

## Tests and bugs

This repo has been tested with Wayland where the user can login to a Sway session, or unlock swaylock without any problem. If it doesn't work in your setup, please open an issue.
