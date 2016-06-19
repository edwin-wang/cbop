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

. {{ BASE_DIR }}/admin-openrc

rt=`openstack service list | grep volume -c`

if [ $rt -eq 0 ]; then

openstack user create --domain default \
  --password {{ CINDER_PASS }} cinder
openstack role add --project service --user cinder admin

openstack service create --name cinder \
  --description "OpenStack Block Storage" volume
openstack service create --name cinderv2 \
  --description "OpenStack Block Storage" volumev2

openstack endpoint create --region RegionOne \
  volume public http://{{ CONTROLLER }}:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volume internal http://{{ CONTROLLER }}:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volume admin http://{{ CONTROLLER }}:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne \
  volumev2 public http://{{ CONTROLLER }}:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volumev2 internal http://{{ CONTROLLER }}:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volumev2 admin http://{{ CONTROLLER }}:8776/v2/%\(tenant_id\)s

fi
