import re
import sys


PROJECT_ID_REGEX = r'^[a-z][-a-z0-9]{4,28}[a-z0-9]{1}$'

project_id = '{{ cookiecutter.project_id }}'

if not re.match(PROJECT_ID_REGEX, project_id):
    print('ERROR: %s is not a valid Project ID!\n'
          'Please follow the naming convention described in '
          'https://cloud.google.com/resource-manager/docs/creating-managing-projects' % project_id)

    # exits with status 1 to indicate failure
    sys.exit(1)
