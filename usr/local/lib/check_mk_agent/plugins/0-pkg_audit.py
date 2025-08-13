#!/usr/bin/env python3

__version__ = "2.5.0b1"

import sys
import json
import subprocess

out		= subprocess.run(['/usr/local/sbin/pkg', 'audit', '--raw=json-compact', '-q'], capture_output=True, text=True)
data	= json.loads(out.stdout)
count	= data.get("pkg_count", 0)

if count > 0:
	packages = ", ".join(data.get("packages", {}).keys())
	sys.stdout.write(f"1 Audit issues={count} Pkg: {packages} vulnerable\n")
else:
	sys.stdout.write("0 Audit issues=0 OK\n")
