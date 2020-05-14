#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Ministry of Justice'
SITENAME = 'OPG Data'
SITEURL = 'https://ministryofjustice.github.io/opg-data/'
DELETE_OUTPUT_DIRECTORY = True
PATH = 'content'
LOAD_CONTENT_CACHE = False
RELATIVE_URLS = False
THEME = 'bootstrap'
TIMEZONE = 'Europe/Paris'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
# Useful Links
LINKS = (('OPG Data', 'https://github.com/ministryofjustice/opg-data'),
         ('OPG Data Deputy Reporting', 'https://github.com/ministryofjustice/opg-data-deputy-reporting'),
         ('OPG Data LPA Codes', 'https://github.com/ministryofjustice/opg-data-lpa-codes'),
         ('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'))

# Social widget
SOCIAL = (('OPG Contact Us', 'https://www.publicguardian-scotland.gov.uk/general/contact-us'),)

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
