#!/bin/bash

/usr/local/bin/fluentd -c /fluent/fluent.conf -i "<match modaemon.logs>\ntype cloudwatch_logs\nlog_group_name $MOCLOUD_LOG_GROUP\nlog_stream_name $MOCLOUD_LOG_STREAM-modaemon\nauto_create_stream true\n</match>"
