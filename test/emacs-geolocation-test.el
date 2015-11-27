;;; emacs-geolocation-test.el --- test for geolocation.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2015 Mugijiru

;; Author: Mugijiru <mugijiru.dev@gmail.com>
;; Keywords: geolocation

(require 'ert)
(require 'geolocation)
(eval-when-compile
 (require 'cl))

(ert-deftest geolocation-test/parse-wifi-line ()
  (let ((result (geolocation-parse-wifi-line "Test 00:00:00:00:00:00 -80  1     Y  JP NONE"))
        (expect '((macAddress . "00:00:00:00:00:00")
                  (signalStrength . "-80")
                  (channel . "1"))))
    (should (equal result expect))))
(ert-deftest geolocation-test/parse-wifi-info ()
  (let ((result (geolocation-parse-wifi-info "SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)\nTest 00:00:00:00:00:00 -80  1     Y  JP NONE\nTest2 99:99:99:99:99:99 -50  6       Y  -- WPA2(PSK/AES/AES)"))
        (expect '(((macAddress . "00:00:00:00:00:00")
                  (signalStrength . "-80")
                  (channel . "1"))
                  ((macAddress . "99:99:99:99:99:99")
                  (signalStrength . "-50")
                  (channel . "6")))))
    (should (equal result expect))))

(ert-deftest geolocation-test/get-wifi-info ()
  (flet ((shell-command-to-string (string) "SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)\nTest 00:00:00:00:00:00 -80  1     Y  JP NONE\nTest2 99:99:99:99:99:99 -50  6       Y  -- WPA2(PSK/AES/AES)"))
    (let ((result (geolocation-get-wifi-info))
          (expect "SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)\nTest 00:00:00:00:00:00 -80  1     Y  JP NONE\nTest2 99:99:99:99:99:99 -50  6       Y  -- WPA2(PSK/AES/AES)"))
      (should (equal result expect)))))

(ert-deftest geolocation-test/get-wifi-info-hashes ()
  (flet ((shell-command-to-string (string) "SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)\nTest 00:00:00:00:00:00 -80  1     Y  JP NONE\nTest2 99:99:99:99:99:99 -50  6       Y  -- WPA2(PSK/AES/AES)"))
    (let ((result (geolocation-get-wifi-info-hashes))
          (expect '(((macAddress . "00:00:00:00:00:00")
                     (signalStrength . "-80")
                     (channel . "1"))
                    ((macAddress . "99:99:99:99:99:99")
                     (signalStrength . "-50")
                     (channel . "6")))))
      (should (equal result expect)))))
