import sys
from pathlib import Path

from pyframework.container import Container

ack = (Container(str((Path(__file__)).absolute().parent))).run()

sys.exit(ack)
