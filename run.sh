#!/bin/bash

/bin/rm -f /root/goesdump/config.db

/bin/ln -s /root/run/config.db /root/goesdump/config.db

/usr/bin/screen -c .osp-screenrc

exit
