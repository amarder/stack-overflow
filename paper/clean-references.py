#!/usr/local/bin/python
# -*- coding: utf-8 -*-

# TODO: This does not work with line breaks in bibtex fields.

import re
import sys
import codecs

keep = [
    'author',
    'journal',
    'title',
    'number',
    'month',
    'volume',
    'year',
    'pages',
    'booktitle',
]

special_characters = {
    u'é': ur"\'{e}",
    u'–': u'-',
    u'‐': u'-',
    u'—': u'-',
    u'ú': ur"\'{u}",
    u' ': u' ',
    u'Ü': ur'\"{U}',
    u'ü': ur'\"{u}',
    u'ö': ur'\"{o}',
    u'ł': ur'{\l}',
    u'’': u"'",
    u'ç': ur'\c{c}',
    u'ó': ur"\'{o}",
    u'ø': ur"\o",
}

def clean_lines(path):
    with codecs.open(path, encoding='utf-8') as f:
        for line in f:
            l = clean_line(line)
            if l is not None:
                yield check_characters(l)

def clean_line(line):
    m = re.search(r'^\s+(\w+) = ', line)
    if not m:
        return line
    elif m.group(1) in keep:
        return line

def check_characters(line):
    return line

if __name__ == '__main__':
    in_path = sys.argv[1]
    out_path = sys.argv[2]
    with open(out_path, 'w') as f:
        for l in clean_lines(in_path):
            for c in l:
                try:
                    f.write(c)
                except:
                    if c in special_characters:
                        f.write(special_characters[c])
                    else:
                        print u'_%s_' % c, ord(c)
