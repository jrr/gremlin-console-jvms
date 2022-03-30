println "Server: "+args[0]

cluster = Cluster.build(args[0]).create()
client = cluster.connect()

println "Query: "+args[1]

r = client.submit(args[1]).toList()

println "Result:"

r.each { println it }

