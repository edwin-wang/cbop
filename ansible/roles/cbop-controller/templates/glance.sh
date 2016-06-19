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

rt=`openstack service list | grep glance -c`

if [ $rt -eq 0 ]; then

# Create user, role for glance
openstack user create --domain default --password {{ GLANCE_PASS }} glance
openstack role add --project service --user glance admin

# Create service entity and aip endpoints
openstack service create --name glance \
  --description "OpenStack Image" image
openstack endpoint create --region RegionOne \
  image public http://{{ CONTROLLER }}:9292
openstack endpoint create --region RegionOne \
  image internal http://{{ CONTROLLER }}:9292
openstack endpoint create --region RegionOne \
  image admin http://{{ CONTROLLER }}:9292

fi
