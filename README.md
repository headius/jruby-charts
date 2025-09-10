JRuby and JFreeCharts Examples
==============================

This repository contains a number of examples of using JRuby and the JFreeCharts library to generate beautiful charts without any external processes or network traffic. JRuby allows you to call JVM-based libraries from the comfort of Ruby!

Running the Examples
--------------------

These examples should work with any recent version of JRuby, but we recommend installing the latest JRuby 10 release using your favorite Ruby installer or downloading from [jruby.org](https://jruby.org).

1. Install a JDK, if you don't already have one. JRuby 10 requires JDK 21+, JRuby 9.4 will work with JDK 8 (also known as 1.8).
2. Install JRuby. Most Ruby installers know about JRuby, but there's also packages for major operating systems. You can also just download a JRuby tarball, unpack it, and put the `bin` dir in your `PATH`. It's that easy!
3. Run `jruby -S lock_jars` from the root of this repository to fetch and install the JFreeChart library.
4. Run any of the scripts in the `examples` directory from the root of this repository!

For example, these commands run from the repository root directory will do the setup and run all the examples, outputting the generated graphs to that same directory:

```bash
jruby -S lock_jars
jruby examples/category_chart.rb
jruby examples/barchart.rb
jruby examples/piechart.rb
jruby examples/bubble_chart.rb
jruby examples/line_chart.rb
```