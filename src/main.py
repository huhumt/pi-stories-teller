#!/usr/bin/python.exe
# -*- coding: utf-8 -*-
import re
import sys
from podfox.__init__ import main
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
