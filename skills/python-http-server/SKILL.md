---
name: python-http-server
description: "Manage Python simple HTTP servers. Trigger phrases: \"serve\", \"start a server\", \"serve this directory\", \"http server\", \"stop the server\", \"list servers\", \"kill the server\", \"what's running on port\""
---

Manage Python HTTP servers started with `python3 -m http.server`.

## On every invocation

First, run:
```bash
ps aux | grep "python3 -m http.server" | grep -v grep
```
Parse each line to extract PID, port, and directory. Hold this as the current server list.

---

## Determine intent from $ARGUMENTS

### Start a server — `$ARGUMENTS` is a directory path (or empty)

1. Use the provided path, or `.` if none given.
2. Try ports in order: 8000, 8080, 8888. For each, check if it's free:
   ```bash
   lsof -ti:<port>
   ```
   Use the first port with no output.
3. If all three ports are busy, tell the user and stop.
4. Start the server in the background:
   ```bash
   python3 -m http.server <port> --directory <path> &
   ```
5. Confirm: `Server started at http://localhost:<port> serving <path>`

---

### List servers — `$ARGUMENTS` is empty, `list`, or `status`

Display the running servers in a table:

```
PID    Port   Directory
-----  -----  ---------
12345  8000   /path/to/dir
12346  8080   /other/dir
```

If none are running, say so.

Then use AskUserQuestion: "Would you like to stop any of these servers?"
Present each server as an option (e.g. `Port 8000 — /path/to/dir (PID 12345)`) plus **Stop all** and **Never mind**.

After stopping, re-run the list and show updated status.

---

### Stop a specific server — `$ARGUMENTS` is `stop <port>` or `kill <port>`

1. Find the process on that port:
   ```bash
   lsof -ti:<port>
   ```
2. If nothing is found, tell the user no server is running on that port.
3. Kill it:
   ```bash
   kill <PID>
   ```
4. Confirm which server was stopped (port + directory).

---

### Stop all servers — `$ARGUMENTS` is `stop` or `stop all`

1. If no servers are running, say so and stop.
2. Use AskUserQuestion: "Stop all <N> running servers?" — **Yes** / **Cancel**.
3. If confirmed:
   ```bash
   pkill -f "python3 -m http.server"
   ```
4. Re-run the process list and confirm all are gone.
