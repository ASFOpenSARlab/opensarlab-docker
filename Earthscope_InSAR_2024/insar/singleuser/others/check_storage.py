#!/usr/bin/env python
import shutil
import sys 

if len(sys.argv) > 1:
    user_name = sys.argv[1]
else:
    user_name = 'user' 

r = shutil.disk_usage('/home/jovyan/')

# If less than about 1 MB
if r.free < (1 * 1024 * 1024):
    raise Exception(f'Out of storage space. Cannot start server. Please contact OpenSciencelab admin for assistance.')

print(f"Home directory storage for {user_name} is {r}")
