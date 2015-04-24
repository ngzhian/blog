#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Ng Zhi An'
SITENAME = u'Zhi An'
SITEURL = 'http://ngzhian.github.io/blog'

GITHUB_URL = 'http://github.com/ngzhian'

PATH = 'content'

TIMEZONE = 'America/New_York'

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (('github', GITHUB_URL),
          )

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True
THEME = 'themes/simple'
PROFILE_IMG_URL = 'http://i.imgur.com/r3v4S9O.jpg'
FAVICON_URL = 'http://i.imgur.com/r3v4S9O.jpg'
TAGLINE = 'Curious, creative, programmer. Open-source enthusiast'

SUMMARY_MAX_LENGTH = 130
