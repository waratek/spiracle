#!/usr/bin/python

from collections import defaultdict
import requests
import argparse

parser = argparse.ArgumentParser(description="Run SQLI Tests")
parser.add_argument("-hn", "--hostname", help="Hostname", required=True)
parser.add_argument("-p", "--port", help="Port", required=True)
parser.add_argument("-f", "--file", help="Data file", required=True)
parser.add_argument("-d", "--debug", action="store_true")
args = parser.parse_args()

input_file = open(args.file)
expected_dict = defaultdict(list)
actual_dict = defaultdict(list)
url = "http://{0}:{1}".format(args.hostname, args.port)

for entry in input_file:
    parts = entry.strip().split("<split>")
    if parts[0] in expected_dict:
        expected_dict[parts[0]].append((parts[1], parts[2]))
    else:
        expected_dict[parts[0]] = []
        expected_dict[parts[0]].append((parts[1], parts[2]))

for key in expected_dict.keys():
    actual_dict[key] = []

for key in expected_dict.keys():
    for entry in expected_dict[key]:
        r = requests.get("{0}{1}{2}"
                         .format(url, key, entry[0]))
        if args.debug:
            print r.url, r.status_code

        actual_dict[key].append((entry[0], r.status_code))

successful_tests = 0
log = open("results.csv", "a+")
for key in actual_dict.keys():
    counter = len(actual_dict[key])
    for x in range(0, counter):
        if str(expected_dict[key][x][1]) == str(actual_dict[key][x][1]):
            successful_tests += 1
        log.write("{0}{1},{2},{3}\n".format(url, key, expected_dict[key][x][1],
                                            actual_dict[key][x][1]))
    print("Servlet {0} had {1} tests. Pass: {2} Fail {3}"
          .format(key, counter, successful_tests, counter - successful_tests))
    successful_tests = 0
log.close()
