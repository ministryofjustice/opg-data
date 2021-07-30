# opg-data

This repository contains shared packages and infrastructure code used by various integration points into the case management system used by The Office of The Public Guardian, Sirius.

## Creating shared packages

### Preparing your code

The main thing to get right is the folder structure.

Create a new folder in the `shared_code` directory. This will hold all of the code and settings for your package. The name doesn't matter here, just call it something sensible.

To create a project locally, create the following file structure:

```bash
[[package_name_holding_folder]]
└── [[package_name]]
    └── __init__.py
```

### Creating the package files

You will now create a handful of files to package up this project and prepare it for distribution. Create the new files listed below and place them in the project’s root directory - you will add content to them in the following steps.

```bash
[[package_name_holding_folder]]
├── LICENSE
├── README.md
├── [[package_name]]
│   └── __init__.py
├── setup.py
└── tests
```

### Creating setup.py

`setup.py` is the build script for [setuptools](https://packaging.python.org/key_projects/#setuptools). It tells setuptools about your package (such as the name and version) as well as which code files to include.

Open `setup.py` and enter the following content.

```python
import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="[[package_name]]",
    version="0.0.1",
    author="OPG",
    author_email="example@digital.justice.gov.uk",
    description="Sirius Service",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/ministryofjustice/opg-data",
    packages=setuptools.find_namespace_packages(include=['[[package_name]]']),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.7",
)

```

This is a very simple version of `setup.py`, you can make this [much more complicated](https://packaging.python.org/guides/distributing-packages-using-setuptools/#setup-py) if you need to. This example version uses `find_namespace_packages` to ensure we just build only the project files and don't include things like tests and other unneccessary files.

### Packaging and uploading to PyPi

1. Install the requirements:

```bash
cd shared_code
pip3 install -r requirements
```

2. Package your code:

```bash
python3 setup.py sdist bdist_wheel
```

3. Upload to the repo:

```bash
python3 -m twine upload dist/*

username: __token__
password: You'll need to obtain this from AWS SecretsManager in the Management Account.
```

### Using your package in another project

1. Install using pip in the usual way

```
pip3 install opg_sirius_service==0.0.1
```

