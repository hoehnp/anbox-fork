#!/system/bin/sh
# Copyright (C) 2016 Simon Fels <morphis@gravedo.de>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranties of
# MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

function prepare_filesystem() {
	# These dev files need to be adjusted everytime as they are
	# bind mounted into the temporary rootfs
	chmod 0777 /dev/input
	for f in qemu_pipe qemu_trace goldfish_pipe input/* /run/display/* ; do
		if [ ! -e "/dev/$f" ] ; then
			continue
		fi
		chown system:system /dev/$f
		chmod 0666 /dev/$f
	done
}

prepare_filesystem &
echo "Waiting for filesystem being prepared ..."
wait $!

ln -sf /dev/socket/qemu_pipe /dev/qemu_pipe
ln -sf /dev/socket/qemud /dev/qemud
ln -sf /dev/socket/anbox_bridge /dev/anbox_bridge

echo "Starting real init now ..."
/init
