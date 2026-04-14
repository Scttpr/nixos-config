{ ... }:

{
  services.usbguard = {
    enable = true;
    presentDevicePolicy = "allow";
    insertedDevicePolicy = "apply-policy";
    rules = ''
      # Internal xHCI host controllers
      allow id 1d6b:0002 serial "0000:64:00.3" name "xHCI Host Controller" hash "itWJ0jdmwMTs9EuQmilJnh3Dqny0qDjLh6uoalee/iA=" parent-hash "ryoMvjbC6VLMLjh5woggxNI1CyBOBrW412dC+GQeis4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:64:00.3" name "xHCI Host Controller" hash "ZKxM+7dxDciy3g3O2pepNp7X8wA+HpSN7xVtLHXc4co=" parent-hash "ryoMvjbC6VLMLjh5woggxNI1CyBOBrW412dC+GQeis4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:64:00.4" name "xHCI Host Controller" hash "ujCE8JWIJdTAJRvL/4n+fCq2MXbiyaoMP3bKdi9gNw0=" parent-hash "zV0Qd1O0FR2D+xD0beveBoeL0DCYMC3IG1aMgbIxtY4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:64:00.4" name "xHCI Host Controller" hash "cqJt8igTeH2CEToZjmbz6i14h8d0a/xuKJE+n6DXSIM=" parent-hash "zV0Qd1O0FR2D+xD0beveBoeL0DCYMC3IG1aMgbIxtY4=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:66:00.3" name "xHCI Host Controller" hash "BqCcbGYRx9WmbXX9O6Y0JhiJwrGi2G82+qK6S5WKe/c=" parent-hash "JJj6P0xwAW1xW7LT0pyC91C4W/KvHY/iYsoBDBh/YQU=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:66:00.3" name "xHCI Host Controller" hash "fdLdRS+5HvC54P/P4jKmsjDbDON4debmmBzsit2M3pc=" parent-hash "JJj6P0xwAW1xW7LT0pyC91C4W/KvHY/iYsoBDBh/YQU=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:66:00.4" name "xHCI Host Controller" hash "6FTa+djr2ks6Uu4PohzW3J9hoYoYKdl4r+g5mKkqsN8=" parent-hash "rUASZM2vB9X4K33KMdxaQ+JWmCxgq1ETQ6dJUef8Iug=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:66:00.4" name "xHCI Host Controller" hash "y877eh4B1ubmW70ajDkw6f2RPrbeCXAdEnZrv/FSmy0=" parent-hash "rUASZM2vB9X4K33KMdxaQ+JWmCxgq1ETQ6dJUef8Iug=" with-interface 09:00:00 with-connect-type ""

      # Internal USB2.0 hub
      allow id 05e3:0610 serial "" name "USB2.0 Hub" hash "HtK/V9+iwK2EoOneULC1IMFJ2IxQr0rL9Q+N6BDFNak=" parent-hash "itWJ0jdmwMTs9EuQmilJnh3Dqny0qDjLh6uoalee/iA=" via-port "1-3" with-interface { 09:00:01 09:00:02 } with-connect-type "not used"

      # Integrated camera
      allow id 5986:118c serial "200901010001" name "Integrated Camera" hash "oJaf2cO4/bicpViHny8S/8CPNuUr78mUkUcOWzpFrRE=" parent-hash "ujCE8JWIJdTAJRvL/4n+fCq2MXbiyaoMP3bKdi9gNw0=" with-interface { 0e:01:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:01:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 fe:01:01 } with-connect-type "not used"

      # USB dock (hub pair)
      allow id 2109:2817 serial "000000000" name "USB2.0 Hub             " hash "qPtI8AWo/sxA1ywaz0q3rn4T+Boz5sTPIjyhJMfZbDk=" parent-hash "BqCcbGYRx9WmbXX9O6Y0JhiJwrGi2G82+qK6S5WKe/c=" with-interface { 09:00:01 09:00:02 } with-connect-type "hotplug"
      allow id 2109:0817 serial "000000000" name "USB3.0 Hub             " hash "noU8ynIKcqoDHeEoHF36V/ZFF1tRfYSq6JBT4bh30EY=" parent-hash "fdLdRS+5HvC54P/P4jKmsjDbDON4debmmBzsit2M3pc=" with-interface 09:00:00 with-connect-type "hotplug"

      # Anker 364 dock + internal hub + ethernet
      allow id 05e3:0608 serial "" name "USB2.0 Hub" hash "Xx4NMpaW1qI7RdzCbvAFz0fkV85X3YiKSWc2anf6A7w=" parent-hash "qPtI8AWo/sxA1ywaz0q3rn4T+Boz5sTPIjyhJMfZbDk=" via-port "5-1.3" with-interface 09:00:00 with-connect-type "unknown"
      allow id 291a:83a2 serial "AHC26G0D37200928" name "Anker 364 USB C Hub(10-in-1, Dual 4K HDMI)" hash "UHXad4YnThXXmdUp8X3ZlD0cnbq6R69Y0HeKHmG8bQU=" parent-hash "qPtI8AWo/sxA1ywaz0q3rn4T+Boz5sTPIjyhJMfZbDk=" with-interface 11:00:00 with-connect-type "unknown"
      allow id 0bda:8153 serial "001300E04C9F3DE8" name "USB 10/100/1000 LAN" hash "7xhgDlKCOXCiAiv3ixA6HKE9iK7KHmhmD+uYWO7CtCg=" parent-hash "noU8ynIKcqoDHeEoHF36V/ZFF1tRfYSq6JBT4bh30EY=" with-interface { ff:ff:00 02:06:00 0a:00:00 0a:00:00 } with-connect-type "unknown"

      # Internal hub devices (Bluetooth/smartcard)
      allow id 10ab:9309 serial "" name "" hash "whHOIdQrSVT8iQWv1Bg5SSP7oI4SXttsMYptqf04kXs=" parent-hash "HtK/V9+iwK2EoOneULC1IMFJ2IxQr0rL9Q+N6BDFNak=" via-port "1-3.1" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "not used"
      allow id 2ce3:9563 serial "" name "EMV Smartcard Reader" hash "SOxag+v/yr7SA04eNCa88HFqD0IhMbIt2Vk0jDIs21A=" parent-hash "HtK/V9+iwK2EoOneULC1IMFJ2IxQr0rL9Q+N6BDFNak=" via-port "1-3.2" with-interface 0b:00:00 with-connect-type "not used"
    '';
  };
}
