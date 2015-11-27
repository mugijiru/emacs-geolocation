;;; geolocation.el --- Get geolocation

;; Author: Mugijiru <mugijiru.dev@gmail.com>
;; URL: https://github.com/mugijiru/emacs-geolocation
;; Version: 0.0.1
;; Keywords: geolocation

;; Copyright (c) 2015 Mugijiru
;;
;; MIT License
;;
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
;; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


;;; Commentary:

;; geolocatoin.el is a tool for geolocation.
;;
;; This script only support Mac OS X
;;
;; ## Usage
;;   1. Get Google API Key and enable Google Maps Geolocation API
;;   2. Set your Google API Key
;;   (setq geolocation-google-api-key "YOUR-API-KEY")
;;   3. Evaluate (geolocation-get-geolocation)
;;

;;; Code:

(require 'request)
(require 'cl)

(defvar geolocation-url "https://www.googleapis.com/geolocation/v1/geolocate?key=")
(defvar geolocation-google-api-key nil
  "Get your Google Maps Geolocation API Key from https://code.google.com/apis/console")
(defvar geolocation-location-data nil)

(defun geolocation-get-geolocation ()
  "Get latitude and longitude from Wi-Fi information use Google Maps Geolocation API."
  (request
   (concat geolocation-url geolocation-google-api-key)
   :type "POST"
   :data (json-encode (geolocation-request-data))
   :headers '(("Content-Type" . "application/json"))
   :parser 'json-read
   :sync  t
   :complete (function*
              (lambda (&key data &allow-other-keys)
                (let* ((location (assoc-default 'location data))
                       (longitude (assoc-default 'lng location))
                       (latitude (assoc-default 'lat location)))
                  (setq geolocation-location-data
                        `((longitude . ,longitude) (latitude . ,latitude)))))))
  geolocation-location-data)

(defun geolocation-request-data ()
  "Create request data."
  `((considerIp . "true") (wifiAccessPoints . ,(geolocation-get-wifi-info-hashes))))

(defun geolocation-get-wifi-info-hashes ()
  "Get Wi-Fi informations."
  (let* ((wifi-info-string (geolocation-get-wifi-info))
         (wifi-info-list (geolocation-parse-wifi-info wifi-info-string)))
    (delq nil wifi-info-list)))

(defun geolocation-get-wifi-info ()
  "Get Wi-Fi information multiple lines string."
  (shell-command-to-string "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -s"))

(defun geolocation-parse-wifi-info (wifi-info-string)
  "Split line break Wi-Fi information multiple lines string and parse."
  (let ((lines (cdr (split-string wifi-info-string "\n"))))
    (loop for line in lines
          unless (null line)
          collect (geolocation-parse-wifi-line line))))

(defun geolocation-parse-wifi-line (wifi-line)
  "Parse line of Wi-Fi information."
  (let* ((columns (if (null wifi-line)
                     nil
                   (split-string wifi-line)))
         (macAddress (nth 1 columns))
         (signalStrength (nth 2 columns))
         (channel (nth 3 columns)))
    (if (or (null macAddress)
            (null signalStrength)
            (null channel)
            (not (string= (number-to-string (string-to-number signalStrength)) signalStrength))
            (not (string= (number-to-string (string-to-number channel)) channel)))
        nil
      `((macAddress . ,macAddress)
        (signalStrength . ,signalStrength)
        (channel . ,channel))
        )))

(provide 'geolocation)
