import setuptools

with open("sirius_service.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="opg_sirius_service",
    version="0.0.1",
    author="OPG",
    author_email="example@digital.justice.gov.uk",
    description="Sirius Service",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/ministryofjustice/opg-data",
    packages=setuptools.find_namespace_packages(include=['opg_sirius_service']),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.7",
)
