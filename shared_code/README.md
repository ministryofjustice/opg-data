# General instructions for adding a package to AWS Code Artifact

## Preparing your code

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

### Creating README.md

Open `README.md` and enter the following content. You can customize this if you’d like.

```
# Example Package

This is a simple example package. You can use
[Github-flavored Markdown](https://guides.github.com/features/mastering-markdown/)
to write your content.
```

### Creating a LICENSE

It’s important for every package uploaded to the Python Package Index to include a license. This tells users who install your package the terms under which they can use your package. For help picking a license, see https://choosealicense.com/. Once you have chosen a license, open `LICENSE` and enter the license text. For example, if you had chosen the MIT license:

```
Copyright (c) 2018 The Python Packaging Authority

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Packaging and uploading to CodeArtifact

1. Install the requirements:

```bash
cd shared_code
pip3 install -r requirements
```

2. Package your code:

```bash
python3 setup.py sdist bdist_wheel
```

3. Login to AWS for publishing:

```bash
aws-vault exec management-operator -- aws codeartifact login --tool twine --repository shared-integrations-pip --domain opg-integrations --domain-owner 311462405659 --region eu-west-1
```

4. Upload to the repo:

```bash
python3 -m twine upload --repository codeartifact dist/*
```

## Using your package in another project

1. Login to AWS

```bash
aws-vault exec management-operator -- aws codeartifact login --tool twine --repository shared-integrations-pip --domain opg-integrations --domain-owner 311462405659 --region eu-west-1
```

2. Then install using pip in the usual way

```
pip3 install opg_integrations_shared==0.0.1
```

