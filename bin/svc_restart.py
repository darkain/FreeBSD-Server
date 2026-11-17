#!/usr/bin/env python3

import json, os, subprocess, sys



# Quick helper function
def exec(cmd):
	return subprocess.run(cmd, text=True, capture_output=True)



# Get initial binary file list
restart				= "--restart" in sys.argv
raw					= exec(["checkrestart", "--libxo", "json"]).stdout.strip()
procs				= json.loads(raw).get("checkrestart", {}).get("process", [])
bins				= {p["arguments"].split()[0] for p in procs if p.get("arguments", "").startswith("/")}



# Map binaries -> packages -> rc.d services
services			= set()
for binary in bins:
	pkg				= exec(["pkg", "which", "-q", binary]).stdout.strip()
	if pkg:
		files		= exec(["pkg", "info", "-l", pkg]).stdout.splitlines()
		services.update(os.path.basename(f.strip()) for f in files if "/etc/rc.d/" in f)



# Check status and restart if --restart was passed
results				= []
for svc in sorted(services):
	running			= exec(["service", svc, "status"]).returncode == 0
	action			= "skipped"
	if running:
		if restart:
			ok		= exec(["service", svc, "restart"]).returncode == 0
			action	= "restarted" if ok else "failed"
		else:
			action	= "would_restart"
	results.append({"service": svc, "running": running, "action": action})



# Final output
print(json.dumps(results, indent=2))
