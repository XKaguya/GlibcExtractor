# GlibcExtractor
A tool used to convinient extra and unstrip glibc to make solving Pwn challenges more convenient and efficient.

# Usage
```
./GlibcExtractor.sh archive archive1
```
e.g.
```
./extract.sh libc6_2.27-3ubuntu1.5_amd64.deb libc6-dbg_2.27-3ubuntu1.5_amd64.deb
```

Or make a soft link.

```
sudo ln -s /home/kaguya/PwnTool/GlibcExtractor.sh /usr/local/bin/GlibcExtractor
```

Now you're able to use `GlibcExtractor` at anywhere.

# Result
```
➜  2.27-1.5 ./GlibcExtractor.sh libc6_2.27-3ubuntu1.5_amd64.deb libc6-dbg_2.27-3ubuntu1.5_amd64.deb
File found: ld-2.27.so, Version: 2.27
Running eu-unstrip: temp/libc/lib/x86_64-linux-gnu/ld-2.27.so -> temp/dbg/usr/lib/debug/lib/x86_64-linux-gnu/ld-2.27.so
File found: libc-2.27.so, Version: 2.27
Running eu-unstrip: temp/libc/lib/x86_64-linux-gnu/libc-2.27.so -> temp/dbg/usr/lib/debug/lib/x86_64-linux-gnu/libc-2.27.so
```
