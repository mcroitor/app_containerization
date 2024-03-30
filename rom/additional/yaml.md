# YAML Cheat Sheet

## Ce este YAML

__YAML (Yet Another Markup Language, YAML Ain't Markup Language)__ este un limbaj de marcare folosit pentru a reprezenta date într-un mod ușor de citit de către oameni. Este adesea folosit pentru a descrie configurații și date care pot fi ușor citite de către oameni și mașini [^1].

YAML face parte din familia de limbaje de marcare care include JSON și XML. Cu toate acestea, spre deosebire de JSON și XML, YAML are un sintaxă mai simplă și ușor de citit.

### Compararea YAML, JSON și XML

Caracteristici YAML:

- cod ușor de înțeles de către oameni;
- sintaxă minimalistă;
- folosit pentru a descrie structuri de date;
- stil încorporat, asemănător cu JSON (YAML este un superset al acestuia);
- suportă comentarii;
- suportă șiruri fără ghilimele;
- funcționalități suplimentare (tipuri de date extensibile, ancoraje relative și mapare a tipurilor cu păstrarea ordinii cheilor).

Aplicații: YAML este cel mai bine potrivit pentru aplicații cu un volum mare de date care utilizează conducte DevOps sau mașini virtuale. În plus, îmbunătățirea citirii datelor va fi utilă în comenzile cu care dezvoltatorii interacționează frecvent.

Caracteristici JSON:

- mai dificil de citit decât YAML;
- cerințe de sintaxă clare și stricte;
- stil încorporat, asemănător cu YAML (unele parsere YAML pot citi fișiere JSON);
- lipsa comentariilor;
- șiruri necesită ghilimele duble.

Aplicații: JSON este folosit în dezvoltarea web - este cel mai bun format pentru serializarea și transmiterea datelor.

Caracteristici XML:

- mai dificil de citit decât JSON și YAML;
- mai mult verbos;
- domeniu de aplicare mai larg (marcare, serializare, transmitere de date);
- posibilitatea de a defini spații de nume;
- mai multe posibilități decât YAML, de exemplu atribute de etichete;
- schemă de document mai rigidă.

Aplicații: XML este ideal pentru proiecte complexe care necesită un control subtil asupra validării, schemei și spațiului de nume. Limbajul are o citire proastă, necesită o capacitate mai mare de bandă și de stocare, dar oferă un control fără precedent [^2].

### Sintaxa YAML

Fișierele YAML constau din perechi cheie-valoare, care pot fi înglobate. Cheile și valorile sunt separate de două puncte și un spațiu. Elementele înglobate sunt separate de elementele părinte cu spații.

```yaml
key: value
parent:
  child1: value1
  child2: value2
```

### Comentarii

Comentariile în YAML încep cu simbolul `#` și continuă până la sfârșitul liniei.

```yaml
# Este un comentariu
key: value
```

### Tipuri scalare

YAML suportă tipuri scalare standard: `int` și `float`, `boolean`, `string` și `null`.

```yaml
int_value: 1
float_value: 3.14
boolean_value: true
string_value: "Hello, World!"
null_value: null
```

### Șiruri de caractere

Șirurile din YAML pot fi scrise cu ghilimele duble sau simple, precum și fără ghilimele.

```yaml
double_quoted: "Hello, World!"
single_quoted: 'Hello, World!'
unquoted: Hello, World!
```

Totodată, se pot defini șiruri pe mai multe linii folosind simbolurile `|` sau `>`.

```yaml
multiline_literal: |
    Hello,
    World!
multiline_folded: >
    Hello, World!
```

### Listele

Listele în YAML sunt o secvență de elemente care încep cu `-` și un spațiu.

```yaml
list:
  - item1
  - item2
  - item3
```

Pot fi folosite și scurtături pentru liste:

```yaml
list: [item1, item2, item3]
```

### Dicționare

Dicționarele în YAML sunt un set de perechi cheie-valoare.

```yaml
dictionary:
  key1: value1
  key2: value2
  key3: value3
```

## Exemple de fișiere YAML

### Exemplu 1

```yaml
# Acesta este un exemplu de fișier YAML
# El descrie o listă de angajați și salariile lor
employees:
  - name: John Doe
    salary: 120000
  - name: Jane Smith
    salary: 100000
  - name: Sam Brown
    salary: 80000
```

### Exemplu 2

```yaml
# Într-un fișier pot fi descrise mai multe documente YAML
# Ele sunt separate de trei linii tiret
---
name: John Doe
age: 30
---
name: Jane Smith
age: 25
```

## Referințe utile

1. [YAML](https://yaml.org/)
2. [Олег Борисенков, YAML за 5 минут: синтаксис и основные возможности, tproger, 2021](https://tproger.ru/translations/yaml-za-5-minut-sintaksis-i-osnovnye-vozmozhnosti)