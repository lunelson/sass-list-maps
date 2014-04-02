## Sass List–Maps

Forward-compatible map (hash) functionality for [libsass](https://github.com/hcatlin/libsass) and [ruby-sass](http://sass-lang.com/) 3.2.x using lists.

![](sass-hash.jpg)

#### Latest Updates

* 0.9.6-0.9.8 -- argument-handling enhancements; typo fixes
* 0.9.3-0.9.5 -- now handles single-pair lists automatically. This means no more need for `list()` or `zip()` functions, which are now deprecated.
* 0.9.2 -- improved merge performance with rewritten `set-nth()` function
* 0.9.2 -- included `get()`, `merge()`, and `set()` aliases by default
* now listed at the [sache.in](http://www.sache.in/) directory of Sass & Compass Extensions

#### Try it out

You can test-drive these functions [at Sassmeister in this pre-loaded gist](http://sassmeister.com/gist/8645654). NB: the libsass version at Sassmeister might be a couple of point-releases behind this repo.

#### Install it

Sass List-Maps can be installed as a Bower component for (see [node-sass options](http://github.com/sindresorhus/grunt-sass#includepaths) if you are using libsass via node) or as a gem-based Compass extension for ruby setups:

```sh
# installation with bower
bower install sass-list-maps

# run with grunt-sass using these options
options: {
  includePaths: [
    './bower_components/sass-list-maps'
  ]
}

# installation with rubygems, for compass
gem install sass-list-maps

# Add to your Sass
@import "sass-list-maps";
```

You can also just fork or download this repo or cut-and-paste.

### Introduction

Maps (also known as hashes or objects\*) allow dynamic creating, setting and retrieving of data. They are supported natively in ruby-sass as of version 3.3.x with a new syntax and dedicated functions; but for earlier ruby-sass versions—and for the increasingly popular libsass C-based compiler (until the point at which maps are integrated there natively)—this is an alternative solution. These functions feature-match ruby-sass 3.3's map functionality using the `list` data-type. Additional functions are also provided to extend this functionality with nested getting and merging/setting.

*\* objects (as in javascript) are not exactly the same thing as maps and hashes, but for these purposes close enough.*

### 'List-map' syntax

List-maps—as opposed to native maps—are like any other list in Sass but must be formatted specifically as a list of pairs. The formatting I recommend keeps as close as possible to the syntax of native maps, with the difference that there no colons (`:`), and the placement of commas is more critical (e.g. trailing commas—commas after the last item—are allowed in native maps and in lists in ruby-sass 3.3+ but not in any other version):


```scss
/* example of a list-map -- compatible with any
version/compiler of sass including 3.3+ */

$list-map: ( alpha 1, beta 2, gamma 3 );

/* example of native map -- would cause an error
in any version/compiler other than ruby-sass 3.3+
-- notice colons and trailing comma */

$native-map: ( alpha: 1, beta: 2, gamma: 3,);
```

As a list of pairs, a list-map list can be of any length; but each item in that list must be a list of exactly two. The first of these is the 'key' and is usually a string; the second is the 'value'. This 'value' however, can be of any type—including another list (of pairs)—which allows list-maps to form nested or tree-like data structures. Such a 'nested' list-map looks like this (compared again to a native map):

```scss
$list-map-z: (
  alpha (
    beta (
      gamma 3
    )
  )
);

$native-map-z: (
  alpha: (
    beta: (
      gamma: 3,
    ),
  ),
);
```

It should be clear that list-maps and native maps are very similar; in fact they are in principle the same. For this reason it was possible to 'reverse engineer' the map functions of ruby-sass' 3.3+ to use simple lists.

### 'List-map' functions

The functions for 'list-maps' have the same names as the map functions in ruby-sass >= 3.3.x, which means that if they were used in ruby-sass 3.3.x or higher they would conflict.Therefore, the following code assume a sass environment other than that (either ruby-sass <3.3 or libsass.

#### Basic

All of the current—as of this writing—map functions are implemented. These include `map-get($list, $key)`, `map-merge($list1, $list2)`, `map-remove($list, $key)`, `map-keys($list)`, `map-values($list)`, and `map-has-key($list, $key)`. As with native maps, standard list functions can also be used on list-maps since they are lists anyway.

##### 1. `map-keys($list)`, `map-values($list)`, `map-has-key($list, $key)`

```scss
@import "sass-list-maps";

$list-map: ( alpha 1, beta 2, gamma 3 );

.demo {
  out: map-keys($list-map); //-> alpha, beta, gamma
  out: map-values($list-map); //-> 1, 2, 3
  out: map-has-key($list-map, gamma); //-> true
  out: map-has-key($list-map, delta); //-> false
}
```

##### 2. `map-get($list, $key)`

```scss
@import "sass-list-maps";

$list-map: ( alpha 1, beta 2, gamma 3 );

.demo {
  out: map-get($list-map, alpha); //-> 1
  out: map-get($list-map, beta); //-> 2
  out: map-get($list-map, gamma); //-> 3
}
```

##### 3. `map-merge($list1, $list2), map-remove($list, $key)`

```scss
@import "sass-list-maps";

$list-map: ( alpha 1, beta 2, gamma 3 );

$new-map: map-merge($list-map, gamma 4);
// -> $new-map = ( alpha 1, beta 2, gamma 4 )

$short-map: map-remove($list-map, alpha);
// -> $short-map = ( beta 2, gamma 3)
```

**NB**: you might notice in the second example above, that the second argument to map-merge isn't really a 'list-map' it's just a list of two items. This is the so-called "single item" list conundrum in Sass which is a bit tricky, but these functions as of 0.9.5 handle this case automatically.

#### Advanced

In addition to the core ruby-sass 3.3+ map functions, this library includes 'deep' or 'nested' versions of `map-get()` and `map-merge()` -- suffixed here with `-z`.

##### 4. `map-get-z($list, $keys...)`

The `map-get-z()` function will retrieve values from a list-map according to a chain of keys (similar to the way nested array/hash/object values are accessed in other languages):

```scss
@import "sass-list-maps";

$list-map-z: (
  alpha (
    beta (
      gamma 3
    )
  )
);

.demo {
  out: map-get-z($list-map-z, alpha); // -> ( beta ( gamma 3 ) )
  out: map-get-z($list-map-z, alpha, beta); // -> ( gamma 3 )
  out: map-get-z($list-map-z, alpha, beta, gamma); // -> 3
}
```

##### 5. `map-merge-z($list, $keys-and-value...)`

The `map-merge-z()` function takes a chain of keys to indicate where (at what depth) to merge, and takes its final argument as the value to be merged. This value can be of any type including another list/list-map. Note that if only one key/value argument is passed and it is not a list, it is interpreted as the key, and an empty list is merged in as the value:

```scss
@import "sass-list-maps";

$list-map-z: (
  alpha (
    beta (
      gamma 3
    )
  )
);

$new-map1-z: map-merge-z($list-map-z, delta);
// -> ( alpha ( beta ( gamma 3 ) ), ( delta ( ) ) )
$new-map2A-z: map-merge-z($list-map-z, delta, epsilon);
// -> ( alpha ( beta ( gamma 3 ) ), ( delta epsilon ) )
$new-map2B-z: map-merge-z($list-map-z, (delta epsilon));
// -> ( alpha ( beta ( gamma 3 ) ), ( delta epsilon ) )
$new-map3-z: map-merge-z($list-map-z, (delta 4, epsilon 5));
// -> ( alpha ( beta ( gamma 3 ) ), ( delta 4 ), ( epsilon 5 ) )
$new-map4-z: map-merge-z($list-map-z, delta, epsilon, 5);
// -> ( alpha ( beta ( gamma 3 ) ), ( delta ( epsilon 5 ) ) )
```

##### 6. UNIFIED SYNTAX: `get()`, `merge()`, `set()`

Note that in the above 'advanced' examples, the `-z` suffixed functions work like their 'simple' counterparts if given only two arguments, which means they can transparently replace them and will respond to the number of 'key' arguments required. Moreover, `map-merge-z($list, $key[s...], $value)` and `map-merge-z($list1, $list2)` argument patterns are interchangeable, which means that `map-merge-z()` can be treated as if it were `map-set-z()`, which can be a more intuitive semantic. The following aliases are provided—as of version 0.9.2—to unify and simplify all of the above list-map logic to three universal functions:

```scss
@import "sass-list-maps";

// get($list, $key[s...])
// accepts 1 or more key args as target, returns value
@function get($args...) { @return map-get-z($args...); }

// merge($list1, [$keys...,] $list2)
// accepts 0 or more key args as target, merges list at target
@function merge($args...) { @return map-merge-z($args...); }

// set($list, $key[s...], $value)
// accepts 1 or more key args as target, sets value at target
@function set($args...) { @return map-merge-z($args...); }
```

### Caveats

There are a few points that bear mentioning/repeating:

* operating on global variables in libsass and in ruby-sass 3.2.x or earlier, works differently than in 3.3.x+: You can make changes to global variables from inside a mixin scope but you can't create them from there. There is no `!global` flag. This has implications for mixins that operate on global list-maps.
* as noted, the 'list-map' syntax is less forgiving than that of native maps (watch your commas). Also, it lacks any error-checking (e.g. native maps will produce a warning if you have duplicate keys). And obviously fancy features of native maps such as passing a map to a function in the form `my-function($map...)` whereupon you can reference the key/value elements inside the function as if they were named variables, doesn't work with list-maps.
* as of this writing, this code contains no test-suites or inline error-catches or warnings of any kind. I've been using it in my own work but there are surely edge-cases I haven't seen. I welcome reports and contributions!

### To-Dos

* Make a depth-based version of `map-remove()`
* Push a native maps version of the 'advanced' functions above

### Acknowledgements

First and foremost, gratitude to the core Sass devs (@nex3 and @chriseppstein) for their tireless advancement of the gold-standard of CSS pre-processing, and secondly to @jedfoster and @anotheruiguy for [Sassmeister](http://sassmeister.com/), which makes developing complex functions and mixins relatively painless.

Also acknowledgements to @HugoGiraudel for [SassyLists](http://sassylists.com/), from which I adapted some early functions, and especially for his list `debug()` function, without which I would not have been able to figure out what was going on (and going wrong) in ruby-sass 3.2.x and libsass.