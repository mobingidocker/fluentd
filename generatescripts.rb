require 'shellwords'

logFiles = [
	{:tag => "modaemon.log", :location => "/var/log/modaemon/modaemon"},
	{:tag => "apache.access", :location => "/var/log/container/apache2/access.log"},
	{:tag => "apache.error", :location => "/var/log/container/apache2/error.log"},
	{:tag => "supervisor.log", :location => "/var/log/container/supervisor/supervisord.log"},
	{:tag => "bundler.log", :location => "/var/log/container/bundler.log"},
	{:tag => "startup.log", :location => "/var/log/container/startup.log"},
	{:tag => "auth.log", :location => "/var/log/container/auth.log"},
	{:tag => "nginx.access.log", :location => "/var/log/container/nginx/access.log"},
	{:tag => "nginx.error.log", :location => "/var/log/container/nginx/error.log"},
	{:tag => "rails_production.log", :location=> "/var/log/container/rails/production.log" }
]

sourceString = ""
matchString = ""

logFiles.each do |file|

	sourceString += <<-ENDSOURCE
<source>
  type tail
  format none
  path #{file[:location]}
  pos_file /logpositions/#{file[:tag]}.pos
  tag #{file[:tag]}
  read_from_head true
</source>

	ENDSOURCE

	matchString += <<-ENDMATCH
<match #{file[:tag]}>
	type cloudwatch_logs
	log_group_name $MOCLOUD_LOG_GROUP
	log_stream_name $MOCLOUD_LOG_STREAM-#{file[:tag].gsub(".", "-")}
	auto_create_stream true
</match>
	ENDMATCH

end


File.open("fluent.conf", "w") do |file|
	file.write(
<<-ENDFILE
		## built-in TCP input
## $ echo <json> | fluent-cat <tag>
<source>
  type forward
</source>

## File input
#{sourceString}

# Listen HTTP for monitoring
# http://localhost:24220/api/plugins
# http://localhost:24220/api/plugins?type=TYPE
# http://localhost:24220/api/plugins?tag=MYTAG
<source>
  type monitor_agent
  port 24220
</source>

# Listen DRb for debug
<source>
  type debug_agent
  bind 127.0.0.1
  port 24230
</source>

ENDFILE
		)
end

matchString = matchString.shellescape.gsub('\$', '$')

File.open("startfluent.sh", "w") do |file|

	file.write(
<<-ENDFILE
#!/bin/bash

/usr/local/bin/fluentd -c /fluent/fluent.conf -i #{matchString}
ENDFILE
		)
end

