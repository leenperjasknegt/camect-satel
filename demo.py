# -*- coding: utf-8 -*-
from __future__ import unicode_literals, print_function
import sys
import requests
import time
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

from .constants import PARTITION, ZONE, OUTPUT
from . import Integra

camecturl = "camect.local"
camectpassword = "service"
integrazone = "Poort"
integrapartition = "Camera's"

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
    if integrapartition in armed_partitions and integrazone in violated_zones :
           print ("Armed")
           r = requests.post('camecturl', data={'Enable': '0'}, verify=False, auth=('admin', 'camectpassword'))
    else:
           print ("Disarmed")
           r = requests.post('camecturl', verify=False, auth=('admin', 'camectpassword'))


while(True):
    armed_partitions = ', '.join(
        integra.get_name(PARTITION, part).name
        for part in integra.get_armed_partitions()
)

    violated_zones = ', '.join(
        integra.get_name(ZONE, zone).name
        for zone in integra.get_violated_zones()
)

    checkArmStatus()
    time.sleep(3)
