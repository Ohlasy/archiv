[![Build Status](https://travis-ci.org/Ohlasy/archiv.svg?branch=master)](https://travis-ci.org/Ohlasy/archiv)

Aplikace je napsaná v [Elmu](http://elm-lang.org), prostředí pro místní vývoj se dá nainstalovat takhle:

    $ npm install elm
    $ elm package install
    $ make

Po přidání commitu na GitHub se rozběhne [Travis](https://travis-ci.org), který kód přeloží a nahraje do kyblíčku na [S3](https://aws.amazon.com/s3/), který je zvenčí vidět jako [archiv.ohlasy.info](http://archiv.ohlasy.info).