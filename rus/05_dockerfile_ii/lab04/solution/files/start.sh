#!/bin/bash
# start mariadb and apache2 in the background

apache2ctl start foreground &
# service mariadb start