emacs-geolocation
====================

[![Build Status](https://travis-ci.org/mugijiru/emacs-geolocation.svg?branch=master)](https://travis-ci.org/mugijiru/emacs-geolocation)

Overview
--------------------

Get geolocation

Usage
--------------------

```lisp
(require 'geolocation)
(add-to-list 'geolocation-google-api-key "YOUR-API-KEY")

;;
;; Get geolocation
;;

(geolocation-get-geolocation) ;; ((longitude . 127.65) (latitude . 26.17))
```

License
--------------------

MIT License
