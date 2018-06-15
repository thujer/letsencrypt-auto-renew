letsencrypt-auto-renew
---
LetsEncrypt domain registration & automatic renew

Directory structure
backup … original Apache config before change, backup of directories sites-available a sites-enabled
~live … symlink to directory with live certificates
log … @letsencrypt-renew.log result certification update with renew.sh

create_ssl-www.sh … script with domain list to domain registration

renew.sh … script called from crontab

Crontab call example
Run once month
To call every 15.day in month in 23:00 add next line to crontab
00 23 15 * * /var/bash/letsencrypt-auto-renew/renew.sh
