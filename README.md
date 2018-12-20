# rasa/keepass_importer

Import the following folders in the [KeePass](https://sourceforge.net/projects/keepass) project into git:

* [KeePass 1.x](https://sourceforge.net/projects/keepass/files/KeePass%201.x/)
* [KeePass 2.x](https://sourceforge.net/projects/keepass/files/KeePass%202.x/)
* [Translations 1.x](https://sourceforge.net/projects/keepass/files/Translations%201.x/)
* [Translations 2.x](https://sourceforge.net/projects/keepass/files/Translations%202.x/)

The [Plugins](https://sourceforge.net/projects/keepass/files/Plugins/) folder is not imported, as the code has not been update since 2009.

## Getting Started

Create four repositories on github:
1. [keepass1](https://github.com/rasa/keepass1)
2. [keepass2](https://github.com/rasa/keepass2)
3. [keypass1_translations](https://github.com/rasa/keepass1_translations)
4. [keypass2_translations](https://github.com/rasa/keepass2_translations)

Run:

```shell
make
```

## Authors

* Dominik Reichl - Author of KeePass - (https://www.dominik-reichl.de/)
* Ross Smith II - Author of keepass_importer - [@rasa](https://github.com/rasa)

See also the list of [contributors](https://github.com/rasa/keepass_importer/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Many thanks to [Dominik Reichl](https://www.dominik-reichl.de/) for creating KeePass 1 and 2.
