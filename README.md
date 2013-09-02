
## Overview

***[Unicycle](http://unicycle.woodpigeon.com)*** is a simple Sinatra app which lets designers search for Unicode characters (and their codes) by name.
For example searching for 'exclamation mark' will list eight unicode variants, including inverted, double, Armenian etc.

This Sinatra app uses the datamapper ORM and a small sqlite database ```unicodes.db```. Views are in Haml. An api endpoint returns the 'live search' results as json.

Design by the talented and indefatigable [Rob Salter](uk.linkedin.com/in/robsalter/).

## Up and running

This assumes you have Ruby >= 1.9.3 installed via rbenv or rvm.

```
git clone https://github.com/woodpigeon/unicycle
cd unicycle
bundle install
bundle exec ruby main.rb
```

## Tests

Todo.