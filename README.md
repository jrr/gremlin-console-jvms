# Gremlin Console on M1 Mac

Sample project to demonstrate issues with the [Gremlin Console](https://tinkerpop.apache.org/docs/current/tutorials/the-gremlin-console/) on ARM Macs.

## To run gremlin with your default JVM

To download and run Gremlin Console, `make gremlin-console`. Here's what it looks like on a working system:

```
jrr@jrrmbp ~/r/gremlin-console-jvms (main)> make gremlin-console
mkdir -p .gremlin-console
wget https://ftp.wayne.edu/apache/tinkerpop/3.5.2/apache-tinkerpop-gremlin-console-3.5.2-bin.zip -O .gremlin-console/apache-tinkerpop-gremlin-console-3.5.2-bin.zip
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

## Homebrew's default Java

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

Attempting to run Gremlin Console with it causes issue #1 ("no jansi") below.

## Issue #1 (arm64 java) -> no jansi

When using an ARM java 18 -- either Oracle or OpenJDK - Gremlin fails with a missing _jansi_ library. Test this with either `make test_oracle_18_arm` or `test_openjdk_18_arm`:

```
jrr@jrrmbp ~/r/gremlin-console-jvms (main)> make test_openjdk_18_arm 
(...)
file `which java`
/Users/jrr/repos/gremlin-console-jvms/.jdks/openjdk_18_arm/jdk-18.jdk/Contents/Home/bin/java: Mach-O 64-bit executable arm64
java -version
openjdk version "18" 2022-03-22
OpenJDK Runtime Environment (build 18+36-2087)
OpenJDK 64-Bit Server VM (build 18+36-2087, mixed mode, sharing)
(...)
.gremlin-console/apache-tinkerpop-gremlin-console/bin/gremlin.sh
Exception in thread "main" java.lang.UnsatisfiedLinkError: Could not load library. Reasons: [no jansi in java.library.path: /Users/jrr/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:., Can't load library: /var/folders/f1/5hh6j9fd7mv6dm1hdrzzh7_w0000gn/T/libjansi-64-9334025133467737627.jnilib]
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
make[1]: *** [gremlin-console] Error 1
make: *** [test_openjdk_18_arm] Error 2
```

This is similar to the existing TinkerPop issue [Exception running gremlin console on ppc64le hardware](https://issues.apache.org/jira/browse/TINKERPOP-2584).

## Issue #2 (x64 java) -> groovy class file major version

When using an x64 java 18 -- either Oracle or OpenJDK -- Gremlin fails with an exception about a class file major version in Groovy compilation. Test this with `make test_openjdk_18_x64` or `make test_oracle_18_x64`:

```
jrr@jrrmbp ~/r/gremlin-console-jvms (main) [2]> make test_openjdk_18_x64 
(...)
file `which java`
/Users/jrr/repos/gremlin-console-jvms/.jdks/openjdk_18_x64/jdk-18.jdk/Contents/Home/bin/java: Mach-O 64-bit executable x86_64
java -version
openjdk version "18" 2022-03-22
OpenJDK Runtime Environment (build 18+36-2087)
OpenJDK 64-Bit Server VM (build 18+36-2087, mixed mode, sharing)
make gremlin-console
.gremlin-console/apache-tinkerpop-gremlin-console/bin/gremlin.sh

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
Exception in thread "main" BUG! exception in phase 'semantic analysis' in source unit 'Script1.groovy' Unsupported class file major version 62
	at org.codehaus.groovy.control.CompilationUnit.applyToSourceUnits(CompilationUnit.java:969)
	at org.codehaus.groovy.control.CompilationUnit.doPhaseOperation(CompilationUnit.java:642)
	at org.codehaus.groovy.control.CompilationUnit.compile(CompilationUnit.java:591)
	at groovy.lang.GroovyClassLoader.doParseClass(GroovyClassLoader.java:401)
	at groovy.lang.GroovyClassLoader.access$300(GroovyClassLoader.java:89)
	at groovy.lang.GroovyClassLoader$5.provide(GroovyClassLoader.java:341)
	at groovy.lang.GroovyClassLoader$5.provide(GroovyClassLoader.java:338)
	at org.codehaus.groovy.runtime.memoize.ConcurrentCommonCache.getAndPut(ConcurrentCommonCache.java:147)
	at groovy.lang.GroovyClassLoader.parseClass(GroovyClassLoader.java:336)
	at groovy.lang.GroovyShell.parseClass(GroovyShell.java:546)
	at groovy.lang.GroovyShell.parse(GroovyShell.java:558)
	at groovy.lang.GroovyShell.evaluate(GroovyShell.java:442)
	at groovy.lang.GroovyShell.evaluate(GroovyShell.java:481)
	at groovy.lang.GroovyShell.evaluate(GroovyShell.java:452)
	at org.codehaus.groovy.tools.shell.util.PackageHelperImpl.getPackagesAndClassesFromJigsaw(PackageHelperImpl.groovy:151)
	at org.codehaus.groovy.tools.shell.util.PackageHelperImpl.getPackages(PackageHelperImpl.groovy:125)
	at org.codehaus.groovy.tools.shell.util.PackageHelperImpl.initializePackages(PackageHelperImpl.groovy:62)
	at org.codehaus.groovy.tools.shell.util.PackageHelperImpl.<init>(PackageHelperImpl.groovy:51)
	at java.base/jdk.internal.reflect.DirectConstructorHandleAccessor.newInstance(DirectConstructorHandleAccessor.java:67)
	at java.base/java.lang.reflect.Constructor.newInstanceWithCaller(Constructor.java:499)
	at java.base/java.lang.reflect.Constructor.newInstance(Constructor.java:483)
	at org.codehaus.groovy.reflection.CachedConstructor.invoke(CachedConstructor.java:80)
	at org.codehaus.groovy.runtime.callsite.ConstructorSite$ConstructorSiteNoUnwrapNoCoerce.callConstructor(ConstructorSite.java:105)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCallConstructor(CallSiteArray.java:59)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callConstructor(AbstractCallSite.java:237)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callConstructor(AbstractCallSite.java:249)
	at org.codehaus.groovy.tools.shell.Groovysh.<init>(Groovysh.groovy:112)
	at org.codehaus.groovy.tools.shell.Groovysh.<init>(Groovysh.groovy:101)
	at org.codehaus.groovy.tools.shell.Groovysh.<init>(Groovysh.groovy:140)
	at org.apache.tinkerpop.gremlin.console.GremlinGroovysh.<init>(GremlinGroovysh.groovy:45)
	at java.base/jdk.internal.reflect.DirectConstructorHandleAccessor.newInstance(DirectConstructorHandleAccessor.java:67)
	at java.base/java.lang.reflect.Constructor.newInstanceWithCaller(Constructor.java:499)
	at java.base/java.lang.reflect.Constructor.newInstance(Constructor.java:483)
	at org.codehaus.groovy.reflection.CachedConstructor.invoke(CachedConstructor.java:80)
	at org.codehaus.groovy.runtime.callsite.ConstructorSite$ConstructorSiteNoUnwrapNoCoerce.callConstructor(ConstructorSite.java:105)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCallConstructor(CallSiteArray.java:59)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callConstructor(AbstractCallSite.java:237)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callConstructor(AbstractCallSite.java:257)
	at org.apache.tinkerpop.gremlin.console.Console.<init>(Console.groovy:100)
	at java.base/jdk.internal.reflect.DirectConstructorHandleAccessor.newInstance(DirectConstructorHandleAccessor.java:67)
	at java.base/java.lang.reflect.Constructor.newInstanceWithCaller(Constructor.java:499)
	at java.base/java.lang.reflect.Constructor.newInstance(Constructor.java:483)
	at org.codehaus.groovy.reflection.CachedConstructor.invoke(CachedConstructor.java:80)
	at org.codehaus.groovy.runtime.callsite.ConstructorSite$ConstructorSiteNoUnwrapNoCoerce.callConstructor(ConstructorSite.java:105)
	at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCallConstructor(CallSiteArray.java:59)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callConstructor(AbstractCallSite.java:237)
	at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callConstructor(AbstractCallSite.java:265)
	at org.apache.tinkerpop.gremlin.console.Console.main(Console.groovy:524)
Caused by: java.lang.IllegalArgumentException: Unsupported class file major version 62
	at groovyjarjarasm.asm.ClassReader.<init>(ClassReader.java:196)
	at groovyjarjarasm.asm.ClassReader.<init>(ClassReader.java:177)
	at groovyjarjarasm.asm.ClassReader.<init>(ClassReader.java:163)
	at groovyjarjarasm.asm.ClassReader.<init>(ClassReader.java:284)
	at org.codehaus.groovy.ast.decompiled.AsmDecompiler.parseClass(AsmDecompiler.java:81)
	at org.codehaus.groovy.control.ClassNodeResolver.findDecompiled(ClassNodeResolver.java:251)
	at org.codehaus.groovy.control.ClassNodeResolver.tryAsLoaderClassOrScript(ClassNodeResolver.java:189)
	at org.codehaus.groovy.control.ClassNodeResolver.findClassNode(ClassNodeResolver.java:169)
	at org.codehaus.groovy.control.ClassNodeResolver.resolveName(ClassNodeResolver.java:125)
	at org.codehaus.groovy.control.ResolveVisitor.resolveToOuter(ResolveVisitor.java:853)
	at org.codehaus.groovy.control.ResolveVisitor.resolve(ResolveVisitor.java:467)
	at org.codehaus.groovy.control.ResolveVisitor.resolveFromDefaultImports(ResolveVisitor.java:629)
	at org.codehaus.groovy.control.ResolveVisitor.resolveFromDefaultImports(ResolveVisitor.java:612)
	at org.codehaus.groovy.control.ResolveVisitor.resolveFromDefaultImports(ResolveVisitor.java:586)
	at org.codehaus.groovy.control.ResolveVisitor.resolve(ResolveVisitor.java:465)
	at org.codehaus.groovy.control.ResolveVisitor.resolve(ResolveVisitor.java:428)
	at org.codehaus.groovy.control.ResolveVisitor.transformVariableExpression(ResolveVisitor.java:1120)
	at org.codehaus.groovy.control.ResolveVisitor.transform(ResolveVisitor.java:871)
	at org.codehaus.groovy.control.ResolveVisitor.transformMethodCallExpression(ResolveVisitor.java:1266)
	at org.codehaus.groovy.control.ResolveVisitor.transform(ResolveVisitor.java:879)
	at org.codehaus.groovy.ast.expr.Expression.transformExpressions(Expression.java:49)
	at org.codehaus.groovy.ast.expr.ArgumentListExpression.transformExpression(ArgumentListExpression.java:67)
	at org.codehaus.groovy.control.ResolveVisitor.transform(ResolveVisitor.java:888)
	at org.codehaus.groovy.control.ResolveVisitor.transformMethodCallExpression(ResolveVisitor.java:1264)
	at org.codehaus.groovy.control.ResolveVisitor.transform(ResolveVisitor.java:879)
	at org.codehaus.groovy.control.ResolveVisitor.transformDeclarationExpression(ResolveVisitor.java:1291)
	at org.codehaus.groovy.control.ResolveVisitor.transform(ResolveVisitor.java:875)
	at org.codehaus.groovy.ast.ClassCodeExpressionTransformer.visitExpressionStatement(ClassCodeExpressionTransformer.java:142)
	at org.codehaus.groovy.ast.stmt.ExpressionStatement.visit(ExpressionStatement.java:40)
	at org.codehaus.groovy.ast.CodeVisitorSupport.visitBlockStatement(CodeVisitorSupport.java:86)
	at org.codehaus.groovy.ast.ClassCodeVisitorSupport.visitBlockStatement(ClassCodeVisitorSupport.java:106)
	at org.codehaus.groovy.control.ResolveVisitor.visitBlockStatement(ResolveVisitor.java:1553)
	at org.codehaus.groovy.ast.stmt.BlockStatement.visit(BlockStatement.java:69)
	at org.codehaus.groovy.ast.ClassCodeVisitorSupport.visitClassCodeContainer(ClassCodeVisitorSupport.java:110)
	at org.codehaus.groovy.ast.ClassCodeVisitorSupport.visitConstructorOrMethod(ClassCodeVisitorSupport.java:121)
	at org.codehaus.groovy.ast.ClassCodeExpressionTransformer.visitConstructorOrMethod(ClassCodeExpressionTransformer.java:53)
	at org.codehaus.groovy.control.ResolveVisitor.visitConstructorOrMethod(ResolveVisitor.java:257)
	at org.codehaus.groovy.ast.ClassCodeVisitorSupport.visitMethod(ClassCodeVisitorSupport.java:132)
	at org.codehaus.groovy.ast.ClassNode.visitContents(ClassNode.java:1103)
	at org.codehaus.groovy.ast.ClassCodeVisitorSupport.visitClass(ClassCodeVisitorSupport.java:54)
	at org.codehaus.groovy.control.ResolveVisitor.visitClass(ResolveVisitor.java:1465)
	at org.codehaus.groovy.control.ResolveVisitor.startResolving(ResolveVisitor.java:230)
	at org.codehaus.groovy.control.CompilationUnit$13.call(CompilationUnit.java:700)
	at org.codehaus.groovy.control.CompilationUnit.applyToSourceUnits(CompilationUnit.java:965)
	... 47 more
make[1]: *** [gremlin-console] Error 1
make: *** [test_openjdk_18_x64] Error 2
```

## Working versions - Java 8, 11

I haven't tested every version of Java out there, but here are two that I know works on M1. Test with `make test_openjdk_11_x64` or `make test_oracle_8_x64`:

```
jrr@jrrmbp ~/r/gremlin-console-jvms (main) > make test_openjdk_11_x64
file `which java`
/Users/jrr/repos/gremlin-console-jvms/.jdks/openjdk_11_x64/jdk-11.0.2.jdk/Contents/Home/bin/java: Mach-O 64-bit executable x86_64
java -version
openjdk version "11.0.2" 2019-01-15
OpenJDK Runtime Environment 18.9 (build 11.0.2+9)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.2+9, mixed mode)
make gremlin-console
.gremlin-console/apache-tinkerpop-gremlin-console/bin/gremlin.sh
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/Users/jrr/repos/gremlin-console-jvms/.gremlin-console/apache-tinkerpop-gremlin-console/lib/groovy-2.5.14-indy.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
plugin activated: tinkerpop.server
plugin activated: tinkerpop.utilities
plugin activated: tinkerpop.tinkergraph
gremlin>
```
