import subprocess
import sys
from datetime import date, datetime


def diff_days(date1, date2):
	return abs((date2 - date1).days)


def to_date(data):
	try:
		return datetime.fromisoformat(data)
	except ValueError:
		return None


# COMMAND TO LIST SNAPSHOTS
search = [
	'/sbin/zfs', 'list',
	'-H',               # NO HEADERS
	'-o', 'name',       # OUTPUT ONLY NAMES
	'-t', 'snapshot',   # ONLY OUTPUT SNAPSHOTS
	'zroot/mysql',      # PATH TO OUTPUT
]


# COMMAND TO DESTROY SNAPSHOTS
# FINAL PARAM WILL BE FILLED LATER
destroy = [
	'/sbin/zfs', 'destroy', ''
]


# PULL LIST OF SNAPSHOTS
result = subprocess.run(search, capture_output=True, text=True)
if result.returncode != 0:
	sys.exit(result.returncode)


# LOOP THROUGH EACH SNAPSHOT
for line in result.stdout.splitlines():

  # CONVERT STRING TO DATETIME OBJECT
	day = to_date(line[-10:])
	if day is None:
		continue

  # DONT DELETE ANYTHING IN THE 30 MOST RECENT DAYS
	if diff_days(day, datetime.today()) > 30:

    # DONT DELETE A "MONTHLY" SNAPSHOT
		if day.day == 1:
			print('KEEPING: ' + line)

    # OKAY, WE'RE GOOD! NUKE FROM ORBIT
		else:
			destroy[2] = line
			print(destroy)
			subprocess.run(destroy)
