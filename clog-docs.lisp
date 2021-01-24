;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; CLOG - The Common Lisp Omnificent GUI                                 ;;;;
;;;; (c) 2020-2021 David Botton                                            ;;;;
;;;; License BSD 3 Clause                                                  ;;;;
;;;;                                                                       ;;;;
;;;; clog-docs.lisp                                                        ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :clog)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exports - clog documentation sections
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsection @clog-getting-started (:title "CLOG Getting Started")
"# CLOG - The Common Lisp Omnificent GUI

## David Botton <david@botton.com>

License BSD 3-Clause License

View the HTML Documentation:

https://rabbibotton.github.io/clog/clog-manual.html

### Introduction

The Common Lisp Omnificent GUI, CLOG for short, uses web technology to
produce graphical user interfaces for applications locally or remotely.
CLOG can take the place, or work alongside, most cross-platform GUI
frameworks and website frameworks. The CLOG package starts up the
connectivity to the browser or other websocket client (often a browser
embedded in a native template application.)

STATUS: CLOG is complete enough for most uses. While there are loose
ends (multimedia, database integrations), CLOG is actually based on
GNOGA, a framework I wrote for Ada in 2013 and used in commercial
production code for the last 6 years, i.e. the techiniques CLOG uses
are solid and proven.

Some potential applications for CLOG:

* Cross-platform GUIs and Reports
* Secure websites and complex interactive web applications
* Mobile software
* Massive multiplayer online games
* Monitoring software for embedded systems
* A fun way to teach programming and advanced multi-tasking
  parallel programming techniques. (CLOG is a parallel GUI)
* And the list goes on

The key to CLOG is the relationship it forms with a Browser window
or Browser control compiled to native code. CLOG uses websockets
for communications and the browser to render a GUI that maintains
an active soft realtime connection. For most CLOG applications all
programming logic, events and decisions are done on the server
which can be local or remote over the web.

CLOG is developed on an M1 MacBook with ECL, it is tested fairly
regulary with SCBL on Linux, Windows and Intel MacBook. It should
in theory work on any system Quicklisp and CLACK will load on to.

CLOG will be in Quicklisp in the next update, but because I am still 
adding code daily, it is currently preferable to clone the github repo
into your ~/common-lisp directory:

```
cd ~/common-lisp
git clone https://github.com/rabbibotton/clog.git
```

To load this package and work through tutorials (assuming you
have Quicklisp configured):

1. cd to the CLOG dir (the dir should be one used by Quicklisp ex. ~/common-lisp/)
2. Start emacs/slime or your common lisp \"repl\" in _that_ directory.
3. In the REPL, run:

CL-USER> (ql:quickload :clog)
CL-USER> (load \"~/common-lisp/clog/tutorial/01-tutorial.lisp\")
CL-USER> (clog-user:start-tutorial)

Work your way through the tutorials. You will see how quick and easy it is
to be a CLOGer.

  ")

(defsection @clog-event-data (:title "CLOG Event Data")
"
Some events in CLOG return in addition to the target event, event data.
The data is passed in the second argument to the event handler as a 
property list. To retrieve the data use (getf data :property) the available
properties (to use for :property) are based on the event type.

From clog-base

     :event-type   :mouse
     :x            x relative to the target
     :y            y relative to the target
     :screen-x     x relative to the users screen
     :screen-y     y relative to the users screen
     :which-button which mouse button clicked
     :alt-key      t or nil if alt-key held down
     :ctrl-key     t or nil if ctrl-key held down
     :shift-key    t or nil if shift-key held down
     :meta-key     t or nil if meta-key held down


     :event-type     :touch
     :x              x relative to the target
     :y              y relative to the target
     :screen-x       x relative to the users screen
     :screen-y       y relative to the users screen
     :number-fingers number of fingers being used
     :alt-key        t or nil if alt-key held down
     :ctrl-key       t or nil if ctrl-key held down
     :shift-key      t or nil if shift-key held down
     :meta-key       t or nil if meta-key held down

     :event-type :keyboard
     :key-code   A key code sometimes called a scan code for the key pressed
     :char-code  UTF-8 representation for key pressed when possible
     :alt-key    t or nil if alt-key held down
     :ctrl-key   t or nil if ctrl-key held down
     :shift-key  t or nil if shift-key held down
     :meta-key   t or nil if meta-key held down

From clog-window

     :event-type :storage
     :key        local storage key that was updated (even in another window)
     :old-value  old key value
     :value      new key value


")

(defsection @clog-internals (:title "CLOG Framework internals and extensions")
"## Responding to new java script DOM events

If there is no data for the event just changing the name of the event is
sufficient in this example:

```lisp
(defmethod set-on-click ((obj clog-obj) handler)
  (set-event obj \"click\"
	     (when handler
	       (lambda (data)
		 (declare (ignore data))
		 (funcall handler obj)))))
```

If there is data for the event an additional string containing the needed
java-script to return the even data and a function to parse out the data.

Replace the event name with the correct name, parse-keyboard-even with the
parse function and the string containing the needed JavaScrip replaces
keyboard-event-script:

* The event handlers setter

```lisp
(defmethod set-on-key-down ((obj clog-obj) handler)
  (set-event obj \"keydown\"
	     (when handler
	       (lambda (data)
		 (funcall handler obj (parse-keyboard-event data))))
	     :call-back-script keyboard-event-script))   
```

* The script

```lisp
(defparameter keyboard-event-script
  \"+ e.keyCode + ':' + e.charCode + ':' + e.altKey + ':' + e.ctrlKey + ':' +
     e.shiftKey + ':' + e.metaKey\")
```

* The event parser

```lisp
(defun parse-keyboard-event (data)
  (let ((f (ppcre:split \":\" data)))
    (list
     :event-type :keyboard
     :key-code   (parse-integer (nth 0 f) :junk-allowed t)
     :char-code  (parse-integer (nth 1 f) :junk-allowed t)
     :alt-key    (js-true-p (nth 2 f))
     :ctrl-key   (js-true-p (nth 3 f))
     :shift-key  (js-true-p (nth 4 f))
     :meta-key   (js-true-p (nth 5 f)))))
```

")