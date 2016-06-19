#!/bin/bash
# Copyright 2016 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Export env
. {{ BASE_DIR }}/admin-openrc
export OS_TOKEN={{ ADMIN_PASS }}
export OS_URL=http://{{ CONTROLLER }}:35357/v3

rt=`openstack service list | grep keystone -c`

if [ $rt -eq 0 ]; then

# Create service entity and api endpoints
openstack service create \
  --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region RegionOne \
  identity public http://{{ CONTROLLER }}:5000/v3
openstack endpoint create --region RegionOne \
  identity internal http://{{ CONTROLLER }}:5000/v3
openstack endpoint create --region RegionOne \
  identity admin http://{{ CONTROLLER }}:35357/v3

# Creat a domain, projects, users and roles
openstack domain create --description "Default Domain" default
openstack project create --domain default \
  --description "Admin Project" admin
openstack user create --domain default \
  --password {{ KEYSTONE_PASS }} admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --domain default \
  --description "Service Project" service

openstack project create --domain default \
  --description "Demo Project" demo
openstack user create --domain default \
  --password {{ DEMO_PASS}} demo
openstack role create user
openstack role add --project demo --user demo user

fi

unset OS_TOKEN
unset OS_URL
