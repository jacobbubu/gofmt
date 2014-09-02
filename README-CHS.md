# gofmt

gofmt 是 go 语言 `fmt.Printf` Node.js 的对照实现。

`fmt.Printf` 的完整规范请参考 [http://golang.org/pkg/fmt](http://golang.org/pkg/fmt)。

## 快速使用

### 安装

`npm install gofmt --save`

### 使用

``` js
var sprintf = require('gofmt')()

console.log(sprintf("Hello, %s", "world!"))   // Hello, world!
console.log(sprintf("%4.2f%%", 72.426))       // 72.43%  %% -> %
```

## 术语

```
%   #-0       4      .    2           f
   flags    width     presision     verbs
```

### flags

```
+   对于数字，无论正负都输出符号
    guarantee ASCII-only output for %q (%+q)
-   当不满足最小宽度时，左对齐，并且在右边填充空格
#   告诉 verb 用预定义的另一种形式输出，例如：对八进制输出(%#o)加前导'0', 为十六进制输出(%#x)加前导'0x';
    对于 verb %q, 如果操作数是 string, 用 backquoted 替代引号;
' ' 对于数字，如果是正数，符号位用空格；
    对于字符串的十六进制输出，在字节间加空格
0   用 '0' 替代空格替代填充字符（右对齐时）;
    对于数字，0被填充在正负号之前。
```

### Width and Precision

Width 用来指定输出的最小宽度。如果输出不足最小宽度，将会被补齐到最小宽度（根据 flags 的设置）。

对于数字，Precision 用来指定其小数点精度。而对于字符串，则用来设置操作数转化为字符串之后的最大宽度（用来截断字符串）。

```
%f:    default width, default precision
%9f    width 9, default precision
%.2f   default width, precision 2
%9.2f  width 9, precision 2
%9.f   width 9, precision 0
```

不同的 verb 对 Precision 的缺省值有不同的设定。

## 详细说明

上例中，`%s`, `%f`, `%%` 中的 s, f, % 称为 `verbs`，下面分别说明:

### 通用 `verbs`：

```
%v: 和 %s 相同，下文介绍
%T: 输出当前参数值的类型
%%：输出百分号，该 `verb` 并不消费参数值
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

### %t - Boolean：

%t  输出参数值的布尔结果，对于数字，非零为 `true`; 字符串是空串为 `false`; `null` 和 `undefined` 是 `false`; 项数为 0 的 Array 是 `false`。

``` js
console.log(sprintf("%t", true))            // true
console.log(sprintf("%t", 1))               // true
console.log(sprintf("%t", 0))               // false
console.log(sprintf("%t", ''))              // false
console.log(sprintf("%t", new Array()))     // false
```

### %b - 二进制：

对于整数，输出其二进制值；对于浮点数，输出其二进制科学计数法的表现形式。

``` js
console.log(sprintf("%b", 1024))           // 10000000000
console.log(sprintf("%b", 1.1))            // 4953959590107546p-52
console.log(sprintf("%b", -0.3))           // -5404319552844595p-54
```

### %c - 将 Unicode 代码转化为字符(类似 String.fromCharCode)：

``` js
console.log(sprintf("%cBCD", 65))           // ABCD
console.log(sprintf("%c国", 20013))         // 中国
```

### %d - 输出一个数字的整数形式（截断而非四舍五入）：

``` js
console.log(sprintf("%d", 1.5))             // 1
console.log(sprintf("%+d", 1.5))            // +1     flag '+', 输出符号
console.log(sprintf("% d", 1.5))            // ' 1'   flag ' ', 保留正负号的位置
console.log(sprintf("%4d", 1.5))            // '   1' 最小宽度为4位, 缺省向右对齐，不足补空格
console.log(sprintf("%04d", 1.5))           // 0001   flag '0', 向右对齐时不足补0
console.log(sprintf("%-4d", 1.5))           // '1   ' flag '-', 向左对齐
```

各个 flags 和宽度和精度的用法后文有讲解，也不仅仅限于 `%d`。

### %o - 输出数值的八进制形式：

``` js
console.log(sprintf("%o", 1))               // 1
console.log(sprintf("%.3o", 1))             // 001   精度为3，因此补足3位输出
console.log(sprintf("%#o", 1))              // 01    flag '#'，如果输出值的最左一位不是'0'，则在之前添加一个'0'
```

### %q：

对于整数，输出其对应的字符（用单引号括起），不可见字符都被转义显示。

对于字符串，输出值用双引号括起，并且其所有的不可见字符都被转义显示。

``` js
console.log(sprintf("%q", 65))               // 'A'
console.log(sprintf("%q", 7))                // '\t'  制表符 ASCII 7 被转义为 '\t'
console.log(sprintf("%q", 0x038b))           // '\u038b'  '\u038b' 也是一个不可见字符
console.log(sprintf("%q", "\u038b\tabc"))    // "\u038b\tabc"  字符串中的不可见字符都被转义了，并且被双引号括起
console.log(sprintf("%#q", "\tabc"))         // 不进行转义，但是用单引号替代了双引号
```

### %x, %X - 十六进制输出：

%x, %X 区别是输出中的 x, a-f 是用大写的还是小写的。例如，是 `0x0a` 还是 `0X0A`。

对于数字参数：

``` js
console.log(sprintf("%x", 65536))             // 10000
console.log(sprintf("%.4x", 255))             // 00ff
console.log(sprintf("%#.4x", 255))            // 0x00ff flag '#' 表示加 '0x' 前导
console.log(sprintf("%#.4x", -255))           // -0x00ff
console.log(sprintf("%#.4X", -255))           // -0X00FF
```

对于字符串参数：

``` js
console.log(sprintf("%x", "abc"))              // 616263
console.log(sprintf("%#x", "abc"))             // 0x616263
console.log(sprintf("% x", "abc"))             // 61 62 63, flag ' ' 表示每个字符分开显示
console.log(sprintf("% #x", "abc"))            // 0x61 0x62 0x63
console.log(sprintf("% #x", "中文ABC"))        // 0x4e2d 0x6587 0x41 0x42 0x43
```

### %U - 数值的 Unicode 表示输出：

``` js
console.log(sprintf("%U", 65))                // U+0041
console.log(sprintf("%#U", 65))               // U+0041 'A', flag '#' 会指示在 Unicode 输出之后跟一个对应字符输出
console.log(sprintf("%#U", 7))                // U+0007 对于不可见字符则不输出
```

### %e, %E - 数值的科学计数法输出：

%e 和 %E 的区别是输出时 `e` 是否转为大写。

``` js
console.log(sprintf("%e", 1.1))             // 1.100000e+0
console.log(sprintf("%0.20e", 1.1))         // 1.00000000000000000000e+9
console.log(sprintf("%E", 1.1))             // 1.100000E+0
```

缺省小数部分是 6 位，你可以通过指定精度来设定小数部分的长度。

### %f, %F - 浮点数输出：

%f 和 %F 完全同义。

``` js
console.log(sprintf("%f", 1.0))             // 1.000000
console.log(sprintf("%.f", 1.0))            // 1
console.log(sprintf("%4.f", 1.0))           // '   1'
console.log(sprintf("%5.2f", 1.235))        // ' 1.24'
console.log(sprintf("%5.2f", -1.235))       // '-1.23'
```

`%5.2f`，其中，'5' 是最小宽度 (width)，'2' 是精度 (precision)。如果输出结果宽度不到 5,则会在之前自动补足空格。如果指定了 flag '-'，那么意味着左对齐，将在右边补足空格，例如:

``` js
console.log(sprintf("%5.2f", 1.0))       // ' 1.00'
console.log(sprintf("%-5.2f", 1.0))      // '1.00 '
```

flag '0' 表示，当右对齐(没有启用 flag '-')，且其输出没有达到最小宽度时，在左边补 '0'。该 '0' 被补在符号和输出值之间，例如：

``` js
console.log(sprintf("%010.6f", -1.235))       // -01.235000
```

如果数值的小数部分比 precision 的长，那么将被四舍五入（根据正负号的四舍五入）到 precision 的规定长度。如果小数部分短于 precision 的规定长度，那么则在其后补0，例如:

``` js
console.log(sprintf("%.2f", 1))           // 1.00
console.log(sprintf("%.2f", -1.235))      // -1.23
```

### %g, %G - 数值精简输出：

尽量精简地输出数值，且根据数值内容自动决定是否采用科学计数法。%g 和 %G 的区别当使用科学计数法时，'e' 是否采用大写。

``` js
console.log(sprintf("%g", 1))           // 1
console.log(sprintf("%g", 1.234))       // 1.234
console.log(sprintf("%.3g", 1.234))     // 1.23, precision 被用来表示总有效位数
console.log(sprintf("%g", 6666666.6))   // 6.6666666e+6，整数部分 7 位以上转科学计数法
console.log(sprintf("%.3g", 6666666.6)) // 6.67e+6，precision 为科学计数法的小数部分的总有效位数
console.log(sprintf("%.g", 6666666.6))  // 7e+6，precision 为 0 时
```

### %s - 字符串输出

``` js
console.log(sprintf("%s", 1))           // 任何类型都会先转 string
```

### %v - 目前和 %s 是一样的

### %p - 不支持

`%p` 是 golang 的指针类型的输出，在 Javascript 中没有对应的实现。

## Bonus

### %z, %Z - 文件尺寸显示

#### %Z - 以 byte 为单位显示

``` js
console.log(sprintf("%Z", 1024))                // 1.00 kB 缺省以二进制为底，1024=1k
console.log(sprintf("%Z", 1024 * 1024))         // 1.00 MB
console.log(sprintf("%.1Z", 1024 * 1024))       // 1.0 MB
console.log(sprintf("%#Z", 1000 * 1000))        // 1.00 MB flag '#' 表示以十进制为底，1000=1k
```

#### %z - 以 bits 为单位显示

``` js
console.log(sprintf("%z", 1024))                // 8.00 kb 缺省以二进制为底，1024=1k
console.log(sprintf("%z", 1024 * 1024))         // 8.00 Mb
console.log(sprintf("%#z", 1000 * 1000))        // 8.00 Mb flag '#' 表示以十进制为底，1000=1k
```

## 显示参数索引

对于每一个 verb, 其要求的操作数总是顺序向后获取的。不过，我们可以在 verb 之前加一个 `[n]`声明来指定该 verb 需要哪一个操作数（ n 表示第几个操作数，从 1 开始）。

例如：

``` js
sprintf("%[2]d %[1]d\n", 11, 22)
```

将输出"22, 11"，而

 ``` js
 sprintf("%[3]*.[2]*[1]f", 12.0, 2, 6)
 ```

** width 来自于第三个参数，precision 来自于第二个参数，而操作数来自于第一个参数 **

等价于：

 ``` js
 sprintf("%6.2f", 12.0)
 ```

将输出 " 12.00"。

一旦你使用了显示指定的参数索引，那么其后的参数索引将以你最后一次指定的 n 重新开始计数，如下例：

``` js
sprintf("%d %d %#[1]x %#x", 16, 17)
```

将输出 "16 17 0x10 0x11"。其中 `[1]` 将参数计数器重置到了 1。