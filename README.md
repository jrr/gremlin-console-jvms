# Gremlin Console on M1 Mac

Sample project to demonstrate issues with the [Gremlin Console](https://tinkerpop.apache.org/docs/current/tutorials/the-gremlin-console/) on ARM Macs.

## To run gremlin with your default JVM

To download and run Gremlin Console, `make gremlin-console`. Here's what it looks like on a working system:

```
jrr@jrrmbp ~/r/gremlin-console-jvms (main)> make gremlin-console
mkdir -p .gremlin-console
wget https://ftp.wayne.edu/apache/tinkerpop/3.5.2/apache-tinkerpop-gremlin-console-3.5.2-bin.zip -O .gremlin-console/apache-tinkerpop-gremlin-console-3.5.2-bin.zip
--2022-03-30 10:14:36--  https://ftp.wayne.edu/apache/tinkerpop/3.5.2/apache-tinkerpop-gremlin-console-3.5.2-bin.zip
Resolving ftp.wayne.edu (ftp.wayne.edu)... 141.217.0.199
Connecting to ftp.wayne.edu (ftp.wayne.edu)|141.217.0.199|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 97930338 (93M) [application/zip]
Saving to: ‘.gremlin-console/apache-tinkerpop-gremlin-console-3.5.2-bin.zip’

.gremlin-console/apache-tinkerpop-gremlin- 100%[======================================================================================>]  93.39M  75.8MB/s    in 1.2s    

2022-03-30 10:14:37 (75.8 MB/s) - ‘.gremlin-console/apache-tinkerpop-gremlin-console-3.5.2-bin.zip’ saved [97930338/97930338]

file .gremlin-console/apache-tinkerpop-gremlin-console-3.5.2-bin.zip
.gremlin-console/apache-tinkerpop-gremlin-console-3.5.2-bin.zip: Zip archive data, at least v1.0 to extract, compression method=store
unzip -q .gremlin-console/apache-tinkerpop-gremlin-console-3.5.2-bin.zip -d .gremlin-console
# give it a version-independent name so we can add it to PATH with direnv:
mv .gremlin-console/apache-tinkerpop-gremlin-console-3.5.2 .gremlin-console/apache-tinkerpop-gremlin-console
.gremlin-console/apache-tinkerpop-gremlin-console/bin/gremlin.sh

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
plugin activated: tinkerpop.server
plugin activated: tinkerpop.utilities
plugin activated: tinkerpop.tinkergraph
gremlin> 
```

## arm64 OpenJDK 18 (Homebrew's default) -> no jansi

As of this writing, [Homebrew](https://brew.sh/)'s default `java` is an arm64 OpenJDK 18:

```
jrr@jrrmbp ~> brew install java
(...)
==> Pouring openjdk--18.arm64_monterey.bottle.tar.gz

==> Caveats
For the system Java wrappers to find this JDK, symlink it with
  sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

jrr@jrrmbp ~ > sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
Password:

jrr@jrrmbp ~> java -version
openjdk version "18" 2022-03-22
OpenJDK Runtime Environment Homebrew (build 18+0)
OpenJDK 64-Bit Server VM Homebrew (build 18+0, mixed mode, sharing)

jrr@jrrmbp ~/r/gremlin-console-jvms (main)> file /opt/homebrew/Cellar/openjdk/18/libexec/openjdk.jdk/Contents/Home/bin/java
/opt/homebrew/Cellar/openjdk/18/libexec/openjdk.jdk/Contents/Home/bin/java: Mach-O 64-bit executable arm64
```

Attempting to run Gremlin Console with it does this:

```
jrr@jrrmbp ~/r/gremlin-console-jvms (main)> ./.gremlin-console/apache-tinkerpop-gremlin-console/bin/gremlin.sh
Exception in thread "main" java.lang.UnsatisfiedLinkError: Could not load library. Reasons: [no jansi in java.library.path: /Users/jrr/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:., Can't load library: /var/folders/f1/5hh6j9fd7mv6dm1hdrzzh7_w0000gn/T/libjansi-64-17324237963831269554.jnilib]
	at org.fusesource.hawtjni.runtime.Library.doLoad(Library.java:182)
	at org.fusesource.hawtjni.runtime.Library.load(Library.java:140)
	at org.fusesource.jansi.internal.CLibrary.<clinit>(CLibrary.java:42)
	at org.fusesource.jansi.AnsiConsole.wrapOutputStream(AnsiConsole.java:48)
	at org.fusesource.jansi.AnsiConsole.<clinit>(AnsiConsole.java:38)
	at java.base/java.lang.Class.forName0(Native Method)
	at java.base/java.lang.Class.forName(Class.java:488)
	at java.base/java.lang.Class.forName(Class.java:467)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray$1.run(CallSiteArray.java:67)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray$1.run(CallSiteArray.java:64)
	at java.base/java.security.AccessController.doPrivileged(AccessController.java:318)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray.createCallStaticSite(CallSiteArray.java:64)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray.createCallSite(CallSiteArray.java:161)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCall(CallSiteArray.java:47)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:115)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:119)
	at org.apache.tinkerpop.gremlin.console.Colorizer.installAnsi(Colorizer.groovy:32)
	at org.apache.tinkerpop.gremlin.console.Colorizer$installAnsi.call(Unknown Source)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCall(CallSiteArray.java:47)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:115)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:119)
	at org.apache.tinkerpop.gremlin.console.Console.<clinit>(Console.groovy:61)
jrr@jrrmbp ~/r/gremlin-console-jvms (main) [1]> 
```