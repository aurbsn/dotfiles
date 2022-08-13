(use-modules
 (gnu)
 (gnu packages certs)
 (gnu packages ssh))
(use-service-modules networking ssh)

(operating-system
  (host-name "alien-1")
  (timezone "America/New_York")
  (locale "en_US.UTF-8")
  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets '("/boot/efi"))
               (keyboard-layout (keyboard-layout "us"))))
  (file-systems (cons (file-system
                        (device "/dev/sda")
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))
  (swap-devices (list "/dev/sdb"))

  (initrd-modules (cons "virtio_scsi"    ;needed to find the disk
                        %base-initrd-modules))

  (users (cons (user-account
                (name "arbn")
                (group "users")
                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.
                (supplementary-groups '("wheel"))
                (home-directory "/home/arbn"))
               %base-user-accounts))

  (packages (cons* nss-certs            ;for HTTPS access
                   openssh-sans-x
                   %base-packages))

  (services (cons*
             (service dhcp-client-service-type)
             (service openssh-service-type
                      (openssh-configuration
                       (openssh openssh-sans-x)
                       (password-authentication? #f)
                       (authorized-keys
                        `(("arbn" ,(local-file "config-files/arbn_rsa.pub"))
                          ("root" ,(local-file "config-files/arbn_rsa.pub"))))))
             %base-services)))
