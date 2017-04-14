#!/bin/bash

CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')

echo "INSERT INTO \`settings\` VALUES (1,'plugin_redmine_rubycas','--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nenabled: \'true\'\nmaintain_standard_login: \'true\'\nauto_create_users: \'true\'\nauto_update_users: \'true\'\nauto_user_attributes_map: firstname=firstname&lastname=lastname&mail=email\nlogout_of_cas_on_logout: \'true\'\nbase_url: $CAS_URL\nlogin_url: \'\'\nlogout_url: \'\'\nvalidate_url: \'\'\nusername_session_key: cas_user\nextra_attributes_session_key: cas_extra_attributes\n','$CURRENT_TIME'),(2,'login_required','1','$CURRENT_TIME'),(3,'autologin','0','$CURRENT_TIME'),(4,'self_registration','2','$CURRENT_TIME'),(5,'unsubscribe','1','$CURRENT_TIME'),(6,'password_min_length','8','$CURRENT_TIME'),(7,'lost_password','0','$CURRENT_TIME'),(8,'openid','0','$CURRENT_TIME'),(9,'rest_api_enabled','0','$CURRENT_TIME'),(10,'jsonp_enabled','0','$CURRENT_TIME'),(11,'session_lifetime','0','$CURRENT_TIME'),(12,'session_timeout','0','$CURRENT_TIME');" > /tmp/redmine.sql

mysql -u $DB_USER -p$DB_PASS -h $DB_HOST $DB_NAME < /tmp/redmine.sql

rm /tmp/redmine.sql
