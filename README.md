Simple addon that allows you to schedule commands to be run after a specific interval.

Interval must be specified in seconds (`15s`) or minutes (`3m`).

It can do `/slash` commands, or just run a specific command via `RunScript()`.
## Usage:
```
  /schedule <time> <command>
  Time format: number\[s|m] (e.g., 30, 60s, 1m)
  Commands starting with / are executed as slash commands
  Commands without / are executed as Lua code
```
## Examples:
```
  /schedule 30s /say Hello World
  /schedule 1m 'Lua code executed!'
```
## Why?
This was primarily done so I can toggle Hekili Cooldowns on/off, but other people may find some other utility for it.

For example, a simple macro with the following contents:
```
/hek set cooldowns
/schedule 45s Hekili:FireToggle( "cooldowns", "on")
```
Will toggle cooldowns on/off, then after 45 seconds it will turn them back on.
Alternatively:
```
/hek set cooldowns
/schedule 45s /hek set cooldowns on
```
This results in the same action.
