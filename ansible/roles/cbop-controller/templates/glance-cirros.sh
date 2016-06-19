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

cd {{ BASE_DIR }}
. admin-openrc

if [ ! -f 'cirros-d150923-ppc64le-initramfs' ]; then
wget http://download.cirros-cloud.net/daily/20150923/cirros-d150923-ppc64le-initramfs
# wget http://download.cirros-cloud.net/daily/20150923/cirros-d150923-ppc64le-kernel
# wget http://download.cirros-cloud.net/daily/20150923/cirros-d150923-ppc64le-disk.img
fi

openstack image create "cirros-initramfs" \
  --disk-format aki --container-format aki --public \
  --file ./cirros-d150923-ppc64le-initramfs
# openstack image create "cirros-kernel" \
#   --disk-format ari --container-format ari --public \
#   --file ./cirros-d150923-ppc64le-kernel
# openstack image create "cirros-disk" \
#   --disk-format ami --container-format ami --public \
#   --property kernel_id="cirros-kernel" ramdisk_id="cirros-initramfs" \
#   --file ./cirros-d150923-ppc64le-disk.img

openstack image list
