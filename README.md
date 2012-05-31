feed-fetcher-example
====================

An example ruby script that downloads 7digital Catalogue Feeds

NB: THIS EXAMPLE SCRIPT IS PROVIDED "AS IS", IT IS NOT MEANT TO BE USED IN PRODUCTION SYSTEMS.
    7DIGITAL DOES NOT GUARANTEE ITS CORRECT FUNCTIONALITY NOR PROVIDES ANY SUPPORT FOR ITS USE.


## Usage

	fetch_feed.rb (artist|release|track) [options]

		-i, --incremental                Flag to download incremental updates feed
										 (instead of full feed)

		-c, --country COUNTRY_CODE       Country of the feed (default: GB)

		-s, --shopid SHOP_ID             Shop ID of the feed
										 (optional, overrides country parameter)

		-d, --date YYYYMMDD              Date of the feed
										 (default: today for incremental feeds,
										 most recent Monday for full feeds)

		-o, --output FILE                File the downloaded feed will be saved to
										 (default: <country>_<type>_<date>.csv.gz)

		-h, --help                       Display this screen


## License

Copyright (c) 2012 7digital, released under the MIT license.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
