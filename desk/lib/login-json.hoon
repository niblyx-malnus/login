/-  *login
|%
++  enjs
  =,  enjs:format
  |%
  ++  enjs-session
    |=  =session
    ^-  json
    %-  pairs
    ~[expiry-time+s/(scot %da expiry-time.session)]
  ::
  ++  enjs-sessions
    |=  =sessions
    ^-  json
    =-  o/(malt -)
    %+  turn  ~(tap by sessions)
    |=  [k=@uv s=session]
    [(scot %uv k) `json`(enjs-session s)]
  ::
  ++  enjs-user
    |=  =user
    ^-  json
    %-  pairs
    :~  password+s/password.user
        sessions+(enjs-sessions sessions.user)
    ==
  ::
  ++  enjs-users
    |=  =users
    ^-  json
    =-  o/(malt -)
    %+  turn  ~(tap by users)
    |=  [k=username u=user]
    :_  `json`(enjs-user u)
    ?-  -.k
      %u  +.k
      %p  (scot %p +.k)
    ==
  ::
  ++  enjs-bloc
    |=  =bloc
    ^-  json
    %-  pairs
    :~  title+s/title.bloc
        users+(enjs-users users.bloc)
    ==
  ::
  ++  enjs-blocs
    |=  =blocs
    ^-  json
    =-  o/(malt -)
    %+  turn  ~(tap by blocs)
    |=  [k=bloc-path b=bloc]
    [(spat k) `json`(enjs-bloc b)]
  --
--
