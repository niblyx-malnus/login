|%
+$  bloc-path  path
::
+$  username
  $%  [%p ship]
      [%u cord] :: alphanumeric, '~', '-' and '_' (ship names reserved)
  ==
+$  password   @t
+$  sid   @uv
+$  session
  $:  expiry-time=@da
  ==
+$  sessions  (map sid session)
+$  user
  $:  =password
      =sessions
  ==
+$  users  (map username user)
+$  bloc
  $:  title=@t
      =users
  ==
+$  blocs  (map bloc-path bloc)
::
+$  command
  $%  [%code =bloc-path]
      [%step =bloc-path]
      [%new-pass =bloc-path =username]
      [%add-bloc =bloc-path title=@t usernames=(set username)]
      [%del-bloc =bloc-path]
      [%set-bloc-title =bloc-path title=@t]
      [%add-users =bloc-path usernames=(set username)]
      [%del-users =bloc-path usernames=(set username)]
      [%logout =bloc-path =username usid=(unit sid)]
  ==
--
