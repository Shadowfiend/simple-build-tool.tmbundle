simple-build-tool.tmbundle
================================

This bundle is meant to provide easy interactions with an in-editor running sbt
instance. It provides a set of sbt equivalent commands within vico, and some
shortcut mappings to control it.

It uses pointy-haired-boss.tmbundle, which provides the underlying implementation
for running a process in a vico buffer.

Things Implemented
------------------

* sbt jetty-run, jetty-stop, jetty-restart, prepare-webapp -- These run their
  equivalents in sbt. The first one will create a new buffer in a new tab that
  will contain the sbt output.
* A variety of normal-mode shortcuts to run the above:
  - ,sj -- jetty-run
  - ,ss -- jetty-stop
  - ,sp -- prepare-webapp
  - ,sr -- jetty-restart

  sp and sr can be preceded by an r (,rsr, ,rsp) to run the continuous version
  (~prepare-webapp, ~jetty-restart).

Future
------

More to come. Ideally, it'd be nice to make :sbt <whatever> just pass that
command over to sbt. Also, syntax highlighting for the sbt buffer and a couple of 
other things would be nice.

License
-------

This bundle is provided under the terms of the MIT License. See the LICENSE file in
this same directory.

Author
------

This bundle is copyright me, Antonio Salazar Cardozo, and licensed under the
terms of the MIT license. No warranties are made, express or implied. See the
LICENSE file in this same directory for more details.

I have a rather sporadically updated blog at http://shadowfiend.posterous.com/

I am the Chief Software Engineer at OpenStudy (http://openstudy.com/); we're
working on making the world one big study group.
