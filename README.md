# xcode-product


**Note:** you can find a newer developing verion here:
     [hx-xcode.el](https://gist.github.com/hex2010/51b76375f8f645aaceb8b4dd9afade45) (on gist)



	Launch xcode products (build results) from within emacs.

	This script depends on ivy https://github.com/abo-abo/swiper

	Usage:


```lisp

	(require 'xcode-product)
	(global-set-key (kbd "f6") 'xcode-product-launch)


```



![screenshot](./xcode-product-screenshot.png)

 这是我首个lisp程序习作, 经测试能在 Xcode 7.3 默认环境下工作.
