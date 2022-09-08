#!/bin/bash

bash /zap/zap.sh -daemon -host 0.0.0.0 -port 7000 -config api.disablekey=true -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true