:: Copy this into your desk to use with the %login agent.
::
|_  =bowl:gall
++  sour  (scot %p our.bowl)
++  snow  (scot %da now.bowl)
+$  bloc-path  path
++  spam
  |=  =bloc-path
  ^-  tape
  (zing (turn ['&' (join '&' `(list @t)`bloc-path)] trip))
::
+$  username
  $%  [%p ship]
      [%u cord] :: alphanumeric, '~', '-' and '_' (ship names reserved)
  ==
++  parse-username
  ;~  pose
    (cook (lead %p) ;~(pfix sig fed:ag))
    (cook (cork crip (lead %u)) (star ;~(pose alp sig cab)))
  ==
::
+$  sid   @uv
++  parse-sid  (cook @uv ;~(pfix (jest '0v') viz:ag))
::
++  parse-cookie-val
  ;~  (glue pam)
    parse-username
    parse-sid
  ==
::
++  session-pair-from-request
  |=  [=bloc-path =request:http]
  ^-  (unit [=username =sid])
  ?~  cookie-header=(get-header:http 'cookie' header-list.request)  ~
  ?~  cookies=(rush u.cookie-header cock:de-purl:html)  ~
  =/  cookie-key  (crip "login-{(spam bloc-path)}")
  ?~  cookie-val=(get-header:http cookie-key u.cookies)  ~
  (rush u.cookie-val parse-cookie-val)
::
++  group-to-bloc-path
  |=  [flag=(pair ship term) sect=(unit term)]
  ^-  bloc-path
  ?~  sect
    /landscape/groups/(scot %p p.flag)/[q.flag]
  /landscape/groups/(scot %p p.flag)/[q.flag]/[u.sect]
::
++  authenticated
  |=  [=bloc-path =request:http]
  ^-  (unit username)
  :: check that %login agent is running
  ::
  ?.  .^(? %gu /[sour]/login/[snow])  ~
  ?~  sp=(session-pair-from-request bloc-path request)  ~
  .^  (unit username)
    %gx
    ;:  welp
        /[sour]/login/[snow]
        :~  %authenticated
            (scot %uv sid.u.sp)
            -.username.u.sp
            ?-  -.username.u.sp
              %u  +.username.u.sp
              %p  (scot %p +.username.u.sp)
            ==
        ==
        bloc-path
        /noun
    ==
  ==

:: stolen from /lib/server.hoon in the %base desk
::
++  give-simple-payload
  |=  [eyre-id=@ta =simple-payload:http]
  ^-  (list card:agent:gall)
  =/  header-cage
    [%http-response-header !>(response-header.simple-payload)]
  =/  data-cage
    [%http-response-data !>(data.simple-payload)]
  :~  [%give %fact ~[/http-response/[eyre-id]] header-cage]
      [%give %fact ~[/http-response/[eyre-id]] data-cage]
      [%give %kick ~[/http-response/[eyre-id]] ~]
  ==
::
++  bloc-login-redirect
  |=  [eyre-id=@ta =bloc-path redirect=cord]
  ^-  (list card:agent:gall)
  %+  give-simple-payload  eyre-id
  =/  prefix  (crip "/host/login{(spud bloc-path)}?redirect=")
  [[303 ['Location' (cat 3 prefix redirect)]~] ~]
--
