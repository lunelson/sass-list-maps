## Sass List–Maps

These functions provide a forward-compatible polyfill for map (hash) data-type functionality in [libsass](http://libsass.org/) and [ruby-sass](http://sass-lang.com/) 3.2.x using the SassScript `list` data-type. They feature-match all the current native (ruby-sass) `map` functions, and add nested (or 'chained') `get()`, `set()` and `merge()` functions and inspection / debugging functions as well.

![](sass-hash.jpg)

#### Updates

* 1.0.0-b3 -- altered use of `list-map-check()` in `map-get()` and `map-get-z()` functions, to avoid double-wrapped-output edge case
* 1.0.0-b2 -- updated `map-remove()` function to allow removing multiple keys; conformant to ruby-sass 3.4.
* 1.0.0-b -- preparing for 1.0; added npm distribution and newly commented source code thanks to Hugo Giraudel. Next version will use SassDoc-style comments.
* 0.9.9 -- added `map-pretty()` function to inspect/debug list-maps in pretty-printed form
* 0.9.6-0.9.8 -- argument-handling enhancements; typo fixes
* 0.9.3-0.9.5 -- handling single-pair lists automatically. This means no more need for `list()` or `zip()` functions, which are now deprecated.
* 0.9.2 -- improved merge performance with new `set-nth()` function; included `get()`, `merge()`, and `set()` aliases by default
* 0.9.1 -- now listed at the [sache.in](http://www.sache.in/) directory of Sass & Compass Extensions

#### Try it

You can test-drive these functions at [Sassmeister, in this pre-loaded gist](http://sassmeister.com/gist/29b2e72c4c7df859ec10)—but note that the libsass version at Sassmeister might be a couple of point-releases behind this repo.

#### Install it

'Sass List-Maps' can be installed as a Bower component or NPM module for non-ruby setups (see [node-sass options](http://github.com/sindresorhus/grunt-sass#includepaths) if you are using libsass via node) or as a gem-based Compass extension for ruby setups:

```sh
# installation with npm
npm install sass-list-maps

# installation with bower
bower install sass-list-maps

# if using grunt-sass, you might want to set 'includePaths'
# to match install location of bower or npm.
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

You can of course also just fork or download this repo or copy-and-paste, as the functions are all in one file.

### Introduction

Maps (known in programming as hashes, dictionaries, or objects<sup>1</sup>) allow dynamic creating, setting, merging and retrieving of data. They are native to ruby-sass as of version 3.3.x, but for earlier ruby-sass versions, and for the libsass C-based compiler (until the point at which maps are integrated there natively), this is an alternative solution which feature-matches ruby-sass' 3.3.x map functionality using the `list` data-type. 

Some additional functions are also provided to allow nested (chained) getting and merging/setting, and inspection for debugging.

*<sup>1</sup>objects (as in javascript) are not exactly the same thing as maps and hashes, but for these purposes close enough.*

#### Syntax

Compared to ruby-sass' native maps, 'list-maps' are lists like any other list in Sass, but they are *lists of pairs*, formatted in such a way as to be interpreted like a map. To this purpose, the first item in each pair is interpreted as the 'key', while the second is interpreted as the correspondent 'value'. This 'value' can be any Sass-script data-type, including a list—which means list-maps can contain other list-maps, allowing them to form nested data structures. The formatting used here keeps as close as possible to the syntax of native maps, with the difference that there no colons (`:`) used. 

*NB: in ruby-sass 3.2.x or lower, the placement of commas is also very critical (no comma after the last item); but in libsass as of 2.0 you can put commas after each item if you wish.*

```scss
/* a single-line list-map -- compatible with any
version/compiler of sass including 3.3+ */
$list-map: ( alpha 1, beta 2, gamma 3 );

/* a single-line ruby-sass native map
-- would cause an error in any version/compiler
other than ruby-sass 3.3+ */
$native-map: ( alpha: 1, beta: 2, gamma: 3,);

/* a multi-line list-map */
$list-map-z: (
  alpha (
    beta (
      gamma 3
    )
  )
);

/* a mutli-line ruby-sass native map */
s$native-map-z: (
  alpha: (
    beta: (
      gamma: 3,
    ),
  ),
);
```

It should be clear that 'list-maps' and ruby-sass 'native' maps are very similar—in fact, they are in principle the same. For this reason it was possible to reverse engineer the map functions of ruby-sass' 3.3+ to use the SassScript `list` data-type. Moreover, as with native maps in ruby-sass, list functions (e.g. `nth()`, `index()`) can be used on list-maps, since they are still lists.

### The Functions

These functions have the same names as the built-in map functions in ruby-sass >= 3.3.x, which means that if they were used in ruby-sass 3.3.x or higher they would conflict with (or at least overwrite) the built-in ones. Therefore, the following code assume you are using either ruby-sass 3.2.x or earlier, or libsass (currently 2.1b). 

#### Core (matching the ruby-sass 3.3.x native map functions)

###### 1. `map-keys($list)`, `map-values($list)`, `map-has-key($list, $key)`

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

###### 2. `map-get($list, $key)`

```scss
@import "sass-list-maps";

$list-map: ( alpha 1, beta 2, gamma 3 );

.demo {
  out: map-get($list-map, alpha); //-> 1
  out: map-get($list-map, beta); //-> 2
  out: map-get($list-map, gamma); //-> 3
}
```

###### 3. `map-merge($list1, $list2), map-remove($list, $key)`

```scss
@import "sass-list-maps";

$list-map: ( alpha 1, beta 2, gamma 3 );

$new-map: map-merge($list-map, gamma 4);
// -> $new-map = ( alpha 1, beta 2, gamma 4 )

$short-map: map-remove($list-map, alpha);
// -> $short-map = ( beta 2, gamma 3)
```

**NB**: you might notice in the second example above, that the second argument to map-merge isn't really a 'list-map' it's just a list of two items. This is the so-called "single item" list conundrum in Sass. As of v0.9.5 these functions handle this type of input so the API can mimic the native syntax as closely as possible.

#### Advanced (beyond the ruby-sass 3.3.x native map functions)

In addition to ruby-sass' native map functionality, this library also provides nested (deep / chained) 'get' and 'set'/'merge' and debugging functions.

##### Nesting / Chaining

###### 4. `map-get-z($list, $keys...)`

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

###### 5. `map-merge-z($list, $keys-and-value...)`

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

##### Inspection / Debugging

###### 6. `map-inspect()`, `map-pretty()`

To aid in development, list-map inspection functions are provided. `map-inspect()` will format a list-map as a string on one line, while `map-pretty()` will format the same string on multiple lines with indentation.

```scss
@import "sass-list-maps";

$testmap: (
  alpha (
    beta 2,
    gamma (
      delta 14,
      epsilon 2
    )
  ),
  zeta 1,
  eta (
    theta 55
  )
);

.debug {
  inspect: map-inspect($testmap);
  pretty: map-pretty($testmap);
}
```
```css
.debug {
  inspect: '(alpha (beta 2, gamma (delta 14, epsilon 2)), zeta 1, eta (theta 55))';
  pretty: '(
    alpha (
      beta 2,
      gamma (
        delta 14,
        epsilon 2
      )
    ),
    zeta 1,
    eta (
      theta 55
    )
  )'; }
```

##### One Syntax to Rule them All

###### 7. `get()`, `merge()`, `set()`

Since the 'advanced' nested/chained `map-get-z()` and `map-merge-z()` take a variable number of `$keys`, and `map-merge-z()` can accept argument patterns consistent with both merge- and set-style operations, the following aliases can provide unified function syntaxes to replace the 'core' `get()` and `merge()` functions while adding a `set()` function:

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

* operating on global variables in libsass and in ruby-sass 3.2.x or earlier works differently than in 3.3.x and later: You can make changes to global variables from inside a mixin scope but you can't create them from there. There is no `!global` flag. This has implications for how you declare and change global variables.
* there is no error-checking for the data-type itself (e.g. native maps will produce a warning if you have duplicate keys). 
* special features of native maps in ruby-sass, such as passing a map to a function in the form `my-function($map...)` whereupon you can reference the key/value pairs inside the function as if they were named variables, doesn't work here.
* as noted, the 'list-map' syntax is in ruby-sass 3.2.x or earlier is still less forgiving than that of native maps (watch your commas), but it's a bit more easygoing in libsass, which is the more likely use-case.
* as of this writing, this code contains no test-suites or inline error-catches or warnings of any kind. I've been using it in my own work and incrementally optimizing it, but I welcome reports and contributions!

### To-Dos

* Push a SassDoc documented version (this will be 1.0.0 final)
* Implement an error/warning system (probably 1.1.0)
* Push a native maps version of the 'advanced' functions above

### Acknowledgements

First and foremost, gratitude to the core Sass devs (@nex3 and @chriseppstein) for their tireless advancement of the gold-standard of CSS pre-processing, and secondly to @jedfoster and @anotheruiguy for [Sassmeister](http://sassmeister.com/), which makes developing complex functions and mixins relatively painless.

Also acknowledgements to @HugoGiraudel for [SassyLists](http://sassylists.com/), from which I adapted some early functions, and especially for his list `debug()` function, without which I would not have been able to figure out what was going on (and going wrong) in ruby-sass 3.2.x and libsass.