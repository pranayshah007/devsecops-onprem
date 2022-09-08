#!/bin/bash

wget https://github.com/zaproxy/zaproxy/releases/download/2.7.0/ZAP_2.7.0_Linux.tar.gz

tar -xvzf ZAP_2.7.0_Linux.tar.gz

mkdir /home/archerysec/app/zap

cp -r ZAP_2.7.0/* /home/archerysec/app/zap

cp -r zap_config/policies /home/archerysec/app/zap

cp -r zap_config/ascanrulesBeta-beta-24.zap /home/archerysec/app/zap/plugin/ascanrulesBeta-beta-24.zap

rm -rf ZAP_2.7.0_Linux.tar.gz && \
    rm -rf ZAP_2.7.0