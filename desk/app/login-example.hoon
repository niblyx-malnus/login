/+  login, server, dbug, verb, default-agent
|%
+$  state-0  [%0 ~]
::
+$  eyre-id  @ta
+$  card  card:agent:gall
++  four-oh-four
  |=  =eyre-id
  ^-  (list card)
  %+  give-simple-payload:app:server
    eyre-id
  :-  [404 ['Content-Type'^'text/html']~]
  `(as-octt:mimes:html "404 - Not Found")
++  hello-world
  |=  =eyre-id
  ^-  (list card)
  %+  give-simple-payload:app:server
    eyre-id
  :-  [200 ['Content-Type'^'text/html']~]
  `(as-octt:mimes:html "Hello! You are logged in to an example website.")
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    lgn   ~(. login bowl)
::
++  on-init  
  ^-  (quip card _this)
  :_  this
  [%pass /eyre/connect %arvo %e %connect [~ /login/example] dap.bowl]~
::
++  on-save  !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  [~ this(state old)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark  (on-poke:def mark vase)
    ::  %handle-http-request: incoming from eyre
    ::
      %handle-http-request
    =+  !<([eyre-id=@ta =inbound-request:eyre] vase)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    ::
    =/  group=(pair ship term)  [~halbex-palheb %uf-public]
    =/  =bloc-path:lgn  (group-to-bloc-path:lgn group ~)
    ::
    =+  usr=(authenticated:lgn bloc-path request.inbound-request)
    ?.  |(?=(^ usr) authenticated.inbound-request) :: always allow host ship
      :_(this (bloc-login-redirect:lgn eyre-id bloc-path (spat site)))
    ::
    :_  this
    ?.   ?=(%'GET' method.request.inbound-request)
      (four-oh-four eyre-id)
    ?.  ?=([%login %example ~] site)
      (four-oh-four eyre-id)
    (hello-world eyre-id)
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?+  path  (on-watch:def path)
    [%http-response *]  [~ this]
  ==
::
++  on-agent  on-agent:def
++  on-peek   on-peek:def
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  sign-arvo  (on-arvo:def wire sign-arvo)
      [%eyre %bound *]
    ~?  !accepted.sign-arvo
      [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
    [~ this]
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--

