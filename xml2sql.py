# http://stackoverflow.com/questions/4695826/efficient-way-to-iterate-throught-xml-elements
# https://bugs.launchpad.net/lxml/+bug/1185701

from lxml import etree
import pandas as pd
import dateutil.parser
import sqlalchemy


def fast_iter(context, func):
    for event, elem in context:
        yield func(elem)
        elem.clear()
        while elem.getprevious() is not None:
            del elem.getparent()[0]
    del context

keep = {
    "Badges": {
        "Id": "integer",
        "UserId": "integer",
        "Name": "string",
        "Date": "datetime"
    },
    "Users": {
        "Id": "integer",
        "Reputation": "integer",
        "CreationDate": "datetime",
        "DisplayName": "string",
        "LastAccessDate": "datetime",
        "Views": "integer",
        "UpVotes": "integer",
        "DownVotes": "integer",
        "AccountId": "integer"
    },
    "Posts": {
        "Id": "integer",
        "PostTypeId": "integer",
        "AcceptedAnswerId": "integer",
        "CreationDate": "datetime",
        "Score": "integer",
        "ViewCount": "integer",
        "OwnerUserId": "integer",
        "Tags": "string",
        "AnswerCount": "integer",
        "CommentCount": "integer"
    },
    "Votes": {
        "Id": "integer",
        "PostId": "integer",
        "VoteTypeId": "integer",
        "CreationDate": "datetime"
    }
}
# Comments

element_processors = {
    "integer": lambda x: int(x) if x is not None else None,
    "string": unicode,
    "datetime": dateutil.parser.parse,
}


def create_processor(d):
    def process_element(elt):
        items = [
            (k, element_processors[v](elt.attrib.get(k)))
            for k, v in d.items()
        ]
        return dict(items)
    return process_element


def extract(table):
    path = 'beer.stackexchange.com/%s.xml' % table
    rows = []
    process_element = create_processor(keep[table])

    with open(path) as f:
        context = etree.iterparse(f, events=('end',), tag='row')

        for d in fast_iter(context, process_element):
            rows.append(d)

    return pd.DataFrame(data=rows)

engine = sqlalchemy.create_engine('sqlite:///my_db.sqlite')
tables = keep.keys()
for k in tables:
    df = extract(k)
    df.to_sql(k, engine, if_exists='replace')
