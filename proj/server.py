# CS 131 Project
# Parallelizable proxy for the Google Places API using asyncio 3.6.4

# USAGE:
# Configure each server individually with:
# $ python3 server.py <serverName>

# Accepted server names are:
#     Goloman
#     Hands
#     Holiday
#     Wilkes
#     Welsh

import asyncio
import time
import sys
import json
import logging
import re

# Port numbers hard-coded as per spec
servers = {
    "Goloman": 15905,
    "Hands": 15906,
    "Holiday": 15907,
    "Wilkes": 15908,
    "Welsh": 15909
}

# Conversing servers defined as per spec
neighbors = {
    "Goloman": {"Hands", "Holiday", "Wilkes"},
    "Hands": {"Wilkes", "Goloman"},
    "Holiday": {"Welsh", "Wilkes", "Goloman"},
    "Wilkes": {"Goloman", "Hands", "Holiday"},
    "Welsh": {"Holiday"}
}

# To enable C-style "switch" statements
class switch(object):
    curr = None
    def __new__(class_, curr):
        class_.curr = curr
        return True
def case(*args):
    return any(arg == switch.curr for arg in args)

# Server setup
class Server(asyncio.Protocol):
    def __init__(self, name, portno, neighbors, loop):
        self.name = name
        self.portno = portno
        self.neighbors = neighbors
        self.loop = loop
        self.locations = dict()
        logging.info("\nStarting server %s on localhost:%s.\n" % (name, portno))

    async def __call__(self, r, w):
        info = await r.read(50000)
        get = info.decode()
        logging.info("\nServer %s received message:\n%s\n" % (self.name, get))
        await self.serve(get, w)

    # Flooding algorithm as per spec
    async def flooding(self, info, block):
        for neighbor, portno in self.neighbors.items():
            a, w = await asyncio.open_connection('localhost', portno, loop=self.loop)
            del a
            w.write((("%s %s" % (info, self.name)).encode()))
            await w.drain()
            w.close()

    # Send GET request to Google Places API
    async def getPlace(self, location, radius, limit):
        request = ('GET /maps/api/place/nearbysearch/json?location={location}&radius={radius}&key={key} {http}\r\n'
                 'Host: maps.googleapis.com:443\r\n'
                 'Connection: close\r\n'
                 '\r\n')
        request = request.format(location=location, radius=radius, key="AIzaSyDDSU_q46zukEobGbiGc_GtHDtSLRTiSJU", http="HTTP/1.1")
        r, w = await asyncio.open_connection("maps.googleapis.com", 443, ssl=True)
        w.write(request.encode())
        await w.drain()
        pResp = await r.read()
        w.close()
        response = pResp.decode()
        data = json.loads(response[response.find("{"):None])
        data['results'] = len(data['results']) <= limit and data['results'] or data['results'][None:limit]
        return json.dumps(data, sort_keys=True, indent=4, separators=(',', ': ')) + "\n" + "\n"

    # Serve requests
    async def serve(self, get, w):
        response = ""
        message = get.split()
        tStamp = time.time()
        s = message[0]
        while switch (s):
            # IAMAT
            if case("IAMAT") and len(message) == 4:
                if re.match(r'^[\+-]\d+\.\d+[\+-]\d+\.\d+$', message[-2]) and float(message[-1]) >= 0:
                    response = "AT %s %s %s" % (self.name, tStamp - float(message[-1]), get[get.find(message[-3]):None])
                    if message[-3] not in self.locations:
                        self.locations[message[-3]] = (self.name, tStamp - float(message[-1]), get[get.find(message[-3]):None])
                        asyncio.ensure_future(self.flooding(response, dict()), loop=self.loop)
                    else:
                        a, b, past = self.locations[message[-3]]
                        if float(past.split()[-1]) < float(message[-1]):
                            self.locations[message[-3]] = (self.name, tStamp - float(message[-1]), get[get.find(message[-3]):None])
                            asyncio.ensure_future(self.flooding(response, dict()), loop=self.loop)
                else:
                    response = "? %s" % get
                break
            # WHATSAT
            if case("WHATSAT") and len(message) == 4:
                if int(message[-2]) >= 0 and int(message[-1]) < 20 and int(message[-1]) >= 0 and int(message[-2]) < 50 and (message[-3] in self.locations):
                    a, b, request = self.locations[message[-3]]
                    del a
                    del b
                    coord = ','.join(re.findall(r'[+-]\d+\.\d+', request.split()[1]))
                    response = ("AT %s %s %s\n" % self.locations[message[-3]]) + (await self.getPlace(coord, int(message[-2]), int(message[-1])))
                else:
                    response = "? %s" % get
                break
            # AT
            if case("AT") and (len(message) == 7 or len(message) == 6):
                if message[3] not in self.locations:
                    self.locations[message[3]] = (message[1], message[2], get[get.find(message[3]):get.rfind(message[-1])])
                    block = {message[-1]}
                else:
                    a, b, old = self.locations[message[3]]
                    del a
                    del b
                    old = old.split()
                    if float(old[-1]) > float(message[-2]):
                        self.locations[message[3]] = (message[1], message[2], get[get.find(message[3]):None])
                    else:
                        return
                    block = {message[1], message[-1]}
                asyncio.ensure_future(self.flooding(' '.join(message[None:-1]), block), loop=self.loop)
                return
                break
            # DEFAULT
            response = "? %s" % get
            break
        logging.info("\nSending response:\n%s" % response)
        w.write(response.encode())
        await w.drain()
        w.close()

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    name = sys.argv[-1]
    portno = servers[name]
    loop = asyncio.get_event_loop()
    server = loop.run_until_complete(asyncio.start_server(Server(name, portno,
             {neighbor: servers[neighbor] for neighbor in neighbors[name]}, loop),
             'localhost', portno, loop=loop))
    loop.run_forever()
    server.close()
    (asyncio.get_event_loop()).run_until_complete(server.wait_closed())
    (asyncio.get_event_loop()).close()
