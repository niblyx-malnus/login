# %login
Maintain a database of usernames and passwords for websites you serve from your urbit.

- Uses logic lifted from `%eyre` to extend username/password login with cookies to users beyond yourself.
- Contains an agent which stores and allows basic CRUD operations for usernames, passwords, and cookie sessions
  associated with different "blocs."
- A "bloc" is a collection of usernames and passwords associated with something, like a landscape group or a realm space
  or some other means of grouping users.
- A bloc is referenced by a `path`.
- Usernames can either be `@p`s or combinations of alphanumeric characters and `~`, `-` and `_`.
- Contains an agent which automatically creates blocs for all landscape groups you are a part of.

## Use in other desks
1. Copy `/lib/login.hoon` into your desk.
2. Import this library into your agent with `/+  login`.
3. Create an alias for the core therein with `+*  lgn  ~(. login bowl)`.
4. Use `(authenticated:lgn /bloc/path request)` to check if a request is made by an authenticated user.
5. `authenticated:lgn` returns a `(unit user)`. If this is `~` there is no authenticated user.
6. In the case of a `~`, you can use `(bloc-login-redirect:lgn eyre-id /bloc/path /redirect/destination)` to go to the login page.
7. Read `/app/login-example.hoon` for an example. See this example live at https://niblyx-malnus.arvo.network/login/example.

# Groups Bloc Paths
The `%groups-login` agent will automatically sync groups to bloc-paths in the `%login` agent. A group bloc-path
takes the form of `/landscape/groups/[group-host-ship]/[group-name]`. There are also bloc-paths for group roles,
for example `/landscape/groups/~halbex-palheb/uf-public/admin`.

# Logging In
To get your login for a particular bloc-path, poke the host's agent in the dojo with the following command:
```
:~hostyv-palnet/login &login-command code+/bloc/path
```
There is a button to copy the relevant command for the specific bloc on the login page.

## Installation
1. Clone this repo.
2. Boot up a ship (fakezod or moon or whatever you use).
4. `|new-desk %login` to create a new desk called `%login`.
5. `|mount %login` to access the `%login` desk from the unix command line.
6. At the unix command line `rm -rf [ship-name]/login/*` to empty out the contents of the desk.
7. `cp -r login/desk/* [ship-name]/login` to copy the contents of this repo into your new desk.
8. At the dojo command line `|commit %login`.
9. Install with `|install our %login`.

# Future Work
Lots to improve. Issues and PRs welcome.
