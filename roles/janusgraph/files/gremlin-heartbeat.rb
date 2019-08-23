#!/usr/bin/ruby

require 'gremlin_client'

client = GremlinClient::Connection.new(
  host: "localhost",
  port: 8182,
  connection_timeout: 30,
  timeout: 60,
  path: "/gremlin"
)

q = %Q{
  graph = JanusGraphFactory.open('conf/janusgraph-cql-es.properties')
  mgmt = graph.openManagement()
  mgmt.printSchema()}

begin
  client.send_query(q)
rescue GremlinClient::ServerError => e
  puts e.message
  exit 1
end
