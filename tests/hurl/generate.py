#!/usr/bin/env python3
"""
Generate Hurl RASP test files from the <split>-delimited payload matrices.

Usage:
    python3 tests/hurl/generate.py

Reads:
    tests/mysql.txt
    tests/oracle.txt

Writes:
    tests/hurl/rasp/mysql/<servlet>.hurl
    tests/hurl/rasp/oracle/<servlet>.hurl

Each file contains one Hurl entry per test case for that servlet.
Status assertion uses:
    HTTP *
    [Asserts]
    status == {{block_status}}

so the expected status (550 for RASP-blocked, 200 for benign) is
injected at runtime via --variable block_status=550.

NOTE: Raw spaces in URLs break Hurl's URL parser; the generator
percent-encodes bare spaces (0x20) only, preserving all other
characters (including already-encoded sequences like %25, %27, etc.)
exactly as they appear in the source files.
"""

import os
import re
import sys
from collections import defaultdict

TESTS_DIR = os.path.join(os.path.dirname(__file__), "..")
RASP_DIR = os.path.join(os.path.dirname(__file__), "rasp")

SOURCES = {
    "mysql": os.path.join(TESTS_DIR, "mysql.txt"),
    "oracle": os.path.join(TESTS_DIR, "oracle.txt"),
}

# Map servlet path segment → output filename (lowercase, underscores)
SERVLET_NAME_MAP = {
    # MySQL servlets
    "MySql_Get_int": "get_int",
    "MySql_Get_string": "get_string",
    "MySql_Get_Implicit_Join": "get_implicit_join",
    "MySql_Implicit_Join_Namespace": "implicit_join_namespace",
    "Get_Union": "get_union",  # shared by both; mysql.txt uses it
    # Oracle servlets
    "Get_int": "get_int",
    "Get_int_no_quote": "get_int_no_quote",
    "Get_int_partialunion": "get_int_partialunion",
    "Get_int_groupby": "get_int_groupby",
    "Get_int_nooutput": "get_int_nooutput",
    "Get_int_having": "get_int_having",
    "Get_int_inline": "get_int_inline",
    "Get_string": "get_string",
    "Get_string_no_quote": "get_string_no_quote",
    "Get_Implicit_Join": "get_implicit_join",
    "Get_Full_Outer_Join": "get_full_outer_join",
}


def encode_url_illegal(s):
    """
    Percent-encode characters that Hurl's URL parser rejects in GET lines.

    Hurl rejects: space, |, ", <, >
    Everything else (including already-encoded %xx sequences, ', (, ), etc.)
    is left intact so payload semantics are preserved exactly.
    """
    replacements = [
        (" ",  "%20"),
        ("|",  "%7C"),
        ('"',  "%22"),
        ("<",  "%3C"),
        (">",  "%3E"),
    ]
    for char, enc in replacements:
        s = s.replace(char, enc)
    return s


def servlet_from_path(path):
    """Extract servlet name from /spiracle/<servlet>."""
    return path.lstrip("/").split("/")[-1]


def output_filename(servlet):
    return SERVLET_NAME_MAP.get(servlet, servlet.lower()) + ".hurl"


def parse_data_file(filepath):
    """Return list of (path, querystring, expected_status) tuples."""
    cases = []
    with open(filepath, encoding="utf-8") as f:
        for lineno, line in enumerate(f, 1):
            line = line.rstrip("\n")
            if not line:
                continue
            parts = line.split("<split>")
            if len(parts) != 3:
                print(
                    f"WARNING: {filepath}:{lineno} — expected 3 parts, got {len(parts)}: {line!r}",
                    file=sys.stderr,
                )
                continue
            cases.append((parts[0], parts[1], parts[2]))
    return cases


def generate_hurl_file(cases, base_url_template):
    """
    Build Hurl file content for a list of (path, querystring, expected_status).
    base_url_template: string with {path} and {querystring} slots.
    """
    lines = []
    for path, qs, expected_status in cases:
        # Encode URL-illegal chars in querystring only (not path)
        safe_qs = encode_url_illegal(qs)
        url = "http://{{{{host}}}}:{{{{port}}}}{path}{qs}".format(
            path=path, qs=safe_qs
        )
        lines.append(f"GET {url}")
        lines.append("")
        lines.append("HTTP *")
        lines.append("[Asserts]")
        # Use {{block_status}} variable for the standard blocked status (550).
        # Cases with a different expected status (e.g. 200 for a benign probe)
        # get the literal value so they remain correct regardless of variables.
        if expected_status == "550":
            lines.append(f"status == {{{{block_status}}}}")
        else:
            lines.append(f"status == {expected_status}")
        lines.append("")
    return "\n".join(lines)


def main():
    total = 0
    by_db = {}

    for db, filepath in SOURCES.items():
        cases = parse_data_file(filepath)
        print(f"Read {len(cases)} cases from {filepath}")
        total += len(cases)
        by_db[db] = cases

        # Group by servlet
        groups = defaultdict(list)
        for path, qs, expected_status in cases:
            servlet = servlet_from_path(path)
            groups[servlet].append((path, qs, expected_status))

        out_dir = os.path.join(RASP_DIR, db)
        os.makedirs(out_dir, exist_ok=True)

        for servlet, servlet_cases in sorted(groups.items()):
            fname = output_filename(servlet)
            out_path = os.path.join(out_dir, fname)
            content = generate_hurl_file(servlet_cases, "")
            with open(out_path, "w", encoding="utf-8") as f:
                f.write(content)
            print(f"  Wrote {len(servlet_cases):3d} cases → {out_path}")

    print(f"\nTotal: {total} cases converted.")


if __name__ == "__main__":
    main()
