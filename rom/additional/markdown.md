# Descrierea formatului Markdown

__Markdown__ [^1] este un limbaj de marcare ușor, creat pentru a scrie texte ușor de citit și editat, care poate fi transformat în HTML și alte formate. A fost dezvoltat de John Gruber și Aaron Swartz în 2004.

## Formatarea textului

Un text continuu poate fi împărțit în paragrafe, separându-le cu două linii goale. Separarea liniilor cu o singură linie nu va duce la separarea paragrafelor [^2].

```markdown
Primul paragraf.
Același paragraf.

Al doilea paragraf.
```

Limbaj de marcare permite crearea formatării textului:

```markdown
*italic*
**bold**
~~stroke~~
```

## Antete

Limbaj de marcare permite crearea antetelor de șase niveluri:

```markdown
# Antet 1
## Antet 2
## Antet 3
### Antet 4
#### Antet 5
#### Antet 6
```

## Liste

Limbajul de marcare permite crearea listelor neordonate și ordonate.

Un exemplu de definire a unei liste neordonate:

```markdown
* element 1
* element 2
  * element imbricat 2.1
  * element imbricat 2.2
* element 3
```

Un exemplu de definire a unei liste ordonate:

```markdown
1. element 1
2. element 2
  1. element 2.1
  2. element 2.2
3. element 3
```

## Referințe

Referințele sunt definite cu ajutorul parantezelor pătrate și rotunde, în care se specifică textul linkului și adresa linkului, respectiv. Exemple de linkuri către resurse externe:

```markdown
[Wiki GIT](https://ru.wikipedia.org/wiki/Git)
[Pro GIT](https://git-scm.com/book/ru/v2)
```

Referințe interne se referă la antetele din document.

```markdown
[corpul referintei](#antet)
```

## Imagini

Pentru inserarea imaginilor se utilizează sintaxa linkurilor, dar înainte de adresa linkului se pune semnul exclamării.

```markdown
![alt-text](referinta-la-imagine)
```

## Cod sursă

Pentru inserarea codului sursă într-o singură linie, se folosesc ghilimele inverse.

```markdown
`cod sursă`
```

Dacă există necesitatea inserării unui bloc de cod, atunci se folosesc trei ghilimele inverse. În acest caz, imediat după deschiderea blocului se specifică limbajul de programare (stiluri, marcare).

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

## Bibliografie

[^1]: [Wiki Markdown](https://ru.wikipedia.org/wiki/Markdown)
[^2]: [Markdown Guide](https://www.markdownguide.org/)
