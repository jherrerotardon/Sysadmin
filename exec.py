import sys
from pathlib import Path

from py_framework.container import Container

ack = (Container(str((Path(__file__)).absolute().parent))).run()

sys.exit(ack)
