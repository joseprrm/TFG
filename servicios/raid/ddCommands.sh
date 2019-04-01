dd if=/dev/zero of=/dev/sda1 bs=200M count=1 oflag=direct
dd if=/dev/sda1 of=/dev/null bs=200M count=1 iflag=direct
dd if=/dev/zero of=/mnt/1USB/prueba bs=200M count=1 oflag=direct
dd if=/mnt/1USB/prueba of=/dev/null bs=200M count=1 iflag=direct
dd if=/dev/zero of=/dev/sda1 bs=512 count=10000 oflag=direct
dd if=/dev/sda1 of=/dev/null bs=512 count=10000 iflag=direct
dd if=/dev/zero of=/mnt/1USB/prueba bs=512 count=10000 oflag=direct
dd if=/mnt/1USB/prueba of=/dev/null bs=512 count=10000 iflag=direct

dd if=/dev/zero of=/dev/md127 bs=200M count=1 oflag=direct
dd if=/dev/md127 of=/dev/null bs=200M count=1 iflag=direct
dd if=/dev/zero of=/mnt/raid0/prueba bs=200M count=1 oflag=direct
dd if=/mnt/raid0/prueba of=/dev/null bs=200M count=1 iflag=direct
dd if=/dev/zero of=/dev/md127 bs=512 count=10000 oflag=direct
dd if=/dev/md127 of=/dev/null bs=512 count=10000 iflag=direct
dd if=/dev/zero of=/mnt/raid0/prueba bs=512 count=10000 oflag=direct
dd if=/mnt/raid0/prueba of=/dev/null bs=512 count=10000 iflag=direct
