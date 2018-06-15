#!/bin/bash

log=/var/log/letsencrypt-renew.log

/opt/letsencrypt/certbot-auto renew 2>&1 | tee $log
mail -s "is.abf.cz - LetsEncrypt renewal log" thujer@abf.cz < $log
mail -s "is.abf.cz - LetsEncrypt renewal log" macik@abf.cz < $log
