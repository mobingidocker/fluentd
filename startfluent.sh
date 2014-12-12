#!/bin/bash

/usr/local/bin/fluentd -c /fluent/fluent.conf \
-i "<match modaemon.logs>\ntype cloudwatch_logs\nlog_group_name $MOCLOUD_LOG_GROUP\nlog_stream_name $MOCLOUD_LOG_STREAM-modaemon\nauto_create_stream true\n</match>" \
-i "<match apache.access>\ntype cloudwatch_logs\nlog_group_name $MOCLOUD_LOG_GROUP\nlog_stream_name $MOCLOUD_LOG_STREAM-apache-access\nauto_create_stream true\n</match>" \
-i "<match apache.error>\ntype cloudwatch_logs\nlog_group_name $MOCLOUD_LOG_GROUP\nlog_stream_name $MOCLOUD_LOG_STREAM-apache-errors\nauto_create_stream true\n</match>" \
-i "<match supervisor.log>\ntype cloudwatch_logs\nlog_group_name $MOCLOUD_LOG_GROUP\nlog_stream_name $MOCLOUD_LOG_STREAM-supervisor\nauto_create_stream true\n</match>" \

