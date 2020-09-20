xdel recursive delete for Color Maximite2 by Epsilon
----------------------------------------------------
Version 0.1

xdel.bas allows you to recursively delete a directory and all its contents.
xdel.bas also lets you delete files in the current directory matching a filespec. See example below.

Example 1: Recursively deleting directory
-----------------------------------------
> list files
A:/
   <DIR>  bak
   <DIR>  psgdemo
...
14:24 18-09-2020       3042  xdel.bas
3 directories, 12 files

> *xdel psgdemo
Recursive Delete 0.1 by Epsilon
Delete dir(s) psgdemo
Are you sure? (Y/N)? y
  Processing dir psgdemo
  Removing file .gitattributes
  Removing file psgdemo.bas
  Removing file psgmini.inc
  Removing file README.md
    Processing dir .git
      Processing dir logs
      Processing dir objects
        Processing dir 91
        Processing dir 9f
        ...
Done.

> list files
A:/
   <DIR>  bak
...
14:24 18-09-2020       3042  xdel.bas
2 directories, 12 files

Example 2: Deleting files using fspec
-------------------------------------
> list files
A:/
13:59 18-09-2020          23  test1.bas
13:59 18-09-2020          23  test2.bas
14:24 18-09-2020        3042  xdel.bas

> *xdel test*
Recursive Delete 0.1 by Epsilon
Delete file(s) test*
Are you sure? (Y/N)? y
Removing test1.bas
Removing test2.bas
Done.

> list files
A:/
14:24 18-09-2020        3042  xdel.bas
