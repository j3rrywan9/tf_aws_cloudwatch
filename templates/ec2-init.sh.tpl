#!/bin/bash

# adjust kernel parameter
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -p

# configure ECS container agent
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

# install psql
sudo tee /etc/yum.repos.d/postgresql12.repo<<EOF
[postgresql12]
name=PostgreSQL 12 for RHEL/CentOS 7 - x86_64
baseurl=https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-7-x86_64
enabled=1
gpgcheck=0
EOF

sudo yum makecache
sudo yum install -y postgresql12

# create DB user
db_user_exists=$(PGPASSWORD=${master_db_password} psql -h ${db_server_hostname} -U ${master_db_username} -tAc "select coalesce((select 1 from pg_roles where rolname='${sonar_jdbc_username}'), 0)")
if [ "$db_user_exists" -eq 0 ]; then
    echo "CREATE USER ${sonar_jdbc_username} WITH ENCRYPTED PASSWORD '${sonar_jdbc_password}';" >> /home/ec2-user/create_user.sql;
    echo "GRANT ALL PRIVILEGES ON DATABASE ${db_name} to ${sonar_jdbc_username};" >> /home/ec2-user/create_user.sql;
    PGPASSWORD=${master_db_password} psql -h ${db_server_hostname} -U ${master_db_username} -d ${db_name} -f /home/ec2-user/create_user.sql;
fi
