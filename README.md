# Advanced Anonymizer

Create *working* anonymous project copies.

## About

For double blinded conferences you often want to provide support material, that allows replication
of your claims, but does not expose your identity.
Projects like [Anonymous 4 Open Science](https://anonymous.4open.science) clear a project from a
provided list of identifiers, but produce no actual git copies that could be afterwards cloned and
executed.    
This little tool is a standalone, offline script to support full replication. It likewise
substitutes a list of provided keywords, but you can select the substitute, and you obtain the
resulting sources, not just a browsable website reflecting the content.  
Likewise, this anonymizer treats file and directory names, and applies the same subsititions. This way you can esure your code is still executable, even after substitution, e.g. if you anonymize package names.

## Usage

* Create a file ```substitutions.txt```, next to the ```anonymize.sh``` script
* Provide binary ```keyword```-```substitute``` tuples, comma separated and escaped by ticks.  
  Example:

```txt
`Maximilian` `anonymousresearcher`
`mcgill` `someuniversity`
...
```

* Call the anonymizer, provide exatly one argument: the location of your folder to anonymize.  
  Example:

```bash
./anonymize ~/Code/BySuperSecretProject
```

### How it works

1) Your original sources are not mofied. The script creates a replacement folder, with
   prefix ```Anonymized...```
2) The anonymizer removes all traces of ```git```, to prevent identification via commit details.
3) The anonymizer seraches for all provided keywords, **Case Sensitive** and replaces all
   occurrences by the specified subsititue.
4) The anonymizer searches once more for all provided keywords, **Case Insensitive** and prints a
   warning for each remaining occurrence.

## Author

* Developer: [Maximilian Schiedermeier](https://www.cs.mcgill.ca/~mschie3/)
* Github: [m5c](https://github.com/m5c)
