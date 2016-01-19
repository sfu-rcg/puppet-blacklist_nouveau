class blacklist_nouveau {
    case $::osfamily {
      redhat: {
        case $::operatingsystemmajrelease {
          6: {
            augeas {'blacklist_nouveau':
              context => "/files/etc/grub.conf",
              changes => ["set /files/etc/grub.conf/title[1]/kernel/rdblacklist nouveau",
                          #"set /files/etc/grub.conf/title[1]/kernel/vga 791",
                          "set /files/etc/grub.conf/title[1]/kernel/nouveau.modeset 0",
                          ],
              }
            } # 6
          } # majrelease
        } # redhat

        debian: {
          case $::operatingsystemmajrelease {
            /^15\.\d+$/: {

              file { '/etc/modprobe.d/blacklist-nouveau.conf':
                ensure => 'present',
                content => "blacklist nouveau\noptions nouveau modeset=0\nalias nouveau off"
              }

              exec {'update initramfs':
                command => '/usr/sbin/update-initramfs -u',
                subscribe => File['/etc/modprobe.d/blacklist-nouveau.conf'],
              }
            } # 15.xyz
          } # majrelease
        } # debian


    default: {
      fail('Your platform is currently unsupported.')
    }
  }
}
