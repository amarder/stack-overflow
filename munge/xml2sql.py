# http://stackoverflow.com/questions/4695826/efficient-way-to-iterate-throught-xml-elements
# https://bugs.launchpad.net/lxml/+bug/1185701

from lxml import etree
import pandas as pd
import dateutil.parser
import sqlalchemy
import sys
import json
import sqlite3


def fast_iter(context, func):
    for event, elem in context:
        yield func(elem)
        elem.clear()
        while elem.getprevious() is not None:
            del elem.getparent()[0]
    del context


def create_processor(table):
    with open('munge/keep.json') as f:
        keep = json.load(f)
    d = keep[table]

    element_processors = {
        "integer": lambda x: int(x) if x is not None else None,
        "string": unicode,
        "datetime": dateutil.parser.parse,
    }

    def process_element(elt):
        items = [
            (k, element_processors[v](elt.attrib.get(k)))
            for k, v in d.items()
        ]
        return dict(items)

    return process_element


def blocks(folder, table, size=10000):
    path = '%s/%s.xml' % (folder, table)
    process_element = create_processor(table)

    with open(path) as f:
        context = etree.iterparse(f, events=('end',), tag='row')

        for i, d in enumerate(fast_iter(context, process_element)):
            if i % size == 0:
                if i > 0:
                    yield pd.DataFrame(data=rows)
                rows = []
            rows.append(d)

    if rows:
        yield pd.DataFrame(data=rows)


def tables_in(path):
    con = sqlite3.connect(path)
    cursor = con.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    l = cursor.fetchall()
    return [x[0] for x in l]


def xml2sql(infolder, outdb):
    existing_tables = tables_in(outdb)
    engine = sqlalchemy.create_engine('sqlite:///%s' % outdb)
    tables = ['Users', 'Badges', 'Comments', 'PostHistory', 'Posts']
    for k in tables:
        if k not in existing_tables:
            print 'Creating table of %s.' % k
            for df in blocks(infolder, k):
                df.to_sql(k, engine, if_exists='append')


if __name__ == '__main__':
    xml2sql(infolder=sys.argv[1], outdb=sys.argv[2])
