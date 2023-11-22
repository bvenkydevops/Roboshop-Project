#!/bin/bash

envsubst </opt/default.conf >/etc/nginx/default.d/roboshop.conf
nginx -g 'daemon off;'
