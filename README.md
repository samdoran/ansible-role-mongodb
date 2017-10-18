MongoDB
=========
[![Galaxy](https://img.shields.io/badge/galaxy-samdoran.mongodb-blue.svg?style=flat)](https://galaxy.ansible.com/samdoran/mongodb)
[![Build Status](https://travis-ci.org/samdoran/ansible-role-mongodb.svg?branch=master)](https://travis-ci.org/samdoran/ansible-role-mongodb)

Install and configure [MongoDB](https://www.mongodb.com).

Requirements
------------

For managing SELinux, the following packages are required:

- `policycoreutils-python`
- `libselinux-python`

Role Variables
--------------

| Name              | Default Value       | Description          |
|-------------------|---------------------|----------------------|
| `mongodb_version` | `3.4` | The version of MongoDB to install |
| `mongodb_port` | `27017` | Default port for MongoDB instances |
| `mongodb_shardsvr_port` | `27018` |  |
| `mongodb_configsvr_port` | `27019` |  |
| `mongodb_webstatus_port` | `28017` |  |
| `mongodb_disable_selinux` | `no` | Whether or not to disable SELinux (**not recommended**). The role will properly configure the system to work with SELinux enabled. |


Dependencies
------------

None

Example Playbook
----------------

    - hosts: all
      roles:
         - samdoran.mongodb

License
-------

MIT
