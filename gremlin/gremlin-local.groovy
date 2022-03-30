port = args[0] ? Integer.parseInt(args[0]) : 8182

cluster = Cluster.build('localhost').port(port).create()
:remote connect tinkerpop.server cluster
:remote console
g.V().count()