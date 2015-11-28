emacs-geolocation
====================

[![Build Status](https://travis-ci.org/mugijiru/emacs-geolocation.svg?branch=master)](https://travis-ci.org/mugijiru/emacs-geolocation)

Overview
--------------------

Get geolocation.

This program support Mac OS X only.

Install
--------------------

### clone from Github

1. Clone the repo: git clone https://github.com/mugijiru/emacs-geolocation.git.
2. Add to load-path and require 'geolocation.el'

```lisp
(add-to-list 'load-path "/path/to/emacs-geolocation")
(require 'geolocation)
```

### to use el-get

Create emacs-geolocation.rcp

```lisp:emacs-geolocation.rcp
(:name emacs-geolocation
       :description "Get geolocation use Google Maps Geolocation API."
       :type github
       :features "geolocation"
       :depends (request)
       :pkgname "mugijiru/emacs-geolocation")
```

and

`M-x el-get-install RET emacs-geolocation RET`

Configuration
--------------------

1. Get your Google API KEY from https://code.google.com/apis/console
2. Enable Google Maps Geolocation API for Your API KEY
3. Set your Google API KEY to `geolocation-google-api-key`
```lisp
(setq geolocation-google-api-key "YOUR-API-KEY")
```

Usage
--------------------

```lisp
;;
;; Get geolocation
;;

(geolocation-get-geolocation) ;; ((longitude . 127.65) (latitude . 26.17))
```

License
--------------------

MIT License
