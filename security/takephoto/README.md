# Tested on Ubuntu GNOME 17.10 only !!
### take a photo through the webcam after each incorrect password attempt and sent an email when internet connected

This script can be expended with the supplied email script.

>Simply add "python location/to/script/" in "/usr/bin/takephoto" above "exit 0":
```Shell
#!/bin/bash
ts=`date +%d_%m_%Y-%H_%M_%S`
ffmpeg -f video4linux2 -s vga -i /dev/video0 -ss 0:0:3 -vframes 3 /tmp/vid-$ts.%01d.jpg
python /home/$USER/Documents/mail.py  # <--- Added
exit 0
```

Be sure to modify the email script with your settings.

## Note: This email script won't work on account with two-step-verification. Use a dummy email account.
