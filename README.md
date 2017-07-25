# baid-prototype

A lightweight server used to demonstrate data services consumable by a BAID client.

This prototype uses Sinatra and Puma to serve JSON-formatted time-series
data. A CSV ASCII (text) file serves as a data store.

To run in a Linux/Unix environment:
```
export RACK_ENV=production; http://localhost:9292/BD/E/T1
```

Useful `RACK_ENV` options are `development`, `production`. The
application will be available at `http://localhost:9292`. See the API
endpoints by doing:
```
bundle exec rake routes
```

Query options:
* `:site` may be `BW` (Barrow Wet) or `BD` (Barrow Dry)
* `:treatment` may be `E` (Experimental) or `C` (Control)
* `:plot` may be one of `T1` or `T2`

For example: `http://localhost:9292/BD/E/T1`

This material is based upon work supported by the National Science Foundation under Grant Number 1023561.

Any opinions, findings, and conclusions or recommendations expressed in this material are those of the 
author(s) and do not necessarily reflect the views of the National Science Foundation.
