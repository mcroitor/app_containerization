# Описание Markdown формата

__Markdown__ [^1] - это легковесный язык разметки, созданный с целью написания читаемого и легко редактируемого текста, который может быть преобразован в HTML и другие форматы. Он был разработан Джоном Грубером и Аароном Шварцем в 2004 году.

## Форматирование текста

Сплошной текст можно разбить на абзацы, разделяя их двумя переводами строки. Отделение строк только одним переводом строки не приведет к разделению абзацев [^2].

```markdown
Первый абзац.
Тот же абзац.

Второй абзац.
```

Язык разметки позволяет создавать текстовые выделения:

```markdown
*курсив*
**жирный**
~~зачеркнутый~~
```

## Заголовки

Язык разметки позволяет создавать заголовки шести уровней:

```markdown
# Заголовок 1
## Заголовок 2
## Заголовок 3
### Заголовок 4
#### Заголовок 5
#### Заголовок 6
```

## Списки

Язык разметки позволяет создавать упорядоченные и неупорядоченные списки.

Пример определения неупорядоченного списка:

```markdown
* элемент 1
* элемент 2
  * вложенный элемент 2.1
  * вложенный элемент 2.2
* элемент 3
```

Пример определения упорядоченного списка:

```markdown
1. элемент 1
2. элемент 2
3. элемент 3
```

## Ссылки

Ссылки определяются с помощью квадратных скобок и круглых скобок, в которых указывается текст ссылки и адрес ссылки соответственно. Пример ссылок на внешние ресурсы:

```markdown
[Wiki GIT](https://ru.wikipedia.org/wiki/Git)
[Pro GIT](https://git-scm.com/book/ru/v2)
```

Внутренние ссылки ссылаются на заголовки внутри документа.

```markdown
[текст ссылки](#заголовок)
```

## Изображения

Для вставки изображений используется синтаксис ссылок, но перед адресом ссылки ставится восклицательный знак.

```markdown
![alt-текст](адрес_изображения)
```

## Код

Для вставки кода в строке используются символы обратной кавычки.

```markdown
`код`
```

Если необходимо вставить блок кода, то используются три обратные кавычки. В этом случае, сразу после открытия блока указывается язык программирования (стилей, разметки).

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

## Библиография

[^1]: [Wiki Markdown](https://ru.wikipedia.org/wiki/Markdown)
[^2]: [Markdown Guide](https://www.markdownguide.org/)