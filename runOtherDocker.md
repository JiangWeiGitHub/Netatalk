# Run Other Docker Image

运行netatalk(time machine)的步骤:

+ 确定实际外置磁盘的挂载路径

  - btrfs filesystem show

  ```
    Label: none  uuid: 1b038213-3b7f-4e8a-bfd9-a2f0096509e6
            Total devices 1 FS bytes used 400.00KiB
            devid    1 size 57.84GiB used 2.02GiB path /dev/sdc
  ```
  
  ps: 可知btrfs文件系统的uuid为`1b038213-3b7f-4e8a-bfd9-a2f0096509e6`

  - df

  ```
    Filesystem     1K-blocks    Used Available Use% Mounted on
    udev              881100       0    881100   0% /dev
    tmpfs             179636   14624    165012   9% /run
    /dev/mmcblk0p1   3030800 2056872    800260  72% /
    tmpfs             898168       0    898168   0% /dev/shm
    tmpfs               5120       0      5120   0% /run/lock
    tmpfs             898168       0    898168   0% /sys/fs/cgroup
    /dev/sdc        60653568   16912  58538736   1% /run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6
  ```
  
  ps: 可知挂载路径为`/run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6`
  

+ 创建挂载文件夹并修改权限

  - `mkdir /run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6/timemachine /run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6/share`

  - `chmod 777 -R /run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6/timemachine /run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6/share`


+ 重启avahi服务

  systemctl restart avahi-daemon


+ 下载并运行netatalk镜像

  docker -H tcp://127.0.0.1:1688 run --detach --privileged --volume /run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6/share:/media/share --volume /run/wisnuc/volumes/1b038213-3b7f-4e8a-bfd9-a2f0096509e6/timemachine:/media/timemachine --net "host" -v /var/run/docker.sock:/var/run/docker.sock -v /run/systemd:/run/systemd -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket cptactionhank/netatalk:latest
