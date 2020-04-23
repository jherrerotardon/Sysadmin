import re
import socket
import uuid

import requests
from json2html import *
from py_framework.helpers.configuration import env
from py_framework.providers.cli.command import Command
from py_framework.providers.google.gmail import Mail

from models.host import Host


class CheckIP(Command):
    _name = 'checkIP'

    _description = 'Check network data from host, and management it.'

    """Data values to check and save. """
    _hostname = ''
    _private_ip = ''
    _public_ip = ''
    _mac_address = ''

    __CHECK_IP_URL = 'https://ident.me'

    def set_up(self):
        self._hostname = self._get_hostname()
        self._private_ip = self._get_private_ip()
        self._public_ip = self._get_public_ip()
        self._mac_address = self._get_mac_address()

    def handle(self) -> int:
        self.info_time("Checking IP...")

        self._check()

        return Command.RETURN_SUCCESS

    def _check(self):
        """Checks if data has changed since the last time. In this case, updates data in DB and sends an email.

        :return
        """
        data = {
            Host.MAC_ADDRESS: self._mac_address,
            Host.HOSTNAME: self._hostname,
            Host.PRIVATE_IP: self._private_ip,
            Host.PUBLIC_IP: self._public_ip,
        }

        # Check data of host and if something is changed then send email notifying it.
        data_changed = (Host()).update_info(**data)

        notification_to = env('NOTIFICATION_TO')
        if data_changed and notification_to:
            self._send_notification_mail(notification_to, data)

    @staticmethod
    def _send_notification_mail(to: str, data: dict):
        """Sends mail to 'to' mail notifying of most recent data of host.

        :param to:
        :return:
        """
        # Not send any email if admin mail is not configured.
        admin_mail = env('ADMIN_MAIL')
        if not admin_mail:
            return False

        mail_obj = Mail(admin_mail)

        mail_obj.send_message(to, 'IP Changed.', json2html.convert(json=data))

    def _get_hostname(self) -> str:
        """Returns the hostname of current host.

        :return:
        """
        return self._hostname or socket.gethostname()

    def _get_private_ip(self) -> str:
        """Returns private ip of current host.

        :return:
        """
        # TODO: check return when not connection.
        return socket.gethostbyname(self._get_hostname())

    def _get_public_ip(self) -> str:
        """Tries to get public ip of current host. Returns the IP or empty string if it cant't got it.

        :return:
        """
        try:
            public_ip = requests.get(self.__CHECK_IP_URL, timeout=2).text
        except requests.exceptions.Timeout:
            # Connection timeout to get public IP. Only wait for 1 second.
            public_ip = ''

        return public_ip

    @staticmethod
    def _get_mac_address() -> str:
        """Returns MAC Address from host as string.

        :return:
        """
        return ':'.join(re.findall('..', '%012x' % uuid.getnode()))
