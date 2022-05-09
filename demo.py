# -*- coding: utf-8 -*-
from __future__ import unicode_literals, print_function
import sys
import requests
import time

from .constants import PARTITION, ZONE, OUTPUT
from . import Integra



template = '''\
Model:            {0[model]}
Version:          {0[version]}
Time:             {1}
Armed partitions: {2}
Violated zones:   {3}
Active outputs:   {4}
-------------------------------------------------------------------------------
10 last events:
{5}
'''

if len(sys.argv) < 2:
    print("demo <IP_ADDRESS_OF_THE_ETHM1_MODULE>", file=sys.stderr)
    sys.exit(1)



integra = Integra(user_code=1234, host=sys.argv[1])
armed_partitions = ', '.join(
    integra.get_name(PARTITION, part).name
    for part in integra.get_armed_partitions()
)

def checkArmStatus():
    if "Camera's" in armed_partitions:
           print ("Armed")
           r = requests.get('http://localhost:9000/arm')
           r = requests.post('https://192.168.0.150/api/EnableAlert', data={'Enable': '0'}, verify=False, auth=('admin', 'service'))
    else:
           print ("Disarmed")
           r = requests.get('http://localhost:9000/disarm')
           r = requests.post('https://192.168.0.150/api/EnableAlert', verify=False, auth=('admin', 'service'))

while(True):
    armed_partitions = ', '.join(
        integra.get_name(PARTITION, part).name
        for part in integra.get_armed_partitions()
)


    checkArmStatus()
    time.sleep(3)