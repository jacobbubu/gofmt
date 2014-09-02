# gofmt

Chinese reader may go to [Chinese Version](./README-CHS.md).

A golang `fmt.Printf` implementation in Node.js.

Please refer to http://golang.org/pkg/fmt/ for the full specification.

## Quick Use

`npm install gofmt --save`

``` js
var sprintf = require('gofmt')()

console.log(sprintf("Hello, %s", "world!"))   // Hello, world!
console.log(sprintf("%4.2f%%", 72.426))       // 72.43%  %% -> %
```

## Terms

```
%   #-0       4      .    2           f
   flags    width     presision     verbs
```

### flags

```
+   always print a sign for numeric values;
    guarantee ASCII-only output for %q (%+q)
-   pad with spaces on the right rather than the left (left-justify the field)
#   alternate format: add leading 0 for octal (%#o), 0x for hex (%#x);
    0X for hex (%#X); suppress 0x for %p (%#p);
    for %q, print a raw (backquoted) string if strconv.CanBackquote
    returns true;
    write e.g. U+0078 'x' if the character is printable for %U (%#U).
' ' (space) leave a space for elided sign in numbers (% d);
    put spaces between bytes printing strings or slices in hex (% x, % X)
0   pad with leading zeros rather than spaces;
    for numbers, this moves the padding after the sign
```

### Width and Precision

Width is specified by an optional decimal number immediately following the verb. If absent, the width is whatever is necessary to represent the value.

Precision is specified after the (optional) width by a period followed by a decimal number. If no period is present, a default precision is used (depending on different verbs). A period with no following number specifies a precision of zero. Examples:

```
%f:    default width, default precision
%9f    width 9, default precision
%.2f   default width, precision 2
%9.2f  width 9, precision 2
%9.f   width 9, precision 0
```

## Outputs by Verbs

`%s`, `%f` and `%%` that presented in above example we call it `verbs`.

### General `verbs`

```
%v: same as %s
%T: output the type name of current operand
%%：output `%`，it does not consume operand
```

``` js
var sprintf = require('gofmt')()

console.log(sprintf("%T", 1))               // number
console.log(sprintf("%T", {}))              // object
console.log(sprintf("%T", new Error()))     // error
console.log(sprintf("%T", new RegExp()))    // regexp
console.log(sprintf("%T", Array(1)))        // array
console.log(sprintf("%T", null))            // null
console.log(sprintf("%T", undefined))       // undefined
```

### %t - Boolean

%t outputs the boolean result of the operand.

``` js
console.log(sprintf("%t", true))            // true
console.log(sprintf("%t", 1))               // true
console.log(sprintf("%t", 0))               // false
console.log(sprintf("%t", ''))              // false
console.log(sprintf("%t", new Array()))     // false
```

### %b - Binary

For integer, output its base 2 representation. For floating-point output its decimalless scientific notation with exponent a power of two.

``` js
console.log(sprintf("%b", 1024))           // 10000000000
console.log(sprintf("%b", 1.1))            // 4953959590107546p-52
console.log(sprintf("%b", -0.3))           // -5404319552844595p-54
```

### %c - String.fromCharCode

Output the character represented by the corresponding Unicode code point.

``` js
console.log(sprintf("%cBCD", 65))           // ABCD
console.log(sprintf("%c国", 20013))         // 中国
```

### %d - Truncate a number to integer

The floating-point will be truncated but not round.

``` js
console.log(sprintf("%d", 1.5))             // 1
console.log(sprintf("%+d", 1.5))            // +1     flag '+', force to output the sign
console.log(sprintf("% d", 1.5))            // ' 1'   flag ' ', leave a placeholder for positive sign
console.log(sprintf("%4d", 1.5))            // '   1' minimum width is 4
                                            //        align to right by default
                                            //        pad the remaining spaces with ' ' on the left
console.log(sprintf("%04d", 1.5))           // 0001   flag '0'
                                            //        pad the remaining spaces with '0' on the left
console.log(sprintf("%-4d", 1.5))           // '1   ' flag '-'
                                            //        align to the left and always pad with ' '
```

### %o - Base 8

``` js
console.log(sprintf("%o", 1))               // 1
console.log(sprintf("%.3o", 1))             // 001   pad to 3 digits with '0'
console.log(sprintf("%#o", 1))              // 01    flag '#'
                                            //       Add a prefix '0' to the output if the first character isn't '0'.
```

### %q

For integer, the output is a single-quoted string safely escaped with the literal expression of non-printable character.

For string, the output is a double-quoted string safely escaped with the literal expression of non-printable characters.

``` js
console.log(sprintf("%q", 65))               // 'A'
console.log(sprintf("%q", 7))                // '\t'  ASCII 7 has been converted to '\t'
console.log(sprintf("%q", 0x038b))           // '\u038b'  '\u038b' are also non-printable
console.log(sprintf("%q", "\u038b\tabc"))    // "\u038b\tabc"
console.log(sprintf("%#q", "\tabc"))         // '  abc' No escape, but using single-quotes instead of double-quotes
```

### %x, %X - Base 16

%x: with lower-case letters for a-f, e.g. `0x0a`.
%X: with upper-case letters for A-F, e.g. `0X0A`.

Operand is a number:

``` js
console.log(sprintf("%x", 65536))             // 10000
console.log(sprintf("%.4x", 255))             // 00ff
console.log(sprintf("%#.4x", 255))            // 0x00ff flag '#' add '0x' as prefix
console.log(sprintf("%#.4x", -255))           // -0x00ff
console.log(sprintf("%#.4X", -255))           // -0X00FF
```

Operand is a string:

``` js
console.log(sprintf("%x", "abc"))              // 616263
console.log(sprintf("%#x", "abc"))             // 0x616263
console.log(sprintf("% x", "abc"))             // 61 62 63, flag ' ' separate each characters
console.log(sprintf("% #x", "abc"))            // 0x61 0x62 0x63
console.log(sprintf("% #x", "中文ABC"))        // 0x4e2d 0x6587 0x41 0x42 0x43
```

### %U - Unicode format for number

``` js
console.log(sprintf("%U", 65))                // U+0041
console.log(sprintf("%#U", 65))               // U+0041 'A', flag '#'
                                              // Both the unicode format and its corresponding character will be outputted
console.log(sprintf("%#U", 7))                // U+0007, omit the non-printable character
```

### %e, %E - Scientific notation：

%e: with lower-case `e`,  e.g. -1234.456e+78
%E: with upper-case `E`,  e.g. -1234.456E+78

``` js
console.log(sprintf("%e", 1.1))             // 1.100000e+0
console.log(sprintf("%0.20e", 1.1))         // 1.00000000000000000000e+9
console.log(sprintf("%E", 1.1))             // 1.100000E+0
```

Default precision is 6.

### %f, %F - Decimal point but no exponent：

%F is synonym for %f.

``` js
console.log(sprintf("%f", 1.0))             // 1.000000
console.log(sprintf("%.f", 1.0))            // 1
console.log(sprintf("%4.f", 1.0))           // '   1'
console.log(sprintf("%5.2f", 1.235))        // ' 1.24'
console.log(sprintf("%5.2f", -1.235))       // '-1.23'
```

Align to the left:

``` js
console.log(sprintf("%-5.2f", 1.0))      // '1.00 '
```

Padding '0' on the left:

``` js
console.log(sprintf("%010.6f", -1.235))       // -01.235000
```

Round to precision:

``` js
console.log(sprintf("%.2f", 1))           // 1.00
console.log(sprintf("%.2f", -1.235))      // -1.23
```

### %g, %G - Compact output for number：

%g: whichever of %e or %f produces more compact output.
%G: using 'E' in scientific notation.

``` js
console.log(sprintf("%g", 1))           // 1
console.log(sprintf("%g", 1.234))       // 1.234
console.log(sprintf("%.3g", 1.234))     // 1.23, precision 被用来表示总有效位数
console.log(sprintf("%g", 6666666.6))   // 6.6666666e+6，整数部分 7 位以上转科学计数法
console.log(sprintf("%.3g", 6666666.6)) // 6.67e+6，precision 为科学计数法的小数部分的总有效位数
console.log(sprintf("%.g", 6666666.6))  // 7e+6，precision 为 0 时
```

### %s - String output

Operand's string output conform to the definitions of width, precision and flags.

``` js
console.log(sprintf("%s", 1))           // any type will be convert to string
console.log(sprintf("%4.2s", 123456))   // '  12', precision in '%s' means maximum width to the operand's string representation
```

### %v - Same as %s

### %p - Does not supported

`%p` is for pointer in golang, there is no counterpart in Javascript.

## Bonus - Verbs not in golang

### %z, %Z - Human readble filesize

%Z: Show the size by byte:

``` js
console.log(sprintf("%Z", 1024))                // 1.00 kB, default is base 2，1024=1k
console.log(sprintf("%Z", 1024 * 1024))         // 1.00 MB
console.log(sprintf("%.1Z", 1024 * 1024))       // 1.0 MB
console.log(sprintf("%#Z", 1000 * 1000))        // 1.00 MB, flag '#' base 10，1000=1k
```

%z: Show the size by bits:

``` js
console.log(sprintf("%z", 1024))                // 8.00 kb, default is base 2，1024=1k
console.log(sprintf("%z", 1024 * 1024))         // 8.00 Mb
console.log(sprintf("%#z", 1000 * 1000))        // 8.00 Mb, flag '#' base 10，1000=1k
```

## Explicit Argument Indexes:

In sprintf, the default behavior is for each formatting verb to format successive arguments passed in the call. However, the notation [n] immediately before the verb indicates that the nth one-indexed argument is to be formatted instead. The same notation before a '*' for a width or precision selects the argument index holding the value. After processing a bracketed expression [n], arguments n+1, n+2, etc. will be processed unless otherwise directed.

For example,

``` js
sprintf("%[2]d %[1]d\n", 11, 22)
```

will yield "22, 11" (index from 1), while

 ``` js
 sprintf("%[3]*.[2]*[1]f", 12.0, 2, 6)
 ```

 equivalent to

 ``` js
 sprintf("%6.2f", 12.0)
 ```

will yield " 12.00".

Because an explicit index affects subsequent verbs, this notation can be used to print the same values multiple times by resetting the index for the first argument to be repeated: 

``` js
sprintf("%d %d %#[1]x %#x", 16, 17)
```

will yield "16 17 0x10 0x11".