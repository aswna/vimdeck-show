# vimdeck-show
Wrappers around [vimdeck](https://github.com/tybenz/vimdeck) and some useful settings for a smooth presentation

## Overview ##
Save your presentation as <code>slides.md</code> and put it into an
empty directory <code>dir</code>.

Start your presentation using <code>bin/show.sh</code> found in this
repository. Example:

    show.sh dir

## Features
### Support for hand-made files
Along with the <code>slides.md</code> you can have hand-made slides,
overriding the vimdeck generated ones. These hand-made files must be put
in the same directory as <code>slides.md</code> as
<code>hm_slideNNN.md</code>. Example:
    hm_slide013.md
    hm_slide042.md

### Last file
<code>etc/last_slide.md</code> appended to the presentation as the last file.

### Vimdeck generated script.vim modification
The files <code>etc/script_pre.vim</code> and <code>etc/script_post.vim</code>
are prepended/appended respectively to the vimdeck generated
<code>presentation/script.vim</code> file.

### Markdown
Put <code>etc/markdown.vim</code> <code>~/.vim/after/ftplugin</code>.

## Notes
### PDF
To create a PDF file use the screenshot images:
    convert $(find -maxdepth 1 -type f -name '*.png' | sort -n | paste -sd\ ) presentation.pdf

### Screen
For saving screenshots of the presentation (to create a pdf) disable the
hardstatus of your GNU screen:
    hardstatus ignore
and put your presentation in full screen (f.i. using F11).
