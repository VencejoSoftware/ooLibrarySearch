[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/VencejoSoftware/ooLibrarySeach.svg?branch=master)](https://travis-ci.org/VencejoSoftware/ooLibrarySeach)

# ooLibrarySeach - Object pascal library path finder
Code to search for a library path

### Documentation
If not exists folder "code-documentation" then run the batch "build_doc". The main entry is ./doc/index.html

### DLL search example
```pascal
uses
  LibrarySeach, WinLibrarySearch;
...
  ShowMessage(TWinLibrarySeach.New(['C:\']).Find('twain_32.dll'));
```

### Demo
See the project example at the demo folder.

## Dependencies
* [ooGeneric](https://github.com/VencejoSoftware/ooGeneric.git) - Generic object oriented list

## Built With
* [Delphi&reg;](https://www.embarcadero.com/products/rad-studio) - Embarcadero&trade; commercial IDE
* [Lazarus](https://www.lazarus-ide.org/) - The Lazarus project

## Contribute
This are an open-source project, and they need your help to go on growing and improving.
You can even fork the project on GitHub, maintain your own version and send us pull requests periodically to merge your work.

## Authors
* **Alejandro Polti** (Vencejo Software team lead) - *Initial work*