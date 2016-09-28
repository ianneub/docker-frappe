#!/bin/sh

NODE_TYPE=$1

bench use localhost

TASK=$(case "$NODE_TYPE" in
  ("app") echo "/home/frappe/frappe-bench/env/bin/gunicorn -b 0.0.0.0:8000 -w 4 -t 120 frappe.app:application --preload" ;;
  ("scheduler") echo "/usr/bin/bench schedule" ;;
  ("worker-default") echo "/usr/bin/bench worker --queue default" ;;
  ("worker-long") echo "/usr/bin/bench worker --queue long" ;;
  ("worker-short") echo "/usr/bin/bench worker --queue short" ;;
  ("node-socketio") echo "node /home/frappe/frappe-bench/apps/frappe/socketio.js" ;;
  (*) ;;
esac)

# setup site_config.json
dockerize -template /tmp/config/site_config.json.tmpl:/home/$FRAPPE_USER/frappe-bench/sites/common_site_config.json \
          -template /tmp/config/site_config.json.tmpl:/home/$FRAPPE_USER/frappe-bench/sites/localhost/site_config.json \
          true

# set permissions on config files
chmod 440 /home/$FRAPPE_USER/frappe-bench/sites/common_site_config.json \
          /home/$FRAPPE_USER/frappe-bench/sites/localhost/site_config.json

if [ ${NODE_TYPE} = "app" ]; then

  echo 'Waiting for DB to start up'

  dockerize -wait tcp://$DB_HOST:3306 -timeout 120s

  # su frappe -c "bench --site site.local doctor > /dev/null 2>&1"
  cd /home/frappe/frappe-bench
  bench --site localhost doctor > /dev/null 2>&1

  if [ ! $? -eq 0 ]; then

    cd /home/frappe/frappe-bench
    bench reinstall && \
    bench install-app erpnext

  fi;

  cd /home/frappe/frappe-bench/sites

fi;

(eval $TASK | tee /home/frappe/frappe-bench/logs/${NODE_TYPE}.log) 3>&1 1>&2 2>&3 | tee /home/frappe/frappe-bench/logs/${NODE_TYPE}.err.log
