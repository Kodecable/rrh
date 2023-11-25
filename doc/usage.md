# RRH Usage

## **Scenes**

### Using AUR Helper

1. Create `/etc/rrh/user` with your username or another non-root user. This user will be used when executing update commands.
2. Edit `/etc/rrh/cmd/update` and replace the command with your AUR Helper.

### Timely remind update when login

If you are using bash, add the following command to your `.bashrc`:

```bash
rrh-echo-reminder
```

Now, when you log in and the system is outdated, you will receive a reminder: `This system has not been updated for a long time`

### Execute Custom Script When the System is Outdated

RRH provides a simple way to do that.

1. Edit the `/etc/rrh/cmd/auto_check_outdated` script.
2. Give it execute permissions.
3. Enable the `rrh-daily-check.timer`.

`/etc/rrh/cmd/auto_check_outdated` can be any program/script. For example, using Python to send an email:

```python
#!/bin/python3
import smtplib
import socket
from datetime import datetime
from email.message import EmailMessage

text = "Your system has not been updated for a long time.\n"
text += "\nHostname: " + socket.gethostname()
text += "\nCurrent Time: "
text += datetime.now().strftime('%Y-%m-%d %H:%M:%S')
text += "\nLast Update Time:"
text += subprocess.check_output(['rrh-last-time', '-h']).decode("utf-8")
text += "\n"

msg = EmailMessage()
msg['Subject'] = 'System outdated warning'
msg['From'] = 'sender@example.com'
msg['To'] = 'receiver@example.com'
msg.set_content(text)

server = smtplib.SMTP(server)
server.login(from_email, 'password')
server.send_message(msg)
server.quit()
```

## Command

### rfu

A symbolic link to rrh-full-update

### rrh-auto-remove

```
Usage: rrh-auto-remove [KEEP_COUNT]
Remove all the action except latest [KEEP_COUNT]. May require root.
KEEP_COUNT priority: argument > /etc/rrh/auto_remove_keep_count > '5'
```

This command call rrh-remove-action to remove actions, so lastest action will not be removed by it.

### rrh-cat-output

```
Usage: rrh-cat-output [ACTION_ID]
Print the output of action.
```

If no id is provided, using lastest.

### rrh-doas

```
Usage: rrh-doas USER COMMAND...
RRH unified interface for user switching.
```

see [doc/configuration#Doas](https://github.com/Kodecable/rrh/blob/main/doc/configuration.md#Doas).

### rrh-echo-reminder

```
Usage: rrh-echo-reminder [-t OUTDATE_TIME] [-s REMIND_TEXT]
Print REMIND_TEXT when system outdated.

  OUTDATE_TIME    see 'rrh-is-outdate --help'
  REMIND_TEXT     text (default 'This system has not been updated for a long time')
```

This command call `rrh-is-outdated` to whether the system has outdated.

### rrh-full-update

Full system update.

1. Execute `/etc/rrh/cmd/pre_update` as root; if failed, exit.
2. Execute `/etc/rrh/cmd/update` as the configured user and collect output.
3. Execute `/etc/rrh/cmd/post_update` as root.

All the argument provided will be passed to the `/etc/rrh/cmd/update`.

Regardless of whether the update command is successful or not, `rrh-mark-update` will be execute.

### rrh-is-outdated

```
Usage: rrh-is-outdate [OUTDATE_TIME]
Test whether the system has outdated.

  OUTDATE_TIME    Outdate time in second(s)

OUTDATE_TIME priority: argument > /etc/rrh/outdate_time > '7 days'
If it is more than 'OUTDATE_TIME' since the last update,
exit with 0, otherwise exit with non-0.
```

### rrh-last-time

```
Usage: rrh-last-time [-h]
Print the the time of the last update.

  -h    Human-readable time format
```

### rrh-view-output

```
Usage: rrh-view-output [ACTION_ID]
View the output of action.
```

### rrh-list-action

```
Usage: rrh-list-action
List actions.
```

### rrh-mark-update

```
Usage: rrh-mark-update
Mark once update. May require root.
```

### rrh-output-digest

```
Usage: rrh-output-digest [OPTION]... [FILE]
Analyze command output and generate digest.

  -c WHEN     use color (default 'auto')
              WHEN is 'always', 'never', or 'auto'
  -n NUM      print NUM lines of output context (default 1)
  -h          print this message and exit

With no FILE or FILE is '-', read standard input.
```

### rrh-remove-action

```
Usage: rrh-remove-action ID
Remove a action. May require root.
This utility will refuse to remove the latest action.
```

### rrh-remove-action

```
Usage: rrh-remove-action ID
Remove a action. May require root.
This utility will refuse to remove the latest action.
```

### rrh-auto-check

```
Usage: rrh-auto-check [OUTDATE_TIME]
Execute custom script when system outdated.

  OUTDATE_TIME    see 'rrh-is-outdated --help'
```

## Data Storage

Data is located at `/var/lib/rrh`.

* `last`: Action ID of the last action.
* `last_time`: Last update time (Unix time, UTC).
* `actions`: Command output and exit code.

### Actions

* `output`: Command output, including both stdout and stderr.
* `exit_code`: Exit code.
