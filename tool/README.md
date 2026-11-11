# tool/

`gen_sellwood_data.py` regenerates `lib/data/sellwood_addresses.dart` from the
prototype's OpenStreetMap extract (`docs/design/prototype/solum-map-data.js`).
The prototype used flat "map units" (1 unit ≈ 0.81 m); the script converts them
to WGS84 with a linear fit against OSM address buildings (median error a few
meters). Run: `python3 tool/gen_sellwood_data.py`.

Address data © OpenStreetMap contributors, ODbL.
