#!/bin/bash

for comp in catalogue user cart shipping payment ; do
  if [ -f /etc/systemd/system/$comp.service ]; then
    sed -i -e 's|ENV|prod|' /etc/systemd/system/$comp.service /etc/filebeat/filebeat.yml
    systemctl daemon-reload
    systemctl enable $comp
    systemctl restart $comp
  fi
done

if [ -f /etc/nginx/default.d/roboshop.conf ]; then
  sed -i -e 's|ENV|prod|' /etc/nginx/default.d/roboshop.conf /etc/filebeat/filebeat.yml
  systemctl restart nginx
fi

systemctl restart filebeat
