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
    'url',
    'doi',
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
    u'©': ur'\copyright',
    u'“': u'"',
    u'”': u'"',
    u'ℓ': u'l',
}

def lines(path):
    with codecs.open(path, encoding='utf-8') as f:
        for line in f:
            yield line

def clean(line):
    m = re.search(r'^(?P<key>\w+) = (?P<value>.*)$', line)
    if not m:
        return line

    d = m.groupdict()
    if d['key'] in keep:
        return _fix_url(line)
    else:
        return ''

def _fix_url(line):
    return re.sub(r'\\_', '_', line)

def main(path):
    for l in lines(path):
        sys.stdout.write(clean(l))
        # for c in l:
        #     sys.stdout.write(
        #         special_characters.get(c, c)
        #     )

if __name__ == '__main__':
    main(path=sys.argv[1])
