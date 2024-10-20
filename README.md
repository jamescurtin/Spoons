# Personal Spoons

Collection of personal [Hammerspoon](https://www.hammerspoon.org/) spoons.

## Local development

```bash
git clone --recurse-submodules -j8 https://github.com/jamescurtin/Spoons.git
cd Spoons

bin/install.sh
pre-commit install
```

## Build

A zip file containing all spoons as well as documentation should be re-generated
after each change that is made. To do so, run:

```bash
bin/publish.sh
```

This is enforced via a pre-commit hook.
