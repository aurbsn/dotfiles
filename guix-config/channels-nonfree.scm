(cons*
 (channel
  (name 'nonguix)
  (url "https://gitlab.com/nonguix/nonguix")
  (introduction
   (make-channel-introduction
    "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
    (openpgp-fingerprint
     "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
 (channel
  (name 'arbn)
  (url "https://github.com/aurbsn/arbn-guix-channel.git")
  (branch "main")
  (introduction
   (make-channel-introduction
    "3cc6977711fa11f94760bfd97be6723e56a51222"
    (openpgp-fingerprint
     "FD2F 077F 9BD6 CBB3 471A  D63A 3029 8DA2 EEB5 DE28"))))
 %default-channels)
