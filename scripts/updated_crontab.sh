#!/bin/sh

echo "/var/spool/cron/jp" | entr -s "crontab -l > /home/jp/Config/crontab && notify-send 'Updated crontab.'"
