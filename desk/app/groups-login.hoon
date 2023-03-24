/-  *login, g=groups
/+  server, dbug, verb, default-agent
::
|%
+$  state-0  [%0 ~]
+$  eyre-id  @ta
+$  card  card:agent:gall
--
::
=|  state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. +> [bowl ~])
    cc    |=(cards=(list card) ~(. +> [bowl cards]))
::
++  on-init
  ^-  (quip card _this)
  :: defer subscription until all agents are running
  :_(this [%pass / %agent [our dap]:bowl %poke noun+!>(~)]~)
:: 
++  on-save  !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  :_(this(state old) [%pass / %agent [our dap]:bowl %poke noun+!>(~)]~)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark  (on-poke:def mark vase)
      %noun
    ?.  has-login:hc  ~&("WARNING: %groups not installed." `this)
    :_  this
    ?:  (~(has by wex.bowl) /groups our.bowl %groups)  ~
    [%pass /groups %agent [our.bowl %groups] %watch /groups]~
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+    pole  (on-agent:def pole sign)
      [%groups ~]
    ?+    -.sign  (on-agent:def pole sign)
        %watch-ack
      ?~  p.sign
        =/  tang  [leaf+"%groups-login: subscribed to /groups from %groups."]~
        =^  cards  state  abet:reconcile-groups-login:hc
        ((slog tang) [cards this])
      ::
      =/  tang
        :_  u.p.sign
        leaf+"%groups-login: failed to subscribe to /groups from %groups."
      ((slog tang) `this)
      ::
        %kick
      :_(this [%pass /groups %agent [our.bowl %groups] %watch /groups]~)
      ::
        %fact
      ?+    p.cage.sign  `this
          %group-action-0
        ~&  %reconciling-groups-login
        =^  cards  state  abet:reconcile-groups-login:hc
        [cards this]
        :: =/  =action:g  !<(action:g q.cage.sign)
        :: =/  =flag:g  p.action
        :: =/  =diff:g  q.q.action
        :: =/  ships=(set ^ship)  p.diff
        :: ?+    -.diff  `this
        ::     %fleet
        ::   ?-    -.q.diff
        ::     %add        `this
        ::     %del        `this
        ::     %add-sects  `this
        ::     %del-sects  `this
        ::   ==
        :: ==
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
::
|_  [=bowl:gall cards=(list card)]
+*  core  .
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
::
++  make-bloc-path
  |=  [=flag:g usect=(unit sect:g)]
  ^-  bloc-path
  =/  pfx  /landscape/groups/(scot %p p.flag)/[q.flag]
  ?~  usect  pfx
  (welp pfx /[u.usect])
::
++  convert-fleet
  |=  [=flag:g =fleet:g]
  ^-  (jug bloc-path username)
  =/  flit  ~(tap by fleet)
  =|  =(jug bloc-path username)
  |-
  ?~  flit  jug
  =/  =username           p+p.i.flit
  =/  sects=(set sect:g)  sects.q.i.flit
  %=    $
    flit  t.flit
      jug
    %-  ~(gas ju jug)
    :-  [(make-bloc-path flag ~) username]
    %+  murn  ~(tap in sects)
    |=  =sect:g
    ?.  ((sane %tas) sect)  ~
    %-  some
    [(make-bloc-path flag `sect) username]
  ==
::
++  convert-fleets
  |=  fleets=(map flag:g fleet:g)
  ^-  (jug bloc-path username)
  %-  ~(gas by *(jug bloc-path username))
  %-  zing  %+  turn
    (turn ~(tap by fleets) convert-fleet)
  |=(=(jug bloc-path username) ~(tap by jug))
::
++  jug-dif
  |=  $:  a=(jug bloc-path username)
          b=(jug bloc-path username)
      ==
  ^-  (jug bloc-path username)
  %-  ~(gas by *(jug bloc-path username)) :: by, not ju
  %+  turn  ~(tap by a)
  |=  [=bloc-path =(set username)]
  ^-  [^bloc-path (^set username)]
  [bloc-path (~(dif in set) (~(gut by b) bloc-path ~))]
::
++  add-bloc
  |=  [=bloc-path title=@t usernames=(set username)]
  ^-  _core
  =/  cmd=command  [%add-bloc bloc-path title usernames]
  (emit %pass / %agent [our.bowl %login] %poke login-command+!>(cmd))
::
++  del-bloc
  |=  =bloc-path
  ^-  _core
  =/  cmd=command  [%del-bloc bloc-path]
  (emit %pass / %agent [our.bowl %login] %poke login-command+!>(cmd))
::
++  add-many-bloc
  |=  bloc-paths=(list [bloc-path @t (set username)])
  ^-  _core
  ?~  bloc-paths  core
  %=  $
    bloc-paths  t.bloc-paths
    core        (add-bloc:core i.bloc-paths)
  ==
::
++  del-many-bloc
  |=  bloc-paths=(list bloc-path)
  ^-  _core
  ?~  bloc-paths  core
  %=  $
    bloc-paths  t.bloc-paths
    core        (del-bloc:core i.bloc-paths)
  ==
::
++  mod-user-set
  |=  [mod=?(%add %del) =bloc-path usernames=(set username)]
  ^-  _core
  =/  cmd=command
    ?-  mod
      %add  [%add-users bloc-path usernames]
      %del  [%del-users bloc-path usernames]
    ==
  (emit %pass / %agent [our.bowl %login] %poke login-command+!>(cmd))
::
++  mod-many-user-sets
  |=  [mod=?(%add %del) bloc-paths=(list [bloc-path (set username)])]
  ^-  _core
  ?~  bloc-paths  core
  %=  $
    bloc-paths  t.bloc-paths
    core        (mod-user-set:core mod i.bloc-paths)
  ==
::
++  group-title
  |=  =bloc-path
  ^-  cord
  ?>  ?=([%landscape %groups @ta @ta *] bloc-path)
  =/  =flag:g  [(slav %p i.t.t.bloc-path) i.t.t.t.bloc-path]
  (~(got by all-titles) flag)
::
++  reconcile-groups-login
  ^-  _core
  =/  fleet-usernames      (convert-fleets all-fleets)
  :: add new blocs with titles and usernames
  ::
  =/  new-blocs=(list bloc-path)
    %~  tap  in
    %.  ~(key by landscape-usernames)
    ~(dif in ~(key by fleet-usernames))
  =.  core
    %-  add-many-bloc:core
    %+  turn  new-blocs
    |=  =bloc-path
    :*  bloc-path
        (group-title bloc-path)
        (~(got by fleet-usernames) bloc-path)
    ==
  :: delete vanished blocs
  ::
  =/  old-blocs=(list bloc-path)
    %~  tap  in
    %.  ~(key by fleet-usernames)
    ~(dif in ~(key by landscape-usernames))
  =.  core  (del-many-bloc:core old-blocs)
  ::  add new users to blocs
  ::
  =.  core
    %-  mod-many-user-sets:core
    [%add ~(tap by (jug-dif fleet-usernames landscape-usernames))]
  :: del vanished users from blocs
  ::
  %-  mod-many-user-sets:core
  [%del ~(tap by (jug-dif landscape-usernames fleet-usernames))]
::
++  sour  (scot %p our.bowl)
++  snow  (scot %da now.bowl)
++  has-login  .^(? %gu /[sour]/login/[snow])
++  all-groups  .^(groups:g %gx /[sour]/groups/[snow]/groups/groups)
++  all-fleets
  ^-  (map flag:g fleet:g)
  %-  ~(gas by *(map flag:g fleet:g))
  %+  turn  ~(tap by all-groups)
  |=([=flag:g =group:g] [flag fleet.group])
++  all-titles
  ^-  (map flag:g cord)
  %-  ~(gas by *(map flag:g cord))
  %+  turn  ~(tap by all-groups)
  |=([=flag:g =group:g] [flag title.meta.group])
++  all-bloc-paths
  .^((list bloc-path) %gx /[sour]/login/[snow]/all-paths/noun)
++  landscape-paths
  ^-  (list bloc-path)
  %+  murn  all-bloc-paths
  |=  =bloc-path
  ?.  ?=([%landscape %groups *] bloc-path)
    ~
  (some bloc-path)
++  all-usernames
  .^  (jug bloc-path username)  %gx
      /[sour]/login/[snow]/all-usernames/noun
  ==
++  landscape-usernames
  ^-  (jug bloc-path username)
  %-  ~(gas by *(jug bloc-path username))  :: by, not ju
  %+  murn  ~(tap by all-usernames)
  |=  [=bloc-path =(set username)]
  ?.  ?=([%landscape %groups *] bloc-path)
    ~
  (some [bloc-path set])
--
