/-  *login
/+  login, server, dbug, verb, default-agent
:: import during development to force compilation
::
/=  lc-  /mar/login/command
::
|%
+$  state-0  [%0 =blocs]
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
    lgn   ~(. login bowl)
    hc    ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /eyre/connect %arvo %e %connect [~ /host/login] dap.bowl]~
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
      %login-command
    =/  cmd=command  !<(command vase)
    ?-    -.cmd
        %code
      =/  =bloc  (~(got by blocs) bloc-path.cmd)
      =/  =user  (~(got by users.bloc) p+src.bowl)
      :_  this
      :~  :*  %pass  /  %agent  [our.bowl %hood]  %poke
              %helm-send-hi  !>([src.bowl (some "code: {(trip password.user)}")])
      ==  ==
      ::
        %step
      =^  cards  this  :: no cards; ignore cards
        (on-poke login-command+!>(new-pass+[bloc-path.cmd p+src.bowl]))
      =/  =bloc  (~(got by blocs) bloc-path.cmd)
      =/  =user  (~(got by users.bloc) p+src.bowl)
      :_  this
      :~  :*  %pass  /  %agent  [our.bowl %hood]  %poke
              %helm-send-hi  !>([src.bowl (some "new-code: {(trip password.user)}")])
      ==  ==
      ::
        %new-pass
      ?>  =(src.bowl our.bowl)
      =/  =bloc          (~(got by blocs) bloc-path.cmd)
      =/  =user          (~(got by users.bloc) username.cmd)
      =.  password.user  (generate-password:hc)
      =.  users.bloc     (~(put by users.bloc) username.cmd user)
      `this(blocs (~(put by blocs) bloc-path.cmd bloc))
      ::
        %add-bloc
      ?>  =(src.bowl our.bowl)
      =/  =users  (generate-users:hc ~(tap in usernames.cmd))
      =/  =bloc  [title.cmd users]
      `this(blocs (~(put by blocs) bloc-path.cmd bloc))
      ::
        %del-bloc
      ?>  =(src.bowl our.bowl)
      `this(blocs (~(del by blocs) bloc-path.cmd))
      ::
        %set-bloc-title
      ?>  =(src.bowl our.bowl)
      =/  =bloc  (~(got by blocs) bloc-path.cmd)
      `this(blocs (~(put by blocs) bloc-path.cmd bloc(title title.cmd)))
      ::
        %add-users
      ?>  =(src.bowl our.bowl)
      =/  =bloc  (~(got by blocs) bloc-path.cmd)
      =/  new-usernames=(list username)
        ~(tap in (~(dif in ~(key by users.bloc)) usernames.cmd))
      =.  users.bloc
        (~(uni by users.bloc) (generate-users:hc new-usernames))
      `this(blocs (~(put by blocs) bloc-path.cmd bloc))
      ::
        %del-users
      ?>  =(src.bowl our.bowl)
      ?>  =(src.bowl our.bowl)
      =/  =bloc  (~(got by blocs) bloc-path.cmd)
      =.  users.bloc
        %-  ~(gas by *users)
        %+  murn  ~(tap by users.bloc)
        |=  [=username =user]
        ?:  (~(has in usernames.cmd) username)
          ~
        (some [username user])
      `this(blocs (~(put by blocs) bloc-path.cmd bloc))
      ::
        %logout
      ?>  ?|  =(src.bowl our.bowl)
              ?>(?=(%p -.username.cmd) =(src.bowl +.username.cmd))
          ==
      :-  ~  %=  this
          blocs
        ?^  usid.cmd
          (del-session [bloc-path username u.usid]:cmd)
        (clear-sessions [bloc-path username]:cmd)
      ==
    ==
    ::
      %handle-http-request
    =+  !<([=eyre-id =inbound-request:eyre] vase)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    ::
    ?.  ?=([@tas @tas @tas *] site)  :_(this (four-oh-four:hc eyre-id))
    ::
    =/  =bloc-path  t.t.site
    =/  ubloc=(unit bloc)  (~(get by blocs) bloc-path)
    ?~  ubloc  :_(this (four-oh-four:hc eyre-id))
    ::
    ?+    method.request.inbound-request
      :_(this (four-hundred:hc eyre-id))
      ::
        %'GET'
      :_  this
      =/  redirect  (get-header:http 'redirect' args)
      (bloc-path-login:hc eyre-id bloc-path redirect %.n)
      ::
        %'POST'
      ?~  body.request.inbound-request
        :_(this (bloc-path-login:hc eyre-id bloc-path ~ %.n))
      ::
      =/  parsed=(unit (list [key=@t value=@t]))
        (rush q.u.body.request.inbound-request yquy:de-purl:html)
      ?~  parsed
        :_(this (bloc-path-login:hc eyre-id bloc-path ~ %.n))
      ::
      =/  redirect=(unit @t)  (get-header:http 'redirect' u.parsed)
      ?~  un=(get-header:http 'username' u.parsed)
        :_(this (bloc-path-login:hc eyre-id bloc-path redirect %.n))
      ::
      =/  =username  (rash u.un parse-username:lgn)
      ?.  (~(has by users.u.ubloc) username)
        :_(this (bloc-path-login:hc eyre-id bloc-path redirect %.n))
      ::
      ?~  password=(get-header:http 'password' u.parsed)
        :_(this (bloc-path-login:hc eyre-id bloc-path redirect %.n))
      ::
      ?.  =(u.password password:(~(got by users.u.ubloc) username))
        :_(this (bloc-path-login:hc eyre-id bloc-path redirect %.y))
      ::  mint a unique session cookie
      ::
      =/  sesh=(map @uv session)
        %.  all-sessions:hc
        ~(gas by *(map @uv session))
      =/  sid=@uv
        |-
        =/  candidate=@uv  (~(raw og eny.bowl) 128)
        ?.  (~(has by sesh) candidate)
          candidate
        $(eny.bowl (shas %try-again candidate))
      ::  record cookie and record expiry time
      ::
      =/  first-session=?  =(~ sesh)
      =/  expires-at=@da  (add now.bowl session-timeout)
      =/  =session  [expires-at]
      =.  blocs     (put-session:hc bloc-path username sid session)
      ::
      =/  cookie-line=@t
        (session-cookie-string bloc-path username sid &)
      =/  set-cookie=(list card)
        (set-cookie:hc eyre-id redirect cookie-line)
      ::  if we didn't have any cookies previously,
      ::  start the expiry timer
      ::
      =/  set-timer=(list card)
        ?.  first-session  ~
        [%pass /sessions/expire %arvo %b %wait expires-at]~
      ::
      :_(this (welp set-timer set-cookie))
    ==
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
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %all-paths ~]  ``noun+!>(~(tap in ~(key by blocs)))
    ::
      [%x %all-usernames ~]
    :-  ~  :-  ~  :-  %noun  !>
    ^-  (jug bloc-path username)
    %-  ~(gas by *(map bloc-path (set username)))
    %+  turn  ~(tap by blocs)
    |=  [=bloc-path =bloc]
    ^-  [^bloc-path (set username)]
    [bloc-path ~(key by users.bloc)]
    ::
      [%x %authenticated uv=@t pu=?(%p %u) user=@t rest=[@ta *]]
    =/  =sid        (slav %uv uv.pole)
    =/  =username
      ?-  pu.pole
        %u  [%u user.pole]
        %p  [%p (slav %p user.pole)]
      ==
    =/  =bloc-path  rest.pole
    :-  ~  :-  ~  :-  %noun  !>
    ?~  session=(get-session bloc-path username sid)
      ~
    ?.  (lte now.bowl expiry-time.u.session)  ~
    (some username)
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%sessions %expire ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
        [%behn %wake *]
      ?^  error.sign-arvo  (on-arvo:def wire sign-arvo)
      ::  remove cookies that have expired
      ::
      =.  blocs  purge-expired:hc
      ::  if there are any cookies left,
      ::  set a timer for the next expected expiry
      
      =/  sesh=(list [@uv session])  all-sessions:hc
      ::
      :_  this
      ?:  =(~ sesh)  ~
      =;  next-expiry=@da
        [%pass /sessions/expire %arvo %b %wait next-expiry]~
      %+  roll  sesh
      |=  [[@uv session] next=@da]
      ?:  =(*@da next)  expiry-time
      (min next expiry-time)
    ==
    ::
      [%eyre %connect ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
        [%eyre %bound *]
      ~?  !accepted.sign-arvo
        [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
      [~ this]
    ==
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
|_  =bowl:gall
+*  lgn  ~(. login bowl)
++  four-oh-four
  |=  =eyre-id
  ^-  (list card)
  %+  give-simple-payload:app:server
    eyre-id
  :-  [404 ['Content-Type'^'text/html']~]
  `(as-octt:mimes:html "404 - Not Found")
::
++  four-hundred
  |=  =eyre-id
  ^-  (list card)
  %+  give-simple-payload:app:server
    eyre-id
  :-  [400 ['Content-Type'^'text/html']~]
  `(as-octt:mimes:html "404 - Bad Request")
::
++  bloc-path-login
  |=  [=eyre-id =bloc-path redirect-url=(unit @t) failed=?]
  ^-  (list card)
  =/  data=octs  (login-page bloc-path redirect-url failed)
  =/  =response-header:http
    :-  400
    :~  ['Content-Type' 'text/html']
        ['Content-Length' (crip (format-ud-as-integer p.data))]
    ==
  (give-simple-payload:app:server eyre-id response-header `data)
::
++  generate-password
  |.(`@t`(rsh 3 (scot %p (end 6 (shaf now.bowl (shax eny.bowl))))))
::
++  generate-users
  |=  usernames=(list username)
  ^-  users
  %-  ~(gas by *users)
  |-
  ?~  usernames  ~
  :-  [i.usernames [(generate-password) ~]]
  %=  $
    usernames     t.usernames
    now.bowl  +(now.bowl)
  ==
::
++  set-cookie
  |=  [=eyre-id redirect-url=(unit @t) cookie-line=@t]
  ^-  (list card)
  ?~  redirect-url
    %+  give-simple-payload:app:server
      eyre-id
    :_(~ [204 ['Set-Cookie' cookie-line]~])
  =/  actual-redirect  ?:(=(u.redirect-url '') '/' u.redirect-url)
  %+  give-simple-payload:app:server
    eyre-id
  :_  ~
  :-  303
  :~  ['Location' actual-redirect]
      ['Set-Cookie' cookie-line]
  ==
::  session-timeout: the delay before an idle session expires
::
++  session-timeout  ~d7
::
++  purge-expired
  %-  ~(gas by *^blocs)
  %+  turn  ~(tap by blocs)
  |=  [=bloc-path =bloc]
  :-  bloc-path
  %=    bloc
      users
    %-  ~(gas by *users)
    %+  turn  ~(tap by users.bloc)
    |=  [=username =user]
    :-  username
    %=    user
        sessions
      %-  ~(gas by *sessions)
      %+  skip  ~(tap by sessions.user)
      |=  [cookie=@uv session]
      (lth expiry-time now.bowl)
    ==
  ==
::
++  all-sessions
  ^-  (list [@uv session])
  %-  zing
  %+  turn  ~(val by blocs)
  |=  =bloc
  ^-  (list [@uv session])
  %-  zing
  %+  turn  ~(val by users.bloc)
  |=(=user ~(tap by sessions.user))
::
++  get-session
  |=  [=bloc-path =username =sid]
  ^-  (unit session)
  =/  b=(unit bloc)  (~(get by blocs) bloc-path)
  ?~  b  ~
  =/  u=(unit user)  (~(get by users.u.b) username)
  ?~  u  ~
  (~(get by sessions.u.u) sid)
:: 
++  put-session
  |=  [=bloc-path =username =sid =session]
  ^-  ^blocs
  =/  =bloc          (~(got by blocs) bloc-path)
  =/  =user          (~(got by users.bloc) username)
  =.  sessions.user  (~(put by sessions.user) sid session)
  =.  users.bloc     (~(put by users.bloc) username user)
  (~(put by blocs) bloc-path bloc)
::
++  del-session
  |=  [=bloc-path =username =sid]
  ^-  ^blocs
  =/  =bloc          (~(got by blocs) bloc-path)
  =/  =user          (~(got by users.bloc) username)
  =.  sessions.user  (~(del by sessions.user) sid)
  =.  users.bloc     (~(put by users.bloc) username user)
  (~(put by blocs) bloc-path bloc)
::
++  clear-sessions
  |=  [=bloc-path =username]
  ^-  ^blocs
  =/  =bloc          (~(got by blocs) bloc-path)
  =/  =user          (~(got by users.bloc) username)
  =.  sessions.user  ~
  =.  users.bloc     (~(put by users.bloc) username user)
  (~(put by blocs) bloc-path bloc)
::
++  session-cookie-string
  |=  [=bloc-path =username =sid extend=?]
  ^-  @t
  %-  crip
  =/  cookie-key  "login-{(spam:lgn bloc-path)}"
  =/  username  ?-(-.username %p (scow %p +.username), %u (trip +.username))
  =/  cookie-val  "{username}&{(scow %uv sid)}"
  =;  max-age=tape
    "{cookie-key}={cookie-val}; Path=/; Max-Age={max-age}"
  %-  format-ud-as-integer
  ?.  extend  0
  (div (msec:milly session-timeout) 1.000)
::  +format-ud-as-integer: prints a number for consumption outside urbit
::
++  format-ud-as-integer
  |=  a=@ud
  ^-  tape
  ?:  =(0 a)  ['0' ~]
  %-  flop
  |-  ^-  tape
  ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
::
++  dojo-line
  |=  [cs=?(%code %step) =ship =bloc-path]
  ^-  tape
  ":{(scow %p ship)}/login &login-command {(trip cs)}+{(spud bloc-path)}"
::  +login-page: internal page to login to an Urbit
::
++  login-page
  |=  [=bloc-path redirect-url=(unit @t) failed=?]
  ^-  octs
  =/  =bloc  (~(got by blocs) bloc-path)
  =+  redirect-str=?~(redirect-url "" (trip u.redirect-url))
  %-  as-octs:mimes:html
  %-  crip
  %-  en-xml:html
  =/  favicon  %+
    weld  "<svg width='10' height='10' viewBox='0 0 10 10' xmlns='http://www.w3.org/2000/svg'>"
          "<circle r='3.09' cx='5' cy='5' /></svg>"
  ;html
    ;head
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1, shrink-to-fit=no");
      ;link(rel "icon", type "image/svg+xml", href (weld "data:image/svg+xml;utf8," favicon));
      ;title:"{(trip title.bloc)} Login"
      ;style:'''
             @import url("https://rsms.me/inter/inter.css");
             @font-face {
                 font-family: "Source Code Pro";
                 src: url("https://storage.googleapis.com/media.urbit.org/fonts/scp-regular.woff");
                 font-weight: 400;
                 font-display: swap;
             }
             :root {
               --red05: rgba(255,65,54,0.05);
               --red100: rgba(255,65,54,1);
               --blue05: rgba(33,157,255,0.05);
               --blue30: rgba(33,157,255,0.3);
               --blue100: rgba(33,157,255,1);
               --black05: rgba(0,0,0,0.05);
               --black20: rgba(0,0,0,0.2);
               --black60: rgba(0,0,0,0.6);
               --white: rgba(255,255,255,1);
             }
             html {
               font-family: Inter, sans-serif;
               height: 100%;
               margin: 0;
               width: 100%;
               background: var(--white);
               color: var(--black100);
               -webkit-font-smoothing: antialiased;
               line-height: 1.5;
               font-size: 12px;
               display: flex;
               flex-flow: row nowrap;
               justify-content: center;
             }
             body {
               display: flex;
               flex-flow: column nowrap;
               justify-content: center;
               max-width: 300px;
               padding: 1rem;
               width: 100%;
             }
             body > *,
             form > input {
               width: 100%;
             }
             form {
               display: flex;
               flex-flow: column;
               align-items: flex-start;
             }
             input {
               background: transparent;
               border: 1px solid var(--black20);
               padding: 8px;
               border-radius: 4px;
               font-size: inherit;
               color: var(--black);
               box-shadow: none;
             }
             input:disabled {
               background: var(--black05);
               color: var(--black60);
             }
             input:focus {
               outline: none;
               border-color: var(--blue30);
             }
             input:invalid:not(:focus) {
               background: var(--red05);
               border-color: var(--red100);
               outline: none;
               color: var(--red100);
             }
             input:invalid ~ #submit button[type=submit] {
               border-color: currentColor;
               background: var(--blue05);
               color: var(--blue30);
               pointer-events: none;
             }
             button {
               margin-top: 16px;
               padding: 8px 16px;
               border-radius: 4px;
               background: var(--blue100);
               color: var(--white);
               border: 1px solid var(--blue100);
             }
             table {
               margin-left: auto;
               margin-right: auto;
             }
             span.failed {
               display: flex;
               flex-flow: row nowrap;
               height: 16px;
               align-items: center;
               margin-top: 6px;
               color: var(--red100);
             }
             span.failed svg {
               height: 12px;
              margin-right: 6px;
             }
             span.failed circle,
             span.failed line {
               fill: transparent;
               stroke: currentColor
             }
             .mono {
               font-family: 'Source Code Pro', monospace;
             }
             @media all and (prefers-color-scheme: dark) {
               :root {
                 --white: rgb(51, 51, 51);
                 --black100: rgba(255,255,255,1);
                 --black05: rgba(255,255,255,0.05);
                 --black20: rgba(255,255,255,0.2);
               }
             }
             '''
    ==
    ;body
      ;form(action "/host/login{(spud bloc-path)}", method "post", enctype "application/x-www-form-urlencoded")
        ;h1: {(trip title.bloc)}
        ;p:"Urbit ID"
        ;input
          =name         "username"
          =placeholder  "{(scow %p ~sampel-palnet)}"
          =required     "true"
          =class        "mono";
        ;p:"Access Key"
        ;input
          =type  "password"
          =name  "password"
          =placeholder  "sampel-ticlyt-migfun-falmel"
          =class  "mono"
          =required  "true"
          =minlength  "27"
          =maxlength  "27"
          =pattern  "((?:[a-z]\{6}-)\{3}(?:[a-z]\{6}))"
          =autofocus  "true";
        ;input(type "hidden", name "redirect", value redirect-str);
        ;+  ?.  failed  ;span;
          ;span.failed
            ;svg(xmlns "http://www.w3.org/2000/svg", viewBox "0 0 12 12")
              ;circle(cx "6", cy "6", r "5.5");
              ;line(x1 "3.27", y1 "3.27", x2 "8.73", y2 "8.73");
              ;line(x1 "8.73", y1 "3.27", x2 "3.27", y2 "8.73");
            ==
            Ship/Key pair is incorrect
          ==
        ;input#code
          =type   "hidden"
          =value  (dojo-line %code our.bowl bloc-path);
        ;input#step
          =type   "hidden"
          =value  (dojo-line %step our.bowl bloc-path);
        ;table#submit
          ;tr
            ;td
              ;button(onclick "copyText('code')", title "Copy and paste in dojo for Access Key"):"Code"
            ==
            ;td(width "10px"): 
            ;td
              ;button(type "submit"):"Continue"
            ==
            ;td(width "10px"): 
            ;td
              ;button(onclick "copyText('step')", title "Copy and paste in dojo for new Access Key"):"Step"
            ==
          ==
        ==
      ==
    ==
    ;script:'''
            var failSpan = document.querySelector('.failed');
            if (failSpan) {
              document.querySelector("input[type=password]")
                .addEventListener('keyup', function (event) {
                  failSpan.style.display = 'none';
                });
            }
            function copyText(id) {
              var Text = document.getElementById(id);
              Text.select();
              navigator.clipboard.writeText(Text.value);
            }
            '''
  ==
--
