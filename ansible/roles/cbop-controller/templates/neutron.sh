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

rt=`openstack service list | grep network -c`

if [ $rt -eq 0 ]; then

openstack user create --domain default \
  --password {{ NEUTRON_PASS }} neutron
openstack role add --project service --user neutron admin

openstack service create --name neutron \
  --description "OpenStack Networking" network
openstack endpoint create --region RegionOne \
  network public http://{{ CONTROLLER }}:9696
openstack endpoint create --region RegionOne \
  network internal http://{{ CONTROLLER }}:9696
openstack endpoint create --region RegionOne \
  network admin http://{{ CONTROLLER }}:9696

fi
