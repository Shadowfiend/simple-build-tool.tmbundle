(set $running-sbt nil)

(class SbtTask is PHBTask
  (+ sbtTask is
    (((SbtTask) alloc) init))

  (- init is
    (let (defined-sbt (((current-text) environment) objectForKey:"SBT_PATH"))
      (let (sbt-path (if (!= defined-sbt nil) defined-sbt (else "/usr/local/bin/sbt")))
        (super initWithBufferName:"*sbt-buffer*" launchPath:sbt-path isShellScript:YES)))

    self)
    
  (- prepareWebapp:(BOOL)continuously is
    (self runCommand:"prepare-webapp" continuously:continuously))
    
  (- jettyRestart:(BOOL)continuously is
    (self runCommand:"jetty-restart" continuously:continuously))
    
  (- jettyRun is
    (self runCommand:"jetty-run" continuously:NO))
  
  (- jettyStop is
    (self runCommand:"jetty-stop" continuously:NO))
    
  (- runCommand:(id)commandString continuously:(BOOL)continuously is
    (let (command
            (do (prefix)
              (self writeString:(+ "\n" prefix commandString "\n"))))
    (self writeString:(command (if continuously "~" else ""))))))

(function start-sbt ()
  (if (eq $running-sbt nil)
    (run-sbt)))

(function stop-sbt ()
  (unless (eq $running-sbt nil)
    (quit-sbt)))

(function sbt-started? ()
  (not (eq $running-sbt nil)))

(function run-sbt ()
  (set $running-sbt (SbtTask sbtTask))
  ($running-sbt start))

(function quit-sbt ()
  ($running-sbt exit)
  (set $running-sbt nil))

(function tell-sbt ()
  (unless $running-sbt
    (run-sbt))

  $running-sbt)

(let ((map (ExMap defaultMap))
      (sbt-handler
        (do (ex-command)
          (let (arg (ex-command arg))
            (case (ex-command arg)
              (nil (start-sbt))
              ("start" (start-sbt))
              ("stop" (stop-sbt))
              ("jetty-stop" ((tell-sbt) jettyStop))
              ("jetty-run" ((tell-sbt) jettyRun))
              ("jetty-restart" ((tell-sbt) jettyRestart:NO))
              ("prepare-webapp" ((tell-sbt) prepareWebapp:NO))
              ("~jetty-restart" ((tell-sbt) jettyRestart:YES))
              ("~prepare-webapp" ((tell-sbt) prepareWebapp:YES))
              (else (ex-command message:(+ "Unrecognized argument " arg "."))))))))
    (map define:"sbt" syntax:"e1" as:sbt-handler))

(let ((map (ViMap normalMap))
      (single-commands '("sj" "jetty-run"
                         "ss" "jetty-stop"))
      (continuous-commands '("sp" "prepare-webapp"
                             "sr" "jetty-restart")))
  (single-commands eachPair:(do (shortcut command)
    (let ((shortcut (+ "," shortcut))
          (command (+ "<esc>:sbt " command "<cr>")))
      (map unmap:shortcut)
      (map map:shortcut to:command))))
  (continuous-commands eachPair:(do (shortcut command)
    (let ((shortcut (+ "," shortcut))
          (continuous-shortcut (+ ",r" shortcut))
          (command (+ "<esc>:sbt " command "<cr>"))
          (continuous-command (+ "<esc>:sbt ~" command "<cr>")))
      (map unmap:shortcut)
      (map map:shortcut to:command)

      (map unmap:continuous-shortcut)
      (map map:continuous-shortcut to:continuous-command)))))
