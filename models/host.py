from py_framework.helpers.lists import array_merge
from py_framework.models.mysql_model import MySQLModel


class Host(MySQLModel):
    """Columns of table. """
    MAC_ADDRESS = 'mac_address'
    HOSTNAME = 'hostname'
    PRIVATE_IP = 'private_ip'
    PUBLIC_IP = 'public_ip'
    CREATED_AT = 'created_at'
    UPDATED_AT = 'updated_at'

    """List with all columns of table. """
    _columns = [MAC_ADDRESS, HOSTNAME, PRIVATE_IP, PUBLIC_IP, CREATED_AT, UPDATED_AT]

    _database = 'sysadmin'

    _table = 'host'

    def __init__(self):
        super(Host, self).__init__()

        self.create_database()
        self._use_db()
        self.create_table()

    def create_database(self):
        """Creates table if not exists.

        :return:
        """
        command = "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(self._database)

        if not self._exists_database():
            self.execute(command)

        return True

    def create_table(self):
        """Creates table of model in DB if not exists.

        :return:
        """
        command = 'CREATE TABLE ' + self._table + ' (' + \
                  '  {} VARCHAR(18) PRIMARY KEY,'.format(self.MAC_ADDRESS) + \
                  '  {} VARCHAR(16) NOT NULL,'.format(self.HOSTNAME) + \
                  '  {} VARCHAR(16) NOT NULL,'.format(self.PRIVATE_IP) + \
                  '  {} VARCHAR(16) NOT NULL,'.format(self.PUBLIC_IP) + \
                  '  {} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,'.format(self.CREATED_AT) + \
                  '  {} TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'.format(self.UPDATED_AT) + \
                  ') ENGINE=InnoDB'

        if not self._exists_table():
            self.execute(command)

        return True

    def get_info(self, mac_address: str) -> dict:
        """Returns current info host as dict.

        :param mac_address:
        :return:
        """
        command = 'SELECT {} FROM {} WHERE mac_address=%s LIMIT 1'.format(', '.join(self._columns), self._table)

        result = self.select_one(command, [mac_address])

        return {key: value for key, value in zip(self._columns, result)} if result else {}

    def update_info(self, **kwargs) -> bool:
        """Checks info from current host stored and update it if is changed. Returns true if info has been updated,
        otherwise returns false.
        
        :param kwargs: 
        :return: 
        """
        default = {
            self.MAC_ADDRESS: '',
            self.HOSTNAME: '',
            self.PRIVATE_IP: '',
            self.PUBLIC_IP: '',
        }
        kwargs = array_merge(default, kwargs)

        info = self.get_info(kwargs['mac_address'])
        has_changed = not info or self._has_changed(info, kwargs, [self.HOSTNAME, self.PRIVATE_IP, self.PRIVATE_IP])
        if has_changed:
            columns_to_update = default.keys()
            command = 'INSERT INTO {} ( {} ) VALUES ( {} ) ON DUPLICATE KEY UPDATE {}'.format(
                self._table,
                ', '.join(columns_to_update),
                ', '.join(['%({})s'.format(column) for column in columns_to_update]),
                ', '.join(['{0}=%({0})s'.format(column) for column in columns_to_update])
            )

            self.execute(command, kwargs)

        return has_changed

    def _has_changed(self, original: dict, new: dict, columns=None) -> bool:
        """Checks if any columns has changes his value. If columns isn't specified then checks all table columns.

        :param original:
        :param new:
        :param columns:
        :return:
        """
        columns = columns or self._columns

        result = False

        for column in columns:
            if original[column] != new[column]:
                result = True
                break

        return result
