# Markdown Format Description

__Markdown__ [^1] is a lightweight markup language created with the goal of writing readable and easily editable text that can be converted to HTML and other formats. It was developed by John Gruber and Aaron Schwartz in 2004.

## Text formatting

The unformatted text can be divided into paragraphs by separating them with two line breaks. Separating lines with only one line break will not split the paragraphs [^2].

```markdown
The first paragraph.
The same paragraph.

The second paragraph.
```

The markup language allows you to create text highlights:

```markdown
*italic*
**bold**
~~strikethrough~~
```

## Headers

The markup language allows you to create headers of six levels:

```markdown
# Header 1
## Header 2
## Header 3
### Header 4
#### Header 5
#### Header 6
```

## Lists

The markup language allows you to create ordered and unordered lists.

Example of defining an unordered list:

```markdown
* element 1
* element 2
  * nested element 2.1
  * nested element 2.2
* element 3
```

Example of defining an ordered list:

```markdown
1. element 1
2. element 2
3. element 3
```

## Links

Links are defined using square brackets and round brackets, where the link text and link address are specified, respectively. Examples of links to external resources:

```markdown
[Wiki GIT](https://ru.wikipedia.org/wiki/Git)
[Pro GIT](https://git-scm.com/book/ru/v2)
```

Internal links refer to headers within the document.

```markdown
[link text](#header)
```

## Images

To insert images, the link syntax is used, but an exclamation mark is placed before the link address.

```markdown
![alternate text](image-address)
```

## Code

To insert code in a line, backticks are used.

```markdown
`code`
```

If you need to insert a code block, then three backticks are used. In this case, the programming language (styles, markup) is specified immediately after opening the block.

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

## Bibliography

[^1]: [Wiki Markdown](https://ru.wikipedia.org/wiki/Markdown)
[^2]: [Markdown Guide](https://www.markdownguide.org/)
